// SPD-Licrnse-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract CrowdToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed _from, address indexed _to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint _totalSupply, string memory _name, string memory _symbol, uint8 _decimals) {
        _totalSupply = totalSupply;
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        balanceOf[msg.sender] = _totalSupply;
    }

    receive() external payable {}
    fallback() external payable {
        revert("Function does not exist");
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient funds");
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
