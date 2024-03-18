// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// for test purposes
contract Blast {
    function configureClaimableGas() external {}

    function claimAllGas(
        address contractAddress,
        address recipient
    ) external returns (uint256) {
        return 0;
    }

    function claimMaxGas(
        address contractAddress,
        address recipient
    ) external returns (uint256) {
        return 0;
    }

    function claimGasAtMinClaimRate(
        address contractAddress,
        address recipient,
        uint256 minClaimRateBips
    ) external returns (uint256) {
        return 0;
    }
}
