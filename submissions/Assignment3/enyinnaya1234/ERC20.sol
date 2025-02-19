// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

import "./IERC20.sol";

contract ERC20 is IERC20{
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balance;
    //mapping(address)

    event Transfer(address indexed _from, address indexed _to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

 constructor(string memory _name, string memory _symbol, uint8 _decimals){
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
 } 

 function transfer(address recipient, uint256 amount) external returns (bool){
    require(balanceOf[msg.sender] >= amount, "Insufficient funds");
    balanceOf[msg.sender] -= amount;
    balanceOf[recipient] += amount;

    emit Transfer(msg.sender, recipient, amount);
 } 

 function mint(address _to, uint256 _amount) external{
    require(msg.sender != address(0), "zero address");
    balanceOf[_to] += _amount;
    totalSupply += _amount;

    emit Transfer(address(0), _to, _amount);
 }
}