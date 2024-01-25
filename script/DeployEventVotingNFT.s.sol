// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../src/EventVotingNFT.sol";
import "forge-std/Script.sol";

contract DeployEventVotingNFTImplementation is Script {
    function run() public {
        vm.startBroadcast();

        EventVotingNFT implementation = new EventVotingNFT();

        vm.stopBroadcast();

        console.log("Token Implementation Address:", address(implementation));
    }
}
