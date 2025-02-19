// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./CrowdToken.sol";
import "./CrowdNFT.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Crowdfunding Platform
/// @notice Manages crowdfunding campaigns with token and NFT rewards
contract Crowdfunding is Ownable {
    CrowdToken public token;
    CrowdNFT public nft;
    
    uint256 public fundingGoal;
    uint256 public totalFunds;
    uint256 public constant NFT_THRESHOLD = 1 ether;
    uint256 public constant TOKEN_RATE = 100; // tokens per ether
    
    mapping(address => uint256) public contributions;
    
    event ContributionReceived(address contributor, uint256 amount);
    event GoalReached(uint256 totalAmount);
    event FundsWithdrawn(uint256 amount);
    
    constructor(
        uint256 _goal,
        address _tokenAddress,
        address _nftAddress
    ) Ownable(msg.sender) {
        fundingGoal = _goal;
        token = CrowdToken(_tokenAddress);
        nft = CrowdNFT(_nftAddress);
    }
    
    /// @notice Allows users to contribute ETH to the campaign
    function contribute() public payable {
        require(msg.value > 0, "Contribution must be greater than 0");
        
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
        
        // Mint reward tokens
        uint256 tokenReward = (msg.value * TOKEN_RATE) / 1 ether;
        token.mint(msg.sender, tokenReward);
        
        // Mint NFT if contribution exceeds threshold
        if (contributions[msg.sender] >= NFT_THRESHOLD) {
            nft.mintNFT(msg.sender);
        }
        
        emit ContributionReceived(msg.sender, msg.value);
        
        if (totalFunds >= fundingGoal) {
            emit GoalReached(totalFunds);
        }
    }
    
    /// @notice Allows owner to withdraw funds if goal is reached
    function withdrawFunds() public onlyOwner {
        require(totalFunds >= fundingGoal, "Funding goal not reached");
        
        uint256 amount = address(this).balance;
        (bool sent, ) = payable(owner()).call{value: amount}("");
        require(sent, "Failed to send Ether");
        
        emit FundsWithdrawn(amount);
    }
    
    /// @notice Returns the contribution amount for an address
    function getContribution(address contributor) public view returns (uint256) {
        return contributions[contributor];
    }
} 