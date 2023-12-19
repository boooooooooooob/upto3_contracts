// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../src/EventVotingController.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "forge-std/Script.sol";

contract DeployUUPSProxy is Script {
    function run() public {
        address _implementation = 0x562d60dA90925Ea3d69Dae1A6A55D440fc144354; // Replace with your token address
        vm.startBroadcast();

        // Encode the initializer function call
        bytes memory data = abi.encodeWithSelector(
            EventVotingController(_implementation).initialize.selector,
            0x1dB31D9b412Eba16D1fBF3E3Df0952202016589f
        );

        // Deploy the proxy contract with the implementation address and initializer
        ERC1967Proxy proxy = new ERC1967Proxy(_implementation, data);

        vm.stopBroadcast();
        // Log the proxy address
        console.log("UUPS Proxy Address:", address(proxy));
    }
}
