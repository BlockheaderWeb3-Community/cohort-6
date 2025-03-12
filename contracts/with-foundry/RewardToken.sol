// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RewardToken - Simplified ERC20
 * @dev ERC20 token used as a reward for crowdfunding contributors
 */
contract RewardToken {
    string public name = "RewardToken";
    string public symbol = "CRWD";
    uint8 public decimals = 18;
    uint256 private _totalSupply;

    // Owner of the contract
    address public owner;
    // Only the crowdfunding contract can mint tokens
    address public crowdfundingContract;

    // Balances for each account
    mapping(address => uint256) private _balances;
    // Allowances for each account
    mapping(address => mapping(address => uint256)) private _allowances;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    // Modifier to restrict functions to owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
        mintAllToOwner();
    }

    function setCrowdfundingContract(
        address _crowdfundingContract
    ) external onlyOwner {
        crowdfundingContract = _crowdfundingContract;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    // function mintReward(address to, uint256 amount) external {
    //     require(
    //         msg.sender == crowdfundingContract,
    //         "Only crowdfunding contract can mint"
    //     );
    //     _mint(to, amount);
    // }

    function mintAllToOwner() private onlyOwner {
        // _mint(owner, _totalSupply);
        _mint(owner, 5000);
    }

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(
            currentAllowance >= amount,
            "Transfer amount exceeds allowance"
        );
        _approve(sender, msg.sender, currentAllowance - amount);

        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "Transfer from the zero address");
        require(recipient != address(0), "Transfer to the zero address");
        require(_balances[sender] >= amount, "Transfer amount exceeds balance");

        _balances[sender] -= amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) private {
        require(msg.sender == owner, "Only owner can mint");
        require(account != address(0), "Mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;

        emit Transfer(address(0), account, amount);
    }

    function _approve(
        address _owner,
        address spender,
        uint256 amount
    ) internal {
        require(_owner != address(0), "Approve from the zero address");
        require(spender != address(0), "Approve to the zero address");

        _allowances[_owner][spender] = amount;

        emit Approval(_owner, spender, amount);
    }
}
