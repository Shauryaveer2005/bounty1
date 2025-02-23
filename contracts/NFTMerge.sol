// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface INFTTypeA {
    function ownerOf(uint256 tokenId) external view returns (address);
}

interface INFTTypeB {
    function ownerOf(uint256 tokenId) external view returns (address);
}

contract NFTMerge is ERC721URIStorage, Ownable {
    uint256 private nextTokenId;
    address public nftTypeA;
    address public nftTypeB;

    event Merged(address indexed owner, uint256 indexed nftAId, uint256 indexed nftBId, uint256 newTokenId);

    constructor(address _nftTypeA, address _nftTypeB) ERC721("NFTTypeC", "NFTC") {
        nftTypeA = _nftTypeA;
        nftTypeB = _nftTypeB;
    }

    // Merge function to combine NFTs of Type A and Type B into a new NFT Type C
    function merge(uint256 tokenIdA, uint256 tokenIdB) external {
        require(INFTTypeA(nftTypeA).ownerOf(tokenIdA) == msg.sender, "You must own NFT TypeA");
        require(INFTTypeB(nftTypeB).ownerOf(tokenIdB) == msg.sender, "You must own NFT TypeB");

        // Optionally burn NFTs TypeA and TypeB if desired
        // _burn(tokenIdA);
        // _burn(tokenIdB);

        // Mint new merged NFT of type C
        _safeMint(msg.sender, nextTokenId);
        string memory mergedURI = string(abi.encodePacked("https://baseuri.com/nftc/", uint2str(nextTokenId)));
        _setTokenURI(nextTokenId, mergedURI);
        emit Merged(msg.sender, tokenIdA, tokenIdB, nextTokenId);
        nextTokenId++;
    }

    // Utility function to convert uint256 to string
    function uint2str(uint256 _i) internal pure returns (string memory str) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            bstr[--k] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        str = string(bstr);
    }
}
