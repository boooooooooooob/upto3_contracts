// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../src/StakingContract.sol";
import "forge-std/Script.sol";

contract DeployStakingContract is Script {
    function run() public {
        // Use address provided in config to broadcast transactions
        vm.startBroadcast();

        StakingContract implementation = new StakingContract();
        // Stop broadcasting calls from our address
        vm.stopBroadcast();
        // Log the contact address
        console.log("Staking Contract Address:", address(implementation));
    }
}
