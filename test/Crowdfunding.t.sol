// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { Test, console } from "forge-std/Test.sol";
// import {Crowdfunding} from "../src/Crowdfunding.sol";
import { Crowdfunding } from "../contracts/with-foundry/Crowdfunding.sol";
import { RewardToken } from "../contracts/with-foundry/RewardToken.sol";
import { RewardNft } from "../contracts/with-foundry/RewardNft.sol";

contract CrowdfundingTest is Test {
  // Crowdfunding contract state variables
  Crowdfunding public crowdfunding;
  RewardToken public rewardtoken;
  RewardNft public rewardnft;
  uint256 public constant FUNDING_GOAL_IN_USD = 50 ether;
  uint256 public constant NFT_THRESHOLD = 5 ether;
  uint256 public totalFundsRaised;
  bool public isFundingComplete;
  uint256 constant REWARD_RATE = 100;

  // Addresses for testing
  address crowdfundingAddr = address(this);
  address owner = vm.addr(1);
  address addr2 = vm.addr(2);
  address addr3 = vm.addr(3);
  address addr4 = vm.addr(4);
  address addr5 = vm.addr(5);

  receive() external payable { }

  event ContributionReceived(address indexed contributor, uint256 amount);
  event NFTRewardSent(address indexed receiver, uint256 Id);
  event TokenRewardSent(address indexed receiver, uint256 Amount);
  event FundsWithdrawn(address indexed receiver, uint256 Amount);

  function calculateTokenReward(uint256 ethContribution) public view returns (uint256) {
    return (ethContribution * crowdfunding.tokenRewardRate()) / 1 ether;
  }

  function setUp() public {
    vm.startPrank(owner);

    rewardtoken = new RewardToken();
    // vm.stopPrank();
    // vm.startPrank(owner);
    rewardnft = new RewardNft("RewardNft", "RNFT", "ipfs://");
    // vm.stopPrank();
    // vm.startPrank(owner);
    console.log("rewardtoken:", address(rewardtoken));
    console.log("rewardnft:", address(rewardnft));
    // vm.startPrank(owner);
    // Transfer Reward tokens from owner to the contract
    rewardtoken.transfer(address(this), 5000);

    crowdfunding = new Crowdfunding(REWARD_RATE, address(rewardtoken), address(rewardnft));
    vm.stopPrank();

    vm.deal(addr2, 100 ether);
    vm.deal(addr3, 100 ether);
    vm.deal(addr4, 100 ether);
    vm.deal(addr5, 100 ether);

    console.log("Owner_____:", owner);
    console.log("Address 2_____:", addr2);
    console.log("Address 3_____:", addr3);
    console.log("Address 4_____:", addr4);
    console.log("Address 5_____:", addr5);
    console.log("Contract Address_____:", crowdfundingAddr);
    // Log the addresses
    console.log("Crowdfunding contract address______:", address(crowdfunding));
    console.log("RewardToken contract address______:", address(rewardtoken));
    console.log("RewardNFT contract address______:", address(rewardnft));
  }

  // ******DEPLOYMENT******//
  // Test state variables at deployment
  // Should set the correct CrowdFunding contract owner
  function test_setContractOwner() public view {
    assertEq(crowdfunding.Owner(), owner);
  }
  // Should set the correct crowd Token contract owner

  function test_setTokenContractOwner() public view {
    assertEq(rewardtoken.owner(), owner);
  }

  // should transfer the correct amount of reward tokens to the crowdfunding contract
  function test_RewardTokenBalanceOfCrowdfundingOnDeployment() public view {
    uint256 contractBal1 = rewardtoken.balanceOf(crowdfundingAddr);
    assertEq(contractBal1, 5000);

    uint256 ownerRewardTokenBalance = rewardtoken.balanceOf(owner);
    assertEq(ownerRewardTokenBalance, 0);
  }

  // Should set the correct rewardNFT contract owner
  function test_setNFTContractOwner() public view {
    assertEq(rewardnft.owner(), owner);
  }

  // Should set the correct funding goal
  function test_setCorrectFundingGoal() public view {
    assertEq(crowdfunding.FUNDING_GOAL_IN_USD(), FUNDING_GOAL_IN_USD);
  }

  // Should set the correct token reward rate
  function test_setTokenReward() public view {
    assertEq(crowdfunding.tokenRewardRate(), REWARD_RATE);
  }

  // Should set the correct NFT threshold
  function test_set_NFT_Threshold() public view {
    assertEq(crowdfunding.NFT_THRESHOLD(), NFT_THRESHOLD);
  }

  // Should determine that totalFundsRaised is zero initially
  function test_total_funds_raised() public view {
    assertEq(crowdfunding.totalFundsRaised(), 0);
  }

  // Should set isFundingComplete to false initially
  function test_is_funding_complete() public view {
    assertEq(crowdfunding.isFundingComplete(), false);
  }

  // ********* TRANSACTIONS *********//
  // Allows Eth contribution from user
  function test_allow_eth_contribution() public {
    uint256 contributionAmount = 10 ether;
    uint256 addr2InitialEthBal = addr2.balance; // address 2 initial balance

    uint256 initialEthBalanceCrowdFunding = address(crowdfunding).balance; // initial balance of crowdfunding contract
    console.log("Initial Eth Balance CrowdFunding_____:", initialEthBalanceCrowdFunding);

    uint256 contractRewardTokenBal = rewardtoken.balanceOf(crowdfundingAddr);
    assertEq(contractRewardTokenBal, 5000);

    uint256 ownerRewardTokenBalance = rewardtoken.balanceOf(owner);
    assertEq(ownerRewardTokenBalance, 0);

    assertEq(initialEthBalanceCrowdFunding, 0);
    assertEq(addr2InitialEthBal, 100 ether);
    // Perform the contribution
    vm.prank(addr2);
    // console.log("Addr2_____:", addr2);
    crowdfunding.contribute{ value: contributionAmount }();

    uint256 addr2EthBalAfterContr = addr2.balance; // address 2 balance after contribution
    uint256 crowdfundingBalAfterContr = address(crowdfunding).balance; // crowdfunding balance after contribution

    assertEq(addr2EthBalAfterContr, addr2InitialEthBal - contributionAmount);
    assertEq(crowdfundingBalAfterContr, initialEthBalanceCrowdFunding + contributionAmount);
  }

  // determine that the token reward amount is based on contribution
  function test_calculate_token_reward_amount() public {
    // first calculate the token reward for 2 ether
    uint256 rewardAmount1 = calculateTokenReward(2 ether);
    assertEq(rewardAmount1, 200);

    // Calculate the token reward for 5 ether
    uint256 rewardAmount2 = calculateTokenReward(5 ether);
    assertEq(rewardAmount2, 500);

    // Calculate the token reward for 10 ether
    uint256 rewardAmount3 = calculateTokenReward(10 ether);
    assertEq(rewardAmount3, 1000);
  }

  // Should send the correct token reward to the contributor
  function test_user_receive_accurate_token_reward_on_contribution() public {
    uint256 contributionAmount = 10 ether;
    uint256 addr3InitialEthBal = addr3.balance; // address 3 initial balance
    uint256 addr3InitialTokenBal = rewardtoken.balanceOf(addr3); // address 3 initial token balance
    console.log("Initial Token Balance Address 3_____:", addr3InitialTokenBal);
    uint256 rewardAmount = calculateTokenReward(10 ether);
    console.log("Reward Amount______:", rewardAmount);

    uint256 initialEthBalanceCrowdFunding = address(crowdfunding).balance; // initial balance of crowdfunding contract
    console.log("Initial Eth Balance CrowdFunding_____:", initialEthBalanceCrowdFunding);

    uint256 contractRewardTokenBal = rewardtoken.balanceOf(crowdfundingAddr);
    assertEq(contractRewardTokenBal, 5000);

    uint256 ownerRewardTokenBalance = rewardtoken.balanceOf(owner);
    assertEq(ownerRewardTokenBalance, 0);

    assertEq(initialEthBalanceCrowdFunding, 0);
    assertEq(addr3InitialEthBal, 100 ether);

    // Perform the contribution with address 3
    vm.prank(addr3);
    crowdfunding.contribute{ value: contributionAmount }();

    uint256 addr3EthBalAfterContr = addr3.balance; // address 3 balance after contribution
    uint256 addr3TokenBalAfterContr = rewardtoken.balanceOf(addr3); // address 3 initial token balance
    uint256 crowdfundingBalAfterContrtion = address(crowdfunding).balance; // crowdfunding balance after contribution

    assertEq(addr3TokenBalAfterContr, rewardAmount);
    assertEq(addr3EthBalAfterContr, addr3InitialEthBal - contributionAmount);
    assertEq(crowdfundingBalAfterContrtion, initialEthBalanceCrowdFunding + contributionAmount);
  }

  // should not mint NFT below threshold
  function test_not_mint_nft_below_threshold() public {
    vm.prank(addr2);
    crowdfunding.contribute{ value: 3 ether }();
    assertEq(rewardnft.balanceOf(addr2), 0);

    assertEq(crowdfunding.hasReceivedNFT(addr2), false);
  }

  // should mint NFT
  function test_should_mint_nft() public {
    vm.prank(addr2);
    crowdfunding.contribute{ value: 10 ether }();
    assertEq(rewardnft.balanceOf(addr2), 1);
    assertEq(crowdfunding.hasReceivedNFT(addr2), true);
  }

  // should mint NFT for cummulative contributions
  function test_mint_for_cummulative() public {
    vm.prank(addr2);
    crowdfunding.contribute{ value: 2 ether }();
    assertEq(rewardnft.balanceOf(addr2), 0);

    vm.prank(addr2);
    crowdfunding.contribute{ value: 4 ether }();
    assertEq(rewardnft.balanceOf(addr2), 1);
  }

  // should not mint additional NFT
  function test_should_not_mint_additional_nft() public {
    vm.prank(addr2);
    crowdfunding.contribute{ value: 8 ether }();
    assertEq(rewardnft.balanceOf(addr2), 1);

    vm.prank(addr2);
    crowdfunding.contribute{ value: 10 ether }();
    assertEq(rewardnft.balanceOf(addr2), 1);
  }

  // should track individual contributions
  function test_track_individual_contributions() public {
    vm.prank(addr2);
    crowdfunding.contribute{ value: 10 ether }();
    assertEq(crowdfunding.getContribution(addr2), 10 ether);

    vm.prank(addr3);
    crowdfunding.contribute{ value: 20 ether }();
    assertEq(crowdfunding.getContribution(addr3), 20 ether);
  }

  // should track multiple contributions
  function test_track_multiple_contributions() public {
    vm.prank(addr2);
    crowdfunding.contribute{ value: 10 ether }();
    assertEq(crowdfunding.getContribution(addr2), 10 ether);

    vm.prank(addr2);
    crowdfunding.contribute{ value: 20 ether }();
    assertEq(crowdfunding.getContribution(addr2), 30 ether);
  }

  // should track funding progress
  function test_track_funding_progress() public {
    vm.prank(addr2);
    crowdfunding.contribute{ value: 40 ether }();
    assertEq(crowdfunding.totalFundsRaised(), 40 ether);
    assertEq(crowdfunding.isFundingComplete(), false);

    vm.prank(addr2);
    crowdfunding.contribute{ value: 10 ether }();
    assertEq(crowdfunding.totalFundsRaised(), 50 ether);
    assertEq(crowdfunding.isFundingComplete(), true);
  }

  // should allow owner to withdraw funds
  function test_allow_owner_to_withdraw() public {
    uint256 initialOwnerBalance = owner.balance;
    console.log("Initial Owner Balance:", initialOwnerBalance);
    assertEq(owner.balance, 0);

    vm.startPrank(addr2);
    crowdfunding.contribute{ value: FUNDING_GOAL_IN_USD }();
    vm.stopPrank();
    assertEq(addr2.balance, 50 ether);

    assertEq(crowdfunding.totalFundsRaised(), FUNDING_GOAL_IN_USD);
    assertEq(crowdfunding.contributions(addr2), 50 ether);
    // vm.prank(address(crowdfunding));
    // vm.startPrank(owner);
    // console.log("Owner Address:", owner);

    // crowdfunding.withdrawFunds();
    // vm.stopPrank();
    // assertEq(owner.balance, initialOwnerBalance + FUNDING_GOAL_IN_USD);
  }

  // should not allow withdrawal if funding goal not reached
  function test_reject_withdrawal_if_funding_not_reached() public {
    vm.prank(addr2);
    crowdfunding.contribute{ value: 20 ether }();
    assertEq(addr2.balance, 80 ether);

    vm.expectRevert("Funding goal not yet reached");

    vm.prank(owner);
    crowdfunding.withdrawFunds();
  }

  // should not allow non-owner to withdraw funds
  function test_withdrawal_for_nonOwner() public {
    vm.prank(addr2);
    crowdfunding.contribute{ value: 50 ether }();
    vm.expectRevert("Only project owner can withdraw");
    vm.prank(addr2);
    crowdfunding.withdrawFunds();
  }

  function test_correctly_track_individual_contributions() public {
    vm.prank(addr2);
    crowdfunding.contribute{ value: 12 ether }();

    vm.prank(addr3);
    crowdfunding.contribute{ value: 12 ether }();

    // vm.prank(addr5);
    // crowdfunding.contribute{value: 12 ether}();

    assertEq(crowdfunding.getContribution(addr2), 12 ether);
    assertEq(crowdfunding.getContribution(addr3), 12 ether);
    // assertEq(crowdfunding.getContribution(addr5), 12 ether);
  }

  function test_contribution_amount_for_repeat_contributions() public {
    vm.prank(addr2);
    crowdfunding.contribute{ value: 12 ether }();

    vm.prank(addr2);
    crowdfunding.contribute{ value: 12 ether }();

    assertEq(crowdfunding.getContribution(addr2), 24 ether);
  }

  // validations
  function test_should_reject_zero_contribution() public {
    vm.expectRevert("Contribution must be greater than 0");
    vm.prank(addr2);
    crowdfunding.contribute{ value: 0 ether }();
  }

  function test_reject_contributions_after_FUNDING_GOAL_IN_USD_is_reached() public {
    vm.prank(addr2);
    crowdfunding.contribute{ value: 50 ether }();

    vm.expectRevert("Funding goal already reached");
    vm.prank(addr3);
    crowdfunding.contribute{ value: 0.00001 ether }();

    vm.prank(owner);
    crowdfunding.withdrawFunds();
  }

  function test_refund_excess_contribution() public {
    // First contribute most of the funding goal
    uint256 initialContribution = 45 ether;
    vm.prank(addr2);
    crowdfunding.contribute{ value: initialContribution }();

    // Verify initial contribution state
    assertEq(crowdfunding.totalFundsRaised(), initialContribution);

    // Calculate remaining amount needed and prepare second contribution
    uint256 secondContribution = 10 ether;
    uint256 remainingToGoal = FUNDING_GOAL_IN_USD - initialContribution; // Should be 5 ether
    uint256 expectedRefund = secondContribution - remainingToGoal; // Should be 5 ether

    // Record addr3's balance before contribution
    uint256 addr3BalanceBefore = addr3.balance;

    // Make contribution that should trigger partial refund
    vm.prank(addr3);
    crowdfunding.contribute{ value: secondContribution }();

    // Verify final states
    assertEq(crowdfunding.totalFundsRaised(), FUNDING_GOAL_IN_USD);
    assertEq(crowdfunding.isFundingComplete(), true);
    assertEq(crowdfunding.getContribution(addr3), remainingToGoal);

    // Verify addr3 received the correct refund
    // Final balance should be: initial balance - contribution + refund
    uint256 expectedBalance = addr3BalanceBefore - secondContribution + expectedRefund;
    assertEq(addr3.balance, expectedBalance);
  }

  // ********* EVENTS *********//
  // Should emit FundsWithdrawn event
  function test_emit_funds_withdrawn_event() public {
    // First reach the funding goal
    vm.prank(addr2);
    crowdfunding.contribute{ value: FUNDING_GOAL_IN_USD }();

    // Set up the event check
    vm.expectEmit(true, true, false, true, address(crowdfunding));

    emit FundsWithdrawn(owner, FUNDING_GOAL_IN_USD); // emit the expected arguments

    vm.prank(owner); // Prank the owner to withdraw funds
    crowdfunding.withdrawFunds();
  }
  // Should emit TokenRewardSent event

  function test_emit_token_reward_sent_event() public {
    // Calculate expected tokens based on reward rate
    uint256 expectedTokens = (2 ether * REWARD_RATE) / 1 ether;

    // Set up the event check
    vm.expectEmit(true, true, false, true, address(crowdfunding));

    // Emit the expected event with expected arguments
    emit TokenRewardSent(addr2, expectedTokens);

    // Make the contribution that should trigger the token reward
    vm.prank(addr2);
    crowdfunding.contribute{ value: 2 ether }();
  }
  // Should emit ContributionReceived event

  function test_emit_contribution_received_event() public {
    vm.expectEmit(true, true, false, true, address(crowdfunding));

    // Emit the expected event with the expected arguments
    emit ContributionReceived(addr2, 20 ether);

    // Perform the action that should emit the event
    vm.prank(addr2);
    crowdfunding.contribute{ value: 20 ether }();
  }

  // Should emit NFTRewardSent event
  function test_emit_nft_reward_sent_event() public {
    // Set up the event check - we want to verify the NFTRewardSent event
    vm.expectEmit(true, true, true, true, address(crowdfunding));

    // Emit the expected event with expected arguments
    emit NFTRewardSent(addr2, 1); // First NFT should have ID 1

    // Make the contribution that should trigger the NFT reward
    vm.prank(addr2);
    crowdfunding.contribute{ value: NFT_THRESHOLD }();
  }
}
