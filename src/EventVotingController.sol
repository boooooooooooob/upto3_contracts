// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./EventVotingNFT.sol";
import "./StakingContract.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {RedStarEnergy} from "./RedStarEnergy.sol";

contract EventVotingController is
    Initializable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    EventVotingNFT public eventVotingNFT;

    uint32 public constant MAX_CREATE_EVENT_PER_DAY = 5;
    uint32 public constant MAX_VOTE_PER_DAY = 3;
    uint32 public constant DAY_IN_SECONDS = 86400;

    mapping(address => uint32) public lastCreateEventTime;
    mapping(address => uint32) public createEventCount;
    mapping(address => uint32) public lastVoteTime;
    mapping(address => uint32) public voteCount;

    mapping(address => uint256) public honorPoint;

    StakingContract public stakingContract;

    RedStarEnergy public redStarEnergy;
    IERC20 public UPTToken;

    // vote consumption on the energy
    uint256 public constant voteConsumption = 1;
    uint256 public constant createEventConsumption = 5;

    uint256 public constant honorPointFreezePerVote = 2;
    uint256 public constant honorPointFreezePerCreateEvent = 4;

    uint256 public constant honorPointAwardPerVote = 3;
    uint256 public constant honorPointAwardPerCreateEvent = 7;

    uint256 public constant UPTTokenAwardPerVote = 3e18;

    mapping(uint32 => mapping(address => bool)) public hasClaimedHonorPoint;

    IBlast public BLAST;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        address _eventVotingNFT,
        address _redStarEnergy,
        address _UPTToken,
        address _blast
    ) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();

        eventVotingNFT = EventVotingNFT(_eventVotingNFT);
        redStarEnergy = RedStarEnergy(_redStarEnergy);
        UPTToken = IERC20(_UPTToken);

        BLAST = IBlast(_blast);
        BLAST.configureClaimableGas();
    }

    function setStakingContract(address _stakingContract) external onlyOwner {
        stakingContract = StakingContract(_stakingContract);
    }

    function createEvent(
        string memory who,
        string memory what,
        uint32 when
    ) public onlyOwner {
        // require(canCreateEvent(msg.sender), "Event limit reached for today");

        // TODO: Verify 'who' is in the allowed list using the Merkle tree
        // require(isValidWho(who, merkleProof), "Invalid 'who', not in the list");

        // Limit the 'what' string to ASCII characters only
        require(
            isAsciiString(what),
            "The 'what' contains non-ASCII characters"
        );

        // Limit the 'what' string to 280 characters (like Twitter)
        require(
            bytes(what).length <= 280,
            "The 'what' description is too long"
        );

        eventVotingNFT.createEvent(who, what, when, msg.sender);

        // updateCreateEventCount(msg.sender);
    }

    function canCreateEvent(address user) public view returns (bool) {
        if (block.timestamp - lastCreateEventTime[user] > DAY_IN_SECONDS) {
            return true;
        }
        return createEventCount[user] < MAX_CREATE_EVENT_PER_DAY;
    }

    function updateCreateEventCount(address user) internal {
        if (block.timestamp - lastCreateEventTime[user] > DAY_IN_SECONDS) {
            createEventCount[user] = 1;
            lastCreateEventTime[user] = uint32(block.timestamp);
        } else {
            createEventCount[user]++;
        }
    }

    function vote(uint32 eventId, bool voteYes) public {
        require(canVote(msg.sender), "Vote limit reached for today");
        require(
            honorPoint[msg.sender] >= honorPointFreezePerVote,
            "Not enough honor point to vote"
        );

        // event must be in pending or created state
        require(
            keccak256(abi.encodePacked(getEventVotingStatus(eventId))) ==
                keccak256(abi.encodePacked("Pending")) ||
                keccak256(abi.encodePacked(getEventVotingStatus(eventId))) ==
                keccak256(abi.encodePacked("Created")),
            "Event is not in pending or created state"
        );

        redStarEnergy.burnFrom(msg.sender, voteConsumption);

        if (lastVoteTime[msg.sender] == 0) {
            honorPoint[msg.sender] = 100;
        }

        honorPoint[msg.sender] -= honorPointFreezePerVote;

        eventVotingNFT.vote(eventId, voteYes, msg.sender);

        updateVoteCount(msg.sender);
    }

    function canVote(address user) public view returns (bool) {
        if (block.timestamp - lastVoteTime[user] > DAY_IN_SECONDS) {
            return true;
        }
        return voteCount[user] < MAX_VOTE_PER_DAY;
    }

    function updateVoteCount(address user) internal {
        if (block.timestamp - lastVoteTime[user] > DAY_IN_SECONDS) {
            voteCount[user] = 1;
            lastVoteTime[user] = uint32(block.timestamp);
        } else {
            voteCount[user]++;
        }
    }

    function claimHonorPointAndUPT(uint32 eventId) public {
        require(eventVotingNFT.hasVoted(eventId, msg.sender), "Not voted yet");

        require(
            !hasClaimedHonorPoint[eventId][msg.sender],
            "Honor point already claimed"
        );

        bool result = eventVotingNFT.votedResult(eventId, msg.sender);
        // if voted yes and the event is passed then claim honor point
        // if voted no and the event is failed then claim honor point
        if (
            (result &&
                keccak256(abi.encodePacked(getEventVotingStatus(eventId))) ==
                keccak256(abi.encodePacked("Passed"))) ||
            (!result &&
                keccak256(abi.encodePacked(getEventVotingStatus(eventId))) ==
                keccak256(abi.encodePacked("Failed")))
        ) {
            hasClaimedHonorPoint[eventId][msg.sender] = true;
            honorPoint[msg.sender] += honorPointAwardPerVote;

            UPTToken.transfer(msg.sender, UPTTokenAwardPerVote);
        } else {
            revert("Not eligible to claim honor point");
        }
    }

    function getEventVotingStatus(
        uint32 eventId
    ) public view returns (string memory) {
        (, , , , uint256 yesVotes, uint256 noVotes) = eventVotingNFT.getEvent(
            eventId
        );

        // if yesVotes + noVotes > 200 and yesVotes / (yesVotes + noVotes) > 0.7 then return "Passed"
        // if yesVotes + noVotes > 200 and yesVotes / (yesVotes + noVotes) < 0.3 then return "Failed"
        // if yesVotes + noVotes > 200 and yesVotes / (yesVotes + noVotes) >= 0.3 and yesVotes / (yesVotes + noVotes) <= 0.7 then return "Pending"
        // if yesVotes + noVotes <= 200 then return "Created
        if (yesVotes + noVotes > 200) {
            if ((yesVotes * 100) / (yesVotes + noVotes) > 70) {
                return "Passed";
            } else if ((yesVotes * 100) / (yesVotes + noVotes) < 30) {
                return "Failed";
            } else {
                return "Pending";
            }
        } else {
            return "Created";
        }
    }

    function isAsciiString(string memory str) internal pure returns (bool) {
        bytes memory strBytes = bytes(str);
        for (uint i = 0; i < strBytes.length; i++) {
            if (uint8(strBytes[i]) > 0x7F) {
                return false;
            }
        }
        return true;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function claimMyContractsGas() external {
        BLAST.claimMaxGas(address(this), msg.sender);
    }
}
