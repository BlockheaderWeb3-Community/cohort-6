// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./crowdToken.sol";
import "./crowdNFT.sol";

contract Crowdfunding {
    address public owner;
    uint256 public fundingGoal;
    uint256 public totalFunds;
    uint256 public nftThreshold;
    uint256 public tokenConversionRate; // Number of ERC20 tokens minted per wei contributed

    CrowdToken public rewardToken;
    CrowdNFT public rewardNFT;

    mapping(address => uint256) public contributions;

    constructor(
        uint256 _fundingGoal,
        uint256 _nftThreshold,
        uint256 _tokenConversionRate,
        address _rewardToken,
        address _rewardNFT
    ) {
        owner = msg.sender;
        fundingGoal = _fundingGoal;
        nftThreshold = _nftThreshold;
        tokenConversionRate = _tokenConversionRate;
        rewardToken = CrowdToken(_rewardToken);
        rewardNFT = CrowdNFT(_rewardNFT);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    // Contribute funds and receive rewards.
    function contribute() public payable {
        require(msg.value > 0, "Send ETH to contribute");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;

        // Reward with ERC20 tokens.
        uint256 tokenAmount = msg.value * tokenConversionRate;
        rewardToken.mint(msg.sender, tokenAmount);

        // If contribution meets or exceeds the NFT threshold, mint an NFT.
        if (msg.value >= nftThreshold) {
            rewardNFT.mintNFT(msg.sender);
        }
    }

    // Owner can withdraw funds if the funding goal is met.
    function withdrawFunds() public onlyOwner {
        require(totalFunds >= fundingGoal, "Funding goal not met");
        uint256 amount = address(this).balance;
        totalFunds = 0; // Resetting total funds (note: individual contributions remain recorded)
        payable(owner).transfer(amount);
    }

    // Fallback to allow direct ETH transfers.
    receive() external payable {
        contribute();
    }

    /*
      Example Usage:
      - A contributor sends 1 ETH via contribute(). If nftThreshold is set to 0.5 ETH,
        they receive both ERC20 tokens (1 ETH * tokenConversionRate) and an NFT.
      - Once total funds reach or exceed fundingGoal, the owner can call withdrawFunds().
    */
}
