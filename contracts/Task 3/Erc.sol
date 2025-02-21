// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

/// @title ERC20 Token
/// @author Darey Olowo
/// @notice THis contract implements ERC20 token
/// @dev All function calls are currently implemented without side effects

contract ERC20 {
    /// @notice Name of the token
    string public name;
    /// @notice Symbol of the Token
    string public symbol;
    /// @notice Number of decimal places the token uses
    uint8 public decimals;
    /// @notice Total supply of the token
    uint256 public totalSupply;

    /// @notice Address of the contract owner
    address public owner;
    /// @dev Mapping to track balance value based on address
    mapping(address => uint256) public balanceOf;
    /// @dev Mapping to track address of minters
    mapping(address => bool) public minters;
    /// @dev Mapping to track allowances of minters
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

    /// @dev Ensures that only Contract owner can execute the function
    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }
    /// @dev Ensures that only Minters can execute the function
    modifier onlyMinter() {
        require(minters[msg.sender], "Not authorized to mint");
        _;
    }

    /// @notice Contract constructor setting the deployer as the owner
    /// @param _name The name of the token
    /// @param _symbol The symbol for the token
    /// @param _decimals the Number of decimal places the token uses
    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        owner = msg.sender;
    }

    /// @notice Transfers tokens to a specified address
    /// @dev Emits a `Transfer` event
    /// @param recipient The address receiving the tokens
    /// @param amount The amount of tokens to transfer
    /// @return success Boolean indicating if the transfer was successful
    function transfer(address recipient, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
    /// @notice Sets the minter to be a minter or not
    /// @param _minter the address of the minter
    function setMinter(address _minter, bool _status) external onlyOwner {
        minters[_minter] = _status;
    }
    /// @notice Allows minters to mint tokens
    /// @param _to Address to be mint on
    /// @param _amount the amount to be mint
    function mint(address _to, uint256 _amount) external onlyMinter {
        require(_to != address(0), "Zero address");
        balanceOf[_to] += _amount;
        totalSupply += _amount;
        emit Transfer(address(0), _to, _amount);
    }

    /// @notice Burns tokens from the caller's balance
    /// @dev Emits a `Transfer` event to the zero address
    /// @param _amount The amount of tokens to burn
    function burn(uint256 _amount) external {
        require(balanceOf[msg.sender] >= _amount, "Insufficient balance");
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
        balanceOf[address(0)] += _amount;

        emit Transfer(msg.sender, address(0), _amount);
    }

    /// @notice Transfers tokens from one address to another
    /// @dev Requires that the sender has enough balance and that the allowance is sufficient
    /// @param _from The address sending the tokens
    /// @param _recipient The address receiving the tokens
    /// @param _amount The number of tokens to transfer
    /// @return success Returns success when true
    function transferFrom(address _from, address _recipient, uint256 _amount) public returns (bool success) {
        require(_recipient != address(0), "Invalid recipient address");
        require(allowance[_from][msg.sender] >= _amount, "Allowance exceeded");
        require(balanceOf[_from] >= _amount, "Insufficient balance");

        balanceOf[_from] -= _amount;
        balanceOf[_recipient] += _amount;
        allowance[_from][msg.sender] -= _amount;

        emit Transfer(_from, _recipient, _amount);
        return true;
    }

    /// @notice Approves an address to spend tokens on behalf of the sender
    /// @dev Prevents front-running by requiring approval to be reset to 0 before a new amount is set
    /// @param _spender The address allowed to spend tokens
    /// @param _amount The maximum amount the spender is allowed to spend
    /// @return success Returns success when true

    function approve(address _spender, uint256 _amount) public returns (bool success) {
        require(_spender != address(0), "Invalid spender address");

        // Prevent front-running attack
        require(allowance[msg.sender][_spender] == 0 || _amount == 0, "First set allowance to 0");

        allowance[msg.sender][_spender] = _amount;

        // Emit Approval event
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }
}
