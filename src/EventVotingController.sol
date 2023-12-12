// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./EventVotingNFT.sol";

contract EventVotingController {
    EventVotingNFT public eventVotingNFT;

    uint256 public constant MAX_ACTIONS_PER_DAY = 5; // maximum number of actions per 24 hours
    uint256 public constant DAY_IN_SECONDS = 86400; // seconds in a day

    mapping(address => uint256) public lastActionTime;
    mapping(address => uint256) public actionCount;

    constructor(address _eventVotingNFT) {
        eventVotingNFT = EventVotingNFT(_eventVotingNFT);
        eventVotingNFT.grantRole(eventVotingNFT.CONTROLLER_ROLE, address(this));
    }

    function performAction(uint256 eventId, bool vote) public {
        require(canPerformAction(msg.sender), "Action limit reached for today");

        if (vote) {
            eventVotingNFT.vote(eventId);
        } else {
            // Assuming createEvent is exposed and can be called
            // eventVotingNFT.createEvent(...);
        }

        updateActionCount(msg.sender);
    }

    function canPerformAction(address user) public view returns (bool) {
        if (block.timestamp - lastActionTime[user] > DAY_IN_SECONDS) {
            return true; // More than 24 hours since last action
        }
        return actionCount[user] < MAX_ACTIONS_PER_DAY;
    }

    function updateActionCount(address user) internal {
        if (block.timestamp - lastActionTime[user] > DAY_IN_SECONDS) {
            actionCount[user] = 1;
            lastActionTime[user] = block.timestamp;
        } else {
            actionCount[user]++;
        }
    }
}
