// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../src/StakingContract.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "forge-std/Script.sol";

contract DeployUUPSProxy is Script {
    function run() public {
        address _implementation = 0xB866DCbfAaF76ecA00d46309f0f8123Ea6061789; // Replace with your token address
        vm.startBroadcast();

        // Encode the initializer function call
        bytes memory data = abi.encodeWithSelector(
            StakingContract(_implementation).initialize.selector,
            // upt token address
            0xF4bCb898d8EF5816C3b4E58Cce5555633E241B87
        );

        // Deploy the proxy contract with the implementation address and initializer
        ERC1967Proxy proxy = new ERC1967Proxy(_implementation, data);

        vm.stopBroadcast();
        // Log the proxy address
        console.log("UUPS Proxy Address:", address(proxy));
    }
}
