// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./IERC20.sol";

/// @title Minimalistic ERC20 Token Implementation
/// @notice This contract provides a basic implementation of an ERC20 token
/// @dev This contract follows the ERC20 standard but lacks security features like access control
contract ERC20 is IERC20 {
    /// @notice Name of the token
    string public name;
    
    /// @notice Symbol of the token
    string public symbol;
    
    /// @notice Number of decimal places the token uses
    uint8 public decimals;
    
    /// @notice Total supply of the token
    uint256 public totalSupply;

    /// @notice Mapping to track token balances
    mapping(address => uint256) public balanceOf;
    
    /// @notice Mapping to track allowances
    mapping(address => mapping(address => uint256)) public allowance;

    /// @notice Emitted when tokens are transferred from one account to another
    /// @param from The address tokens are transferred from
    /// @param to The address tokens are transferred to
    /// @param value The amount of tokens transferred
    event Transfer(address indexed from, address indexed to, uint256 value);

    /// @notice Emitted when an allowance is approved
    /// @param owner The address that owns the tokens
    /// @param spender The address that is approved to spend the tokens
    /// @param value The amount of tokens approved for spending
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /// @notice Constructor to initialize the token
    /// @param _name The name of the token
    /// @param _symbol The symbol of the token
    /// @param _decimals The number of decimal places the token uses
    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    /// @notice Transfers tokens to a specified address
    /// @dev Emits a `Transfer` event
    /// @param recipient The address receiving the tokens
    /// @param amount The amount of tokens to transfer
    /// @return success Boolean indicating if the transfer was successful
    function transfer(address recipient, uint256 amount) external returns (bool success) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    /// @notice Mints new tokens and assigns them to an address
    /// @dev Emits a `Transfer` event from the zero address
    /// @param _to The address receiving the newly minted tokens
    /// @param _amount The amount of tokens to mint
    function mint(address _to, uint256 _amount) external {
        require(msg.sender != address(0), "Minting from the zero address is not allowed");
        balanceOf[_to] += _amount;
        totalSupply += _amount;

        emit Transfer(address(0), _to, _amount);
    }

    /// @notice Burns tokens from the caller's balance
    /// @dev Emits a `Transfer` event to the zero address
    /// @param _amount The amount of tokens to burn
    function burn(uint256 _amount) external {
        require(balanceOf[msg.sender] >= _amount, "Insufficient funds");
        totalSupply -= _amount;
        balanceOf[msg.sender] -= _amount;
        balanceOf[address(0)] += _amount;

        emit Transfer(msg.sender, address(0), _amount);
    }
}
