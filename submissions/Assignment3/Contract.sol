// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.28;

contract CrowdToken {
    struct Funders {
        address funder;
        uint amountInEth;
        uint tokenBalance;
        uint NFTBalance;
    }

    string private tokenName = "CrowdToken";
    string private tokenSymbol = "CRWD";
    address public owner;
    uint256 public totalSupply;
    uint public totalFundingAmount = 0;

    mapping(address => Funders) public funders;

    constructor() {
        owner = msg.sender;
    }

    error InsufficientBalance(uint balance, uint amount);
    error AmountShouldNotBeZero(uint amount);

    function fund() external payable {

        if (msg.value == 0) revert AmountShouldNotBeZero(msg.value);
        
        Funders storage user = funders[msg.sender];
        if (user.funder == address(0)) {
            user.funder = msg.sender;
        }

        uint valueInEth = weiToEth(msg.value);

        user.amountInEth += valueInEth;
        user.tokenBalance += valueInEth * 1000;

        totalSupply += valueInEth;
        totalFundingAmount +=valueInEth;

        payable(msg.sender).transfer(valueInEth * 1000);

    }

    function weiToEth(uint256 weiAmount) public pure returns (uint256) {
        return weiAmount / 1e18;
    }

}