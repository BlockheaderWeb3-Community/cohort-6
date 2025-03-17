// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;
import {console} from "forge-std/Test.sol";
import "@chainlink/contracts/src/v0.7/interfaces/AggregatorV3Interface.sol";
import "../../contracts/with-foundry/RewardToken.sol";
import "../../contracts/with-foundry/RewardNft.sol";

contract CrowdfundingV2 {
    address public Owner;
    uint public constant FUNDING_GOAL_IN_USD = 50000;
    uint public constant NFT_THRESHOLD = 1000;
    uint256 public totalFundsRaised;
    bool public isFundingComplete;

    RewardToken public rewardToken;
    RewardNft public rewardNFT;
    uint256 public tokenRewardRate;

    // Contribution tracking
    mapping(address => uint256) public contributions;
    mapping(address => bool) public hasReceivedNFT;

    // Chainlink PriceFeed
    AggregatorV3Interface priceFeed;
    address public constant ETH_USD_ADDR = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    // Events
    event ContributionReceived(address indexed contributor, uint256 amount);
    event TokenRewardSent(address indexed contributor, uint256 amount);
    event NFTRewardSent(address indexed contributor, uint256 tokenId);
    event FundsWithdrawn(address indexed projectOwner, uint256 amount);

    constructor(uint256 _tokenRewardRate, address _rewardToken, address _rewardNft) {
        /**
         * Network: Sepolia
         * Data Feed: ETH/USD
         * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
         */
        priceFeed = AggregatorV3Interface(ETH_USD_ADDR);
        Owner = msg.sender;
        rewardToken = RewardToken(_rewardToken);
        rewardNFT = RewardNft(_rewardNft);
        tokenRewardRate = _tokenRewardRate;
    }

    // function to retrieve ETH price in USD with Chainlink priceFeed
    function getLatestPrice() public view returns (int256) {
        (
            ,
            // uint80 roundID
            int256 answer, // uint256 startedAt
            ,
            ,

        ) = // uint256 updatedAt
            priceFeed.latestRoundData();

        return answer; // Price has 8 decimals, e.g., 3000.00000000
    }

    function contribute() external payable returns (bool) {
        require(msg.value > 0, "Contribution must be greater than 0");
        require(!isFundingComplete, "Funding goal already reached");

        // Calculate contribution amount and process any refunds

        uint256 refundableAmount = _determineIfAmountIsRefundable(msg.value);
        uint256 actualContribution = msg.value - refundableAmount;

        // check if refundable amount is > 0
        if (refundableAmount > 0) {
            transferRefundableAmount(refundableAmount, msg.sender);
        }

        // Update contribution record
        // uint256 contributionsValue = msg.value - refundableAmount;
        contributions[msg.sender] += actualContribution;
        totalFundsRaised += actualContribution;

        // Check if funding goal is reached
        if (totalFundsRaised >= FUNDING_GOAL_IN_USD) {
            isFundingComplete = true;
        }

        // Calculate token reward
        uint256 tokenReward = calculateReward(actualContribution);

        if (tokenReward > 0) {
            bool isTransfered = sendRewardToken(tokenReward, msg.sender);
            require(isTransfered, "Token transfer failed");

            // Check for NFT eligibility
            if (checkNftEligibility(msg.sender)) {
                mintNft(msg.sender);
            }

            emit ContributionReceived(msg.sender, actualContribution);
            return true;
        } else {
            return false;
        }
    }

    function checkNftEligibility(address _address) private view returns (bool) {
        return contributions[_address] >= NFT_THRESHOLD && !hasReceivedNFT[_address];
    }

    function mintNft(address _contributor) private returns (bool) {
        // require(checkNftEligibilty(_contributor), "Not eligible for NFT reward");
        uint256 tokenId = rewardNFT.mintNFT(_contributor);
        hasReceivedNFT[_contributor] = true;
        emit NFTRewardSent(_contributor, tokenId);
        return true;
    }

    function calculateReward(uint256 _value) private view returns (uint256) {
        uint256 tokenReward = (_value * tokenRewardRate) / 1 ether;
        return tokenReward;
    }

    function sendRewardToken(uint256 _tokenReward, address _recipient) private returns (bool) {
        bool success = rewardToken.transfer(_recipient, _tokenReward);
        require(success, "Token transfer failed");
        emit TokenRewardSent(msg.sender, _tokenReward);

        return true;
    }

    function _determineIfAmountIsRefundable(uint256 _contributionAmount) private view returns (uint256) {
        // Calculate the remaining amount needed to complete the funding goal
        uint256 amountToReachThreshold = FUNDING_GOAL_IN_USD - totalFundsRaised;
        if (_contributionAmount >= amountToReachThreshold) {
            // return the excess amount
            uint256 refundAmount = _contributionAmount - amountToReachThreshold;
            return refundAmount;
        }
        return 0;
    }

    function transferRefundableAmount(uint256 _amount, address _contributor) private {
        // uint256 refundable = _determineIfAmountIsRefundable(_amount);
        uint256 refundable = _amount;
        if (refundable > 0) {
            (bool success, ) = _contributor.call{value: refundable}("");
            require(success, "Transfer failed");
        }
    }

    function withdrawFunds() external {
        require(msg.sender == Owner, "Only project owner can withdraw");
        require(isFundingComplete, "Funding goal not yet reached");
        require(address(this).balance > 0, "No funds to withdraw");

        uint256 amount = address(this).balance;
        payable(Owner).transfer(amount);

        emit FundsWithdrawn(Owner, amount);
    }

    function getContribution(address contributor) external view returns (uint256) {
        return contributions[contributor];
    }
}
