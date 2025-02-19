// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

import "./ERC20.sol";
import "./ERC721.sol";

contract CrowdFundingContract{
    bool public fundingGoalMet;
    uint public fundingThreshold;
    uint public fundingGoal;
    address public owner;

    // Mapping
    mapping(address => uint256) public _tokenBalances;
    mapping(address => uint256) public _contributions;

    // Events
    Events trackContributions(address contributor, uint amount);

    constructor(uint memory _fundingGoal, uint memory _fundingThreshold){
        _fundingGoal = fundingGoal;
        _fundingThreshold = fundingThreshold;
        owner = msg.sender;
    }

    // modifiers
    modifier onlyOwner(){
        require(msg.sender == owner, "Not owner");
    
    _;
        }

    // Functions

    // Tracking contributions
    // Contribution exceed a set threshold, mint an ERC721 NFT
    and send to contributor's account
    function exceedThreshold(address from, uint tokenId, address to ) external {
        _contributions[from] = msg.value;
        if(_contributions[from][msg.value] > _fundingThreshold){
            ERC721._mint(to, tokenId);
        }
        else{
        ERC20._mint(contributor, msg.value);
        }
    }

    // Project owner can withdraw funds if a funding goal is met
    function goalIsMet() onlyOwner {
        if (fundingGoalMet){
        // withdraw funds
        
        }
}