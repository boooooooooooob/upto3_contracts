// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../src/EventVotingController.sol";
import "forge-std/Script.sol";

contract DeployEventVotingControllerImplementation is Script {
    function run() public {
        // Use address provided in config to broadcast transactions
        vm.startBroadcast();

        EventVotingController implementation = new EventVotingController();
        // Stop broadcasting calls from our address
        vm.stopBroadcast();
        // Log the token address
        console.log(
            "Controller Implementation Address:",
            address(implementation)
        );
    }
}
