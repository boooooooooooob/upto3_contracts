// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventVotingNFT is ERC721, UUPSUpgradeable, Ownable {
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

    function initialize() public initializer {
        __ERC721_init("EventVotingNFT", "EVNFT");
        __Ownable_init();
    }

    function createEvent(
        string memory who,
        string memory what,
        uint256 when
    ) public {
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

        uint256 eventId = totalSupply() + 1;
        _mint(msg.sender, eventId);
        events[eventId] = Event(who, what, when, msg.sender, 0, 0);
        emit EventCreated(eventId, who, what, when, msg.sender);
    }

    function vote(uint256 eventId, bool voteYes) public {
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

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

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
}
