// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CrowdNFT is ERC721, Ownable {
    uint256 public tokenCounter;
    address public minter;

    constructor() ERC721("CrowdNFT", "CNFT") Ownable(msg.sender) {
        tokenCounter = 0;
    }

    // Set the authorized minter (typically the crowdfunding contract).
    function setMinter(address _minter) external onlyOwner {
        minter = _minter;
    }

    // Mint a new NFT to the specified address; only the authorized minter can call.
    function mintNFT(address to) external returns (uint256) {
        require(msg.sender == minter, "Not authorized");
        uint256 newTokenId = tokenCounter;
        _safeMint(to, newTokenId);
        tokenCounter++;
        return newTokenId;
    }
}
