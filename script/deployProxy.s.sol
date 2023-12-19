// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../src/EventVotingNFT.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "forge-std/Script.sol";

contract DeployUUPSProxy is Script {
    function run() public {
        address _implementation = 0xc8E94a05fE0F93f247290dc10D2593e12622CE59; // Replace with your token address
        vm.startBroadcast();

        // Encode the initializer function call
        bytes memory data = abi.encodeWithSelector(
            EventVotingNFT(_implementation).initialize.selector
        );

        // Deploy the proxy contract with the implementation address and initializer
        ERC1967Proxy proxy = new ERC1967Proxy(_implementation, data);

        vm.stopBroadcast();
        // Log the proxy address
        console.log("UUPS Proxy Address:", address(proxy));
    }
}
