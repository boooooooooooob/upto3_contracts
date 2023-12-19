// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../src/EventVotingNFT.sol";
import "forge-std/Script.sol";

contract DeployEventVotingNFTImplementation is Script {
    function run() public {
        // Use address provided in config to broadcast transactions
        vm.startBroadcast();
        // Deploy the ERC-20 token
        EventVotingNFT implementation = new EventVotingNFT();
        // Stop broadcasting calls from our address
        vm.stopBroadcast();
        // Log the token address
        console.log("Token Implementation Address:", address(implementation));
    }
}
