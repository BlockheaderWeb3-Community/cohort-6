// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Payable Contract
/// @notice This contract allows users to deposit ETH and keeps track of investments
/// @dev Provides basic payable functionalities with fallback and receive functions
contract Payable {
    /// @notice Address of the contract owner
    address payable public owner;
    
    /// @notice Counter for tracking fallback calls
    uint256 public counter;
    
    /// @notice Mapping to store investments made by investors
    mapping(address investors => uint256 amount) internal investments;

    /// @notice Error for calling a function that does not exist
    error FunctionDoesNotExit();

    /// @notice Constructor to initialize the contract owner
    constructor() payable {
        owner = payable(msg.sender);
    }

    /// @notice Deposits ETH into the contract and records the amount for the sender
    /// @param amount The amount of ETH to deposit
    /// @return The deposited amount
    function deposit(uint256 amount) public payable returns (uint256) {
        require(amount == msg.value, "msg.value must equal eth");
        investments[msg.sender] = amount;
        return amount;
    }

    /// @notice Retrieves the investment amount for a given investor
    /// @param investor The address of the investor
    /// @return investment The amount invested by the investor
    function getInvestment(address investor) public view returns (uint256 investment) {
        investment = investments[investor];
    }

    /// @notice Returns the contract's ETH balance in ether
    /// @return contractBalance The balance of the contract in ether
    function getContractBalance() public view returns (uint256 contractBalance) {
        contractBalance = address(this).balance / 1 ether;
    }

    /// @notice Returns the sender's ETH balance
    /// @return myEthBalance The ETH balance of the sender
    function getMyEthBalance() public view returns (uint256 myEthBalance) {
        myEthBalance = address(msg.sender).balance;
    }

    /// @notice Receive function to accept ETH transfers
    receive() external payable {}

    /// @notice Fallback function to handle incorrect function calls
    fallback() external payable {
        counter += 1;
    }
}

/// @title Funder Contract
/// @notice This contract enables sending ETH using transfer, send, and call methods
contract Funder {
    /// @notice Error when ETH transfer fails
    error FailedToSendEth();

    /// @notice Sends ETH to a receiver using transfer
    /// @param _receiver The recipient's address
    function sendWithTransfer(address payable _receiver) public payable {
        _receiver.transfer(msg.value);
    }

    /// @notice Sends ETH to a receiver using send
    /// @param _receiver The recipient's address
    /// @return sent Boolean indicating if the transfer was successful
    function sendWithSend(address payable _receiver) public payable returns (bool sent) {
        sent = _receiver.send(msg.value);
        if (!sent) {
            revert FailedToSendEth();
        }
    }

    /// @notice Sends ETH to a receiver using call
    /// @param _receiver The recipient's address
    /// @return sent Boolean indicating if the transfer was successful
    /// @return data The returned data from the call
    function sendWithCall(address payable _receiver) public payable returns (bool sent, bytes memory data) {
        (sent, data) = _receiver.call{value: msg.value}("");
        require(sent, "failed to send eth");
    }

    /// @notice Calls the deposit function of `Payable` contract
    /// @param _payableContractAddress The address of the payable contract
    function callDeposit(address payable _payableContractAddress) public payable {
        uint256 amount = msg.value;
        (bool success, bytes memory data) = _payableContractAddress.call{value: amount}(abi.encodeWithSignature("deposit(uint256)", amount));
        require(success, "call failed");
    }
}
