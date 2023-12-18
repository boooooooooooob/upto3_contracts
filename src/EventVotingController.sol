// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./EventVotingNFT.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract EventVotingController is Initializable {
    EventVotingNFT public eventVotingNFT;

    uint256 public constant MAX_CREATE_EVENT_PER_DAY = 5;
    uint256 public constant MAX_VOTE_PER_DAY = 5;
    uint256 public constant DAY_IN_SECONDS = 86400;

    mapping(address => uint256) public lastCreateEventTime;
    mapping(address => uint256) public createEventCount;
    mapping(address => uint256) public lastVoteTime;
    mapping(address => uint256) public voteCount;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _eventVotingNFT) public initializer {
        eventVotingNFT = EventVotingNFT(_eventVotingNFT);

        eventVotingNFT.grantRole(
            eventVotingNFT.CONTROLLER_ROLE(),
            address(this)
        );
    }

    function createEvent(
        string memory who,
        string memory what,
        uint256 when
    ) public {
        require(canCreateEvent(msg.sender), "Event limit reached for today");

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

        eventVotingNFT.createEvent(who, what, when);

        updateCreateEventCount(msg.sender);
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
            lastCreateEventTime[user] = block.timestamp;
        } else {
            createEventCount[user]++;
        }
    }

    function vote(uint256 eventId, bool voteYes) public {
        require(canVote(msg.sender), "Vote limit reached for today");

        eventVotingNFT.vote(eventId, voteYes);

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
            lastVoteTime[user] = block.timestamp;
        } else {
            voteCount[user]++;
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
}
