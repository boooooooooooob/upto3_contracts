// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract UPTMerkleDrop is Ownable, Pausable {
    IERC20 public token;
    bytes32 public merkleRoot;
    IERC721 public passCardNFT;

    mapping(address => bool) public hasClaimed;

    event Claimed(address indexed claimant, uint256 amount);
    event MerkleRootUpdated(bytes32 merkleRoot);

    constructor(IERC20 _token, IERC721 _passCardNFT) Ownable(msg.sender) {
        token = _token;
        passCardNFT = _passCardNFT;
    }

    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
        emit MerkleRootUpdated(_merkleRoot);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function claim(
        uint256 amount,
        bytes32[] calldata proof
    ) external whenNotPaused {
        require(
            !hasClaimed[msg.sender],
            "TokenMerkleDrop: Drop already claimed."
        );
        require(
            passCardNFT.balanceOf(msg.sender) > 0,
            "TokenMerkleDrop: Must own at least one Pass Card NFT."
        );

        bytes32 leaf = _leaf(msg.sender, amount);

        require(_verify(leaf, proof), "TokenMerkleDrop: Invalid proof.");

        hasClaimed[msg.sender] = true;
        require(
            token.transfer(msg.sender, amount),
            "TokenMerkleDrop: Transfer failed."
        );

        emit Claimed(msg.sender, amount);
    }

    function _leaf(
        address account,
        uint256 amount
    ) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(account, amount));
    }

    function _verify(
        bytes32 leaf,
        bytes32[] memory proof
    ) internal view returns (bool) {
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }

    function withdrawTokens(address to) external onlyOwner {
        require(paused(), "TokenMerkleDrop: Contract is not paused.");
        uint256 balance = token.balanceOf(address(this));
        require(
            token.transfer(to, balance),
            "TokenMerkleDrop: Withdraw failed."
        );
    }
}
