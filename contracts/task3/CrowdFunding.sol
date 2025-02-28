// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ERC20.sol";
import "./ERC721.sol";

contract CrowdFunding {
    address public owner;
    uint public fundingGoal;
    uint public fundingThreshold;
    uint public totalFunds;
    bool public fundingGoalReached = false;

    CrowdToken private rewardToken;
    CrowdNFT private nftReward;

    mapping(address => uint256) public contributions;

    event ContributionReceived(address indexed contributor, uint256 amount);
    event FundingGoalReached(uint256 totalFunds);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    constructor(uint _goal, uint _threshold, address tokenAddress, address nftAddress) {
        owner = msg.sender;
        fundingGoal = _goal;
        fundingThreshold = _threshold;
        rewardToken = CrowdToken(tokenAddress);
        nftReward = CrowdNFT(nftAddress);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function contribute() external payable {
        require(msg.value > 0, "Contribution must be greater than zero");
        require(!fundingGoalReached, "Funding goal already reached");

        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;

        // Mint ERC20 tokens equal to the contribution amount
        rewardToken.mint(msg.sender, msg.value);

        // Mint NFT if the contribution exceeds the threshold
        if (msg.value >= fundingThreshold && nftReward.ownedToken(msg.sender) == 0) {
            nftReward.mint(msg.sender);
        }

        emit ContributionReceived(msg.sender, msg.value);

        // Check if funding goal is met
        if (totalFunds >= fundingGoal) {
            fundingGoalReached = true;
            emit FundingGoalReached(totalFunds);
        }
    }

    function withdrawFunds() external onlyOwner {
        require(fundingGoalReached, "Funding goal not yet reached");

        uint balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        payable(owner).transfer(balance);
        emit FundsWithdrawn(owner, balance);
    }
}
