// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {CrowdfundingV2} from "../contracts/chainlink-integration/CrowdFundingV2.sol";
import {RewardToken} from "../contracts/with-foundry/RewardToken.sol";
import {RewardNft} from "../contracts/with-foundry/RewardNft.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.7/interfaces/AggregatorV3Interface.sol";
// import {AggregatorV3Interface} from "../lib/chainlink-local/lib/chainlink-brownie-contracts/contracts/src/v0.7/interfaces/AggregatorV3Interface.sol";

contract CrowdfundingTest is Test {
    // Crowdfunding contract state variables
    CrowdfundingV2 public crowdfundingV2;
    RewardToken public rewardtoken;
    RewardNft public rewardnft;
    uint256 public constant FUNDING_GOAL_IN_USD = 50000;
    uint256 public constant NFT_THRESHOLD = 1000;
    uint256 public totalFundsRaised;
    bool public isFundingComplete;
    uint256 constant REWARD_RATE = 100;
    uint256 sepoliaFork;

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
        // Create the Sepolia fork
        sepoliaFork = vm.createFork("UPDATE-YOUR-RPC-URL-HERE-NOT-SAFE-FOR-GITHUB");
        vm.selectFork(sepoliaFork);

        // Set the fork to a specific block before any other operations
        vm.rollFork(7887153);

        // deploy contracts with the owner address
        vm.startPrank(owner);

        rewardtoken = new RewardToken();
        rewardnft = new RewardNft("RewardNft", "RNFT", "ipfs://");

        // Transfer Reward tokens from owner to the contract
        crowdfundingV2 = new CrowdfundingV2(REWARD_RATE, address(rewardtoken), address(rewardnft));

        rewardtoken.transfer(address(this), 5000);
        vm.stopPrank();

        vm.deal(addr2, 100 ether);
        vm.deal(addr3, 100 ether);
        vm.deal(addr4, 100 ether);
        vm.deal(addr5, 100 ether);
    }

    // ******DEPLOYMENT******//
    // Test state variables at deployment
    // Should set the correct CrowdFunding contract owner
    function test_setContractOwner() public view {
        assertEq(crowdfundingV2.Owner(), owner);
    }

    // Should set the correct crowd Token contract owner
    function test_setTokenContractOwner() public view {
        assertEq(rewardtoken.owner(), owner);
    }

    // should transfer the correct amount of reward tokens to the crowdfunding contract
    function test_RewardTokenBalanceOfCrowdfundingOnDeployment() public view {
        uint256 contractBal1 = rewardtoken.balanceOf(crowdfundingV2Addr);
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
        assertEq(crowdfundingV2.FUNDING_GOAL_IN_USD(), FUNDING_GOAL_IN_USD);
    }

    // Should set the correct token reward rate
    function test_setTokenReward() public view {
        assertEq(crowdfundingV2.tokenRewardRate(), REWARD_RATE);
    }

    // Should set the correct NFT threshold
    function test_set_NFT_Threshold() public view {
        assertEq(crowdfundingV2.NFT_THRESHOLD(), NFT_THRESHOLD);
    }

    // Should determine that totalFundsRaised is zero initially
    function test_total_funds_raised() public view {
        assertEq(crowdfundingV2.totalFundsRaised(), 0);
    }

    // Should set isFundingComplete to false initially
    function test_is_funding_complete() public view {
        assertEq(crowdfundingV2.isFundingComplete(), false);
    }

    function test_getLatestPrice() public view {
        int256 ethUSDPrice = crowdfundingV2.getLatestPrice();
        console.log("eth price = ", ethUSDPrice);
    }
}
