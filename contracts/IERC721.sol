// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC721 {
    function balanceOf(address ownerOfToken) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    // function safeTransferFrom(address from, address to, uint256 tokenId) external;
    // function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function setApprovalForAll(address operator, bool approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}