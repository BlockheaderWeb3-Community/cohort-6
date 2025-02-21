// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "./IERC721.sol";

contract ERC721 is IERC721 {
    // Mapping from tokenId to owner address

    mapping(uint256 => address) internal _ownerOf;

    // Mapping from owner address to token count
    mapping(address => uint256) internal _balanceOf;

    // Mapping from token ID to approvad address
    mapping(uint256 => address) internal _approvals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    event Transfer(address indexed from, address indexed to, uint256 indexed id);
    event Approval(address indexed owner, address indexed spender, uint256 indexed id);
    event AppovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256) {
        require(owner != address(0), "owner = zero address");
        return _balanceOf[owner];
    }

    function ownerOf(uint256 tokenId) external view returns (address ownerOfToken) {
        ownerOfToken = _ownerOf[tokenId];
        require(ownerOfToken != address(0), "token doesn't exist ");
    }

    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;
        emit AppovalForAll(msg.sender, operator, approved);
    }

    function approve(address to, uint256 tokenId) external {
        address owner = _ownerOf[tokenId];
        require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "not authorised");

        _approvals[tokenId] = to;

        emit Approval(owner, to, tokenId);
    }

    function getApproved(uint256 tokenId) external view returns (address) {
        require(_ownerOf[tokenId] != address(0), "token does notexist");
        return _approvals[tokenId];
    }

    function _isApprovedOrOwner(address owner, address spender, uint256 id) internal view returns (bool) {
        return (spender == owner || isApprovedForAll[owner][spender] || spender == _approvals[id]);
    }

    function transferFrom(address from, address to, uint256 tokenId) external {
        require(from == _ownerOf[tokenId], "from != owner");
        require(to != address(0), "transfer to zero address");
        require(_isApprovedOrOwner(from, msg.sender, tokenId));

        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[tokenId] = to;

        delete _approvals[tokenId];
    }

    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "mint to zero address");
        require(_ownerOf[tokenId] == address(0), "already minted");

        _balanceOf[to]++;
        _ownerOf[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }
}

contract OLOWONFT is ERC721 {
    function mint(address to, uint tokenId) external {
        _mint(to, tokenId);
    }
}
