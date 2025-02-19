// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Crowd Token
/// @notice ERC20 token for crowdfunding rewards
contract CrowdToken is ERC20, Ownable {
    /// @notice Constructor sets the token name and symbol
    constructor() ERC20("Crowd Token", "CROWD") Ownable(msg.sender) {}

    /// @notice Mints new tokens to an address
    /// @param to Address to receive the tokens
    /// @param amount Amount of tokens to mint
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
} 