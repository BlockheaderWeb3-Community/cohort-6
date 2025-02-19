// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;


contract ERC721 {
    // Mapping
    mapping(uint256 => address) internal _ownerOf;
    mapping(address => uint256) internal _balanceOf;

    // event
    event Transfer(address indexed from, address indexed to, uint256 indexed id);
    
    function _mint(address to, uint256 tokenId) external{
        require(to != address(0), "mint to zero address");
        require(_ownerOf[tokenId] == address(0), "already minted");

        _balanceOf[to]++;
        _ownerOf[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    function balanceOf(address owner) external view returns (uint256){
    require(owner != address(0), "owner = zero address");
    return _balanceOf[owner];
    }

    function ownerOf(uint256 tokenId) external view returns (address ownerOfToken){
    ownerOfToken = _ownerOf[tokenId];
    require(ownerOfToken != address(0), "token doesn't exist");
}
}