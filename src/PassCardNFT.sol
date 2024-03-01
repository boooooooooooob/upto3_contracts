// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract PassCardNFT is ERC721URIStorage {
    using Strings for uint256;

    string public constant TOKEN_URI = "ipfs://QmYGYSzfemBbYhAsWJgMatiPvTviqUq1po9Qbj5GDGDwgX";
    uint256 public tokenCounter;

    constructor() ERC721("PassCardNFT", "PCNFT") {
        tokenCounter = 0;
    }

    function mint() public {
		tokenCounter++;

        _mint(msg.sender, tokenCounter);
        _setTokenURI(tokenCounter, TOKEN_URI);
    }

    function _update(address to, uint256 tokenId, address auth) internal virtual override returns (address) {
		address from = _ownerOf(tokenId);

		// Prevent transfers by checking if the token already has an owner (not minting) and not burning
		if (from != address(0) && to != address(0)) {
			revert("Transfers are disabled for this NFT");
		}

		return super._update(to, tokenId, auth);
	}
}