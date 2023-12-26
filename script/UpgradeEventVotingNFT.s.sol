// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Script.sol";
import "../src/EventVotingNFT.sol";

contract UpgradeContract is Script {
    function run() external {
        vm.startBroadcast();

        address proxyContractAddress = 0x1dB31D9b412Eba16D1fBF3E3Df0952202016589f;
        EventVotingNFT proxy = EventVotingNFT(payable(proxyContractAddress));

        address _newImplementation = 0x8bc67D8BF0dBB3Dcd0d7dF0Aff55f2c3D661d2f6;
        proxy.upgradeToAndCall(address(_newImplementation), "");

        vm.stopBroadcast();
    }
}
