// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTTypeA is ERC721URIStorage, Ownable {
    uint256 private nextTokenId;

    constructor() ERC721("NFTTypeA", "NFTA") {}

    // Mint function for NFTTypeA
    function mint(address to, string memory tokenURI) external onlyOwner {
        _safeMint(to, nextTokenId);
        _setTokenURI(nextTokenId, tokenURI);
        nextTokenId++;
    }

    // Override function to support automatic token ID assignment
    function _baseURI() internal view virtual override returns (string memory) {
        return "https://baseuri.com/nfta/";
    }
}
