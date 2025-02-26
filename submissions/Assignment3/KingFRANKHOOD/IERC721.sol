// SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

interface IERC721 {
    function nftBalanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint tokenId) external view returns (address owner);
    //function safeTransferFrom(address from, address to, uint tokenId, bytes memory data) external;
    //function safeTransferFrom(address from, address to, uint tokenId) external;
    function nftTransferFrom(address from, address to, uint tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function setApprovalForAll(address operator, bool approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}