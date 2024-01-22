// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../src/EventVotingController.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "forge-std/Script.sol";

contract DeployUUPSProxy is Script {
    function run() public {
        address _implementation = 0xFf073575A5c1A1F0EC0D9aE5f59DE4d8acecFC81; // Replace with your token address
        vm.startBroadcast();

        // Encode the initializer function call
        bytes memory data = abi.encodeWithSelector(
            EventVotingController(_implementation).initialize.selector,
            0xc8E94a05fE0F93f247290dc10D2593e12622CE59
        );

        // Deploy the proxy contract with the implementation address and initializer
        ERC1967Proxy proxy = new ERC1967Proxy(_implementation, data);

        vm.stopBroadcast();
        // Log the proxy address
        console.log("UUPS Proxy Address:", address(proxy));
    }
}
