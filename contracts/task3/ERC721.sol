// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract CrowdNFT {
    string public name = "CrowdNFT";
    string public symbol = "CNFT";
    uint256 public totalSupply;

    address public owner;

    mapping(uint256 => address) public tokenOwner;
    mapping(address => uint256) public ownedToken;
    mapping(uint256 => address) public tokenApprovals;

    event Transfer(address indexed from, address indexed to, uint256 tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 tokenId);
    event Mint(address indexed to, uint256 tokenId);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function mint(address to) external onlyOwner {
        require(to != address(0), "Invalid address");
        require(ownedToken[to] == 0, "Already owns an NFT");

        uint256 tokenId = totalSupply + 1;
        totalSupply++;
        tokenOwner[tokenId] = to;
        ownedToken[to] = tokenId;

        emit Mint(to, tokenId);
        emit Transfer(address(0), to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) external {
        require(tokenOwner[tokenId] == from, "Not token owner");
        require(to != address(0), "Invalid recipient");

        tokenOwner[tokenId] = to;
        ownedToken[to] = tokenId;
        ownedToken[from] = 0;

        emit Transfer(from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) external {
        require(tokenOwner[tokenId] == msg.sender, "Not the token owner");

        tokenApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }

    function getApproved(uint256 tokenId) external view returns (address) {
        return tokenApprovals[tokenId];
    }
}
