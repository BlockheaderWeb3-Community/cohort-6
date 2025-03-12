// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { Test, console } from "forge-std/Test.sol";
import { CrowdfundingV2 } from "../contracts/chainlink-integration/CrowdfundingV2.sol";
import { RewardToken } from "../contracts/with-foundry/RewardToken.sol";
import { RewardNft } from "../contracts/with-foundry/RewardNft.sol";
import { AggregatorV3Interface } from
  "../lib/chainlink-local/lib/chainlink-brownie-contracts/contracts/src/v0.7/interfaces/AggregatorV3Interface.sol";

contract CrowdfundingTest is Test {
  // Crowdfunding contract state variables
  CrowdfundingV2 public crowdfundingV2;
  RewardToken public rewardtoken;
  RewardNft public rewardnft;
  uint256 public constant FUNDING_GOAL_IN_USD = 50 ether;
  uint256 public constant NFT_THRESHOLD = 5 ether;
  uint256 public totalFundsRaised;
  bool public isFundingComplete;
  uint256 constant REWARD_RATE = 100;

  // Addresses for testing
  address crowdfundingV2Addr = address(this);
  address owner = vm.addr(1);
  address addr2 = vm.addr(2);
  address addr3 = vm.addr(3);
  address addr4 = vm.addr(4);
  address addr5 = vm.addr(5);
  AggregatorV3Interface priceFeed;

  event ContributionReceived(address indexed contributor, uint256 amount);
  event NFTRewardSent(address indexed receiver, uint256 Id);
  event TokenRewardSent(address indexed receiver, uint256 Amount);
  event FundsWithdrawn(address indexed receiver, uint256 Amount);

  address public constant ETH_USD_ADDR = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

  function setUp() public {
    vm.startPrank(owner);

    rewardtoken = new RewardToken();
    rewardnft = new RewardNft("RewardNft", "RNFT", "ipfs://");
    // vm.startPrank(owner);
    // Transfer Reward tokens from owner to the contract
    rewardtoken.transfer(address(this), 5000);

    crowdfundingV2 = new CrowdfundingV2(REWARD_RATE, address(rewardtoken), address(rewardnft));
    // console.log("cwd",  crowdfundingV2);
    vm.stopPrank();

    vm.deal(addr2, 100 ether);
    vm.deal(addr3, 100 ether);
    vm.deal(addr4, 100 ether);
    vm.deal(addr5, 100 ether);

    // Log the addresses

    // ******DEPLOYMENT******//
    // Test state variables at deployment
    // Should set the correct CrowdFunding contract owner
  }

  function test_getLatestPrice() public view {
    int256 ethUSDPrice = crowdfundingV2.getLatestPrice();
    console.log("eth price = ", ethUSDPrice);
  }
}
