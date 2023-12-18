// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract EventVotingNFT is
    Initializable,
    ERC721Upgradeable,
    OwnableUpgradeable,
    AccessControlUpgradeable,
    UUPSUpgradeable
{
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    struct Event {
        string who;
        string what;
        uint256 when;
        address creator;
        uint256 yesVotes;
        uint256 noVotes;
    }

    mapping(uint256 => Event) public events;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(bytes32 => bool) private uniqueEvents;

    event EventCreated(
        uint256 eventId,
        string who,
        string what,
        uint256 when,
        address creator
    );
    event Voted(uint256 eventId, bool vote, address voter);

    bytes32 public constant CONTROLLER_ROLE = keccak256("CONTROLLER_ROLE");

    uint256 private _nextTokenId;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __ERC721_init("EventVotingNFT", "EVNFT");
        __Ownable_init(msg.sender);
        __AccessControl_init();
        __UUPSUpgradeable_init();
    }

    function createEvent(
        string memory who,
        string memory what,
        uint256 when
    ) public onlyRole(CONTROLLER_ROLE) {
        require(
            when >= 1000000000 && when <= 9999999999,
            "Invalid Unix timestamp"
        );

        bytes32 eventKey = keccak256(abi.encodePacked(who, when));
        require(
            !uniqueEvents[eventKey],
            "Event with 'who' and 'when' already exists"
        );
        uniqueEvents[eventKey] = true;

        uint256 eventId = _nextTokenId++;
        _mint(msg.sender, eventId);

        events[eventId] = Event(who, what, when, msg.sender, 0, 0);
        emit EventCreated(eventId, who, what, when, msg.sender);
    }

    function vote(
        uint256 eventId,
        bool voteYes
    ) public onlyRole(CONTROLLER_ROLE) {
        require(_exists(eventId), "Event does not exist.");
        require(
            !hasVoted[eventId][msg.sender],
            "You have already voted for this event."
        );
        require(
            events[eventId].creator != msg.sender,
            "Event creator cannot vote."
        );

        if (voteYes) {
            events[eventId].yesVotes += 1;
        } else {
            events[eventId].noVotes += 1;
        }
        hasVoted[eventId][msg.sender] = true;

        emit Voted(eventId, voteYes, msg.sender);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        Event memory eventInfo = events[tokenId];

        // Encode the JSON metadata directly in the URI
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Event #',
                        Strings.toString(tokenId),
                        '",',
                        '"description": "This NFT represents an event with votes.",',
                        '", "attributes": [',
                        '{"trait_type": "Who", "value": "',
                        eventInfo.who,
                        '"},',
                        '{"trait_type": "What", "value": "',
                        eventInfo.what,
                        '"},',
                        '{"trait_type": "When", "value": "',
                        Strings.toString(eventInfo.when),
                        '"},',
                        '{"trait_type": "YesVotes", "value": "',
                        Strings.toString(eventInfo.yesVotes),
                        '"},',
                        '{"trait_type": "NoVotes", "value": "',
                        Strings.toString(eventInfo.noVotes),
                        '"}',
                        "]}"
                    )
                )
            )
        );

        // Prefix with `data:application/json;base64,` to denote the encoding and data type
        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    // Additional functions like view functions to get event details, vote counts etc.
    function getEvent(
        uint256 eventId
    )
        public
        view
        returns (
            string memory who,
            string memory what,
            uint256 when,
            address creator,
            uint256 yesVotes,
            uint256 noVotes
        )
    {
        require(_exists(eventId), "Event does not exist.");
        Event memory eventInfo = events[eventId];
        return (
            eventInfo.who,
            eventInfo.what,
            eventInfo.when,
            eventInfo.creator,
            eventInfo.yesVotes,
            eventInfo.noVotes
        );
    }

    function isVoted(
        uint256 eventId,
        address voter
    ) public view returns (bool) {
        require(_exists(eventId), "Event does not exist.");
        return hasVoted[eventId][voter];
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
