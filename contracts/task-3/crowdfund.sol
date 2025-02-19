// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./crowdtoken.sol";
import "./crowdnft.sol";

contract CrowdFunding{
    address public owner;
    uint256 public fundingGoal;
    uint256 public nftThreshold;
    uint256 public totalFunds;
    bool public goalReached;

    CrowdToken public crowdToken;
    CrowdNFT public crowdNFT;

    mapping (address => uint256) public contributions;

    event Funded(address contributor, uint256 amount);
    event GoalReached(uint256 totalRaised);
    event Withdrawal(address owner, uint256 amount);


    constructor(address _tokenAddress, address _nftAddress, uint256 _fundingGoal, uint256 _nftThreshold) {
        owner = msg.sender;
        fundingGoal = _fundingGoal;
        nftThreshold = _nftThreshold;
        // Cast addresses to contract types
        crowdToken = CrowdToken(_tokenAddress);
        crowdNFT = CrowdNFT(_nftAddress);
    }

        modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    //function for contributors to send funds

    function contribute() external payable {
        require( msg.value > 0, "Contribution must be greater than 0");
        require(!goalReached, "Funding goal already reached");

        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;


        //Mint token based on contribution amount
        uint256 tokens = msg.value / 1 ether; 
        crowdToken.mint(msg.sender, tokens);

        //If contribution exceeds threshold, mint an NFT
        if (msg.value >= nftThreshold){
            crowdNFT.mint(msg.sender);
        }
        emit Funded (msg.sender, msg.value);

        //check if funding goal is reached
        if (totalFunds >= fundingGoal && !goalReached){
            goalReached = true;
        }
        emit GoalReached(address(this).balance);
    }

    //withdraw funds if the goal is met
    function WithdrawFunds() external onlyOwner{
        require(goalReached, "Funding goal not reached");
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    
        emit Withdrawal(owner, address(this).balance);

    }
}