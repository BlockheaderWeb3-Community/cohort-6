// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./IERC721.sol";

/// @title Minimalistic ERC721 Token Implementation
/// @notice This contract provides a basic implementation of an ERC721 NFT standard
/// @dev This contract follows the ERC721 standard but lacks security features like access control
contract ERC721 is IERC721 {
    /// @notice Mapping from token ID to owner address
    mapping(uint256 => address) internal _ownerOf;

    /// @notice Mapping from owner address to token count
    mapping(address => uint256) internal _balanceOf;

    /// @notice Mapping from token ID to approved address
    mapping(uint256 => address) internal _approvals;

    /// @notice Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    /// @notice Emitted when an NFT is transferred from one address to another
    /// @param from The address the NFT is transferred from
    /// @param to The address the NFT is transferred to
    /// @param id The token ID being transferred
    event Transfer(address indexed from, address indexed to, uint256 indexed id);

    /// @notice Emitted when an address is approved to transfer a specific NFT
    /// @param owner The owner of the NFT
    /// @param spender The address approved to spend the NFT
    /// @param id The token ID approved for transfer
    event Approval(address indexed owner, address indexed spender, uint256 indexed id);

    /// @notice Emitted when an operator is approved or revoked for all NFTs of an owner
    /// @param owner The address of the NFT owner
    /// @param operator The address of the operator
    /// @param approved Boolean indicating whether the operator is approved or not
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /// @notice Returns the balance of NFTs owned by a given address
    /// @param owner The address to query the balance for
    /// @return The number of NFTs owned by the address
    function balanceOf(address owner) external view returns (uint256) {
        require(owner != address(0), "owner = zero address");
        return _balanceOf[owner];
    }

    /// @notice Returns the owner of a specific NFT
    /// @param tokenId The ID of the token
    /// @return ownerOfToken The address of the owner of the token
    function ownerOf(uint256 tokenId) external view returns (address ownerOfToken) {
        ownerOfToken = _ownerOf[tokenId];
        require(ownerOfToken != address(0), "token doesn't exist");
    }

    /// @notice Enables or disables an operator to manage all of the caller's NFTs
    /// @param operator The address of the operator
    /// @param approved Whether the operator is approved or not
    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    /// @notice Approves an address to transfer a specific NFT
    /// @param to The address to be approved
    /// @param tokenId The token ID to approve for transfer
    function approve(address to, uint256 tokenId) external {
        address owner = _ownerOf[tokenId];
        require(msg.sender == owner || isApprovedForAll[owner][msg.sender], 'not authorised');

        _approvals[tokenId] = to;

        emit Approval(owner, to, tokenId);
    }

    /// @notice Returns the approved address for a specific NFT
    /// @param tokenId The token ID to check
    /// @return The approved address for the NFT
    function getApproved(uint256 tokenId) external view returns (address) {
        require(_ownerOf[tokenId] != address(0), "token does not exist");
        return _approvals[tokenId];
    }

    /// @notice Checks if an address is authorized to manage a given NFT
    /// @param owner The owner of the NFT
    /// @param spender The address attempting to manage the NFT
    /// @param id The token ID being checked
    /// @return Boolean indicating if the spender is authorized
    function _isApprovedOrOwner(address owner, address spender, uint256 id) internal view returns (bool) {
        return (spender == owner || isApprovedForAll[owner][spender] || spender == _approvals[id]);
    }

    /// @notice Transfers an NFT from one address to another
    /// @param from The current owner of the NFT
    /// @param to The new owner of the NFT
    /// @param tokenId The token ID to transfer
    function transferFrom(address from, address to, uint256 tokenId) external {
        require(from == _ownerOf[tokenId], "from != owner");
        require(to != address(0), "transfer to zero address");
        require(_isApprovedOrOwner(from, msg.sender, tokenId), "not authorised");

        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[tokenId] = to;

        delete _approvals[tokenId];
    }

    /// @notice Mints a new NFT to a given address
    /// @param to The address receiving the minted NFT
    /// @param tokenId The ID of the token being minted
    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "mint to zero address");
        require(_ownerOf[tokenId] == address(0), "already minted");

        _balanceOf[to]++;
        _ownerOf[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }
}

/// @title IBSNFT - A Minimalistic NFT Contract
/// @notice This contract provides basic minting functionality for an NFT collection
/// @dev Inherits from ERC721 and allows external minting of tokens
contract IBSNFT is ERC721 {
    /// @notice Mints a new NFT to a given address
    /// @param to The address receiving the minted NFT
    /// @param tokenId The ID of the token being minted
    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }
}
