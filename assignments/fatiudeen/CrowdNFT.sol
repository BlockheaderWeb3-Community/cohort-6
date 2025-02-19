// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @title Crowd NFT
/// @notice ERC721 token for top funders
contract CrowdNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Crowd NFT", "CNFT") Ownable(msg.sender) {}

    /// @notice Mints a new NFT to the specified address
    /// @param to Address to receive the NFT
    /// @return The ID of the newly minted NFT
    function mintNFT(address to) public onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _safeMint(to, newTokenId);
        return newTokenId;
    }
} 