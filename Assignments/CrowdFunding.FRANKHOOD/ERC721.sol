// SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import "./IERC721.sol";

contract ERC721 is IERC721 {
    // Mapping fron tokenId to owner address
    mapping (uint256=> address) internal _ownerOf;

    //Mapping from owner address to token count
    mapping (address => uint256) internal _balanceOf;

    //Mapping from tokenId to approved address
    mapping (uint256 => address) internal _approvals;

    //Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) public isApprovedForAll;

    event NFTTransfer(address indexed from, address indexed to, uint256 indexed id);
    event NFTApproval(address indexed owner, address indexed spender, uint256 indexed id);
    event ApprovalForAll(address indexed owner, address operator, bool approved);

    function nftBalanceOf(address owner) external view returns (uint256) {
        require(owner != address(0), "owner = zero address");
        return _balanceOf[owner];
    }

    function ownerOf(uint256 tokenId) external view returns (address ownerOfToken) {
        ownerOfToken = _ownerOf[tokenId];
        require(ownerOfToken != address(0), "token doesn't exist");
    }
    
    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender,operator,approved);
    }

    function approve(address to, uint256 tokenId) external {
        address owner = _ownerOf[tokenId];
        require(msg.sender == owner || isApprovedForAll[owner][msg.sender], 'not authorised');

        _approvals[tokenId] = to;

        emit NFTApproval(owner, to, tokenId);
    }

    function getApproved(uint256 tokenId) external view returns (address) {
        require (_ownerOf[tokenId] !=address(0), "token does not exist");
        return _approvals[tokenId];
    }

    function isApprovedOrOwner(address owner, address spender, uint256 id) private view returns (bool) {
        return (spender == owner || isApprovedForAll[owner][spender] || spender == _approvals[id]);
    }

    function nftTransferFrom(address from, address to, uint256 tokenId) external {
        require(from == _ownerOf[tokenId], "from != owner");
        require(to != address(0), "transfer to zero address");
        require(isApprovedOrOwner(from, msg.sender, tokenId), "not authorised");

        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[tokenId] = to;

        delete _approvals[tokenId];
    }

    function _mintNFT(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "mint to zero address");
        require(_ownerOf[tokenId] == address(0), "already minted");

        _balanceOf[to]++;
        _ownerOf[tokenId] = to;

        emit NFTTransfer(address(0), to, tokenId);
    }
}
