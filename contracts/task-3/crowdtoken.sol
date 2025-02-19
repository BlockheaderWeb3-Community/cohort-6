// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }


    function transfer(address recipient, uint256 amount) external returns (bool) {
            require(balanceOf[msg.sender] >= amount);
            balanceOf[msg.sender] -= amount;
            balanceOf[recipient] += amount;

            emit Transfer(msg.sender, recipient, amount);
            return true;
    }

    function mint(address _to, uint256 _amount) external {
        require(msg.sender != address(0), "zero address");
        balanceOf[_to] += _amount;
        totalSupply += _amount;

        emit Transfer(address(0), _to, _amount);
    }
}