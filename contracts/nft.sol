// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract FilGoodNFT721 is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public maxNFTs;
    uint256 public remainingMintableNFTs;

    struct myNFT {
        address owner;
        string tokenURI;
        uint256 tokenId;
    }

    myNFT[] public nftCollection;

    /* tokenURI
    {
        "name": "Shaburu"
        "description": "NFT created for Text Based Adventure Game and limited to 100 tokens"
        "image": 9cc1a2d0.64e5e7b69ebb4e04a7797f7702f482f5
    }
    */
    event NewFilGoodNFTMinted(
        address indexed sender,
        uint256 indexed tokenId,
        string tokenURI,
        uint256 remainingMintableNFTs
    );

    constructor() ERC721("FilGood NFTs 2024", "Filecoin  NFTs") {
        console.log("This is my ERC721 NFT contract");
        maxNFTs = 100; 
        remainingMintableNFTs = 100;
    }

    function mintMyNFT(string memory ipfsURI) public returns (uint256) {
        require(_tokenIds.current() < maxNFTs);
        uint256 newItemId = _tokenIds.current();

        myNFT memory newNFT = myNFT({
            owner: msg.sender,
            tokenURI: ipfsURI,
            tokenId: newItemId
        });

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, ipfsURI);

        _tokenIds.increment();

        remainingMintableNFTs = maxNFTs - _tokenIds.current();

        nftCollection.push(newNFT);

        emit NewFilGoodNFTMinted(
            msg.sender,
            newItemId,
            ipfsURI,
            remainingMintableNFTs
        );

        return newItemId;
    }

    /**
     * @notice helper function to display NFTs for frontends
     */
    function getNFTCollection() public view returns (myNFT[] memory) {
        return nftCollection;
    }

    function getRemainingMintableNFTs() public view returns (uint256) {
        return remainingMintableNFTs;
    }
}