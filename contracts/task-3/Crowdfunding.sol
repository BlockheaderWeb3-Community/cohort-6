// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

 /// @title Crowdfunding Smart Contract
 /// @dev Implements a simple crowdfunding system with ERC20 token rewards.

  /// @dev Mints tokens to a specified address.
interface IERC20 {
    function mint(address _to, uint256 _amount) external;
}

contract Crowdfunding {
     /// @dev Enum to track the campaign status.
    enum CampaignStatus { NotYet, Completed }

     /// @dev Struct representing the crowdfunding campaign details.
     /// @param Address of the campain creator
     /// @param goal Fundraising goal of the campain.
     /// @param deadline the campaign deadline
    /// @param   the Total contributions received
    /// @param  isFunded Whether the funding goal is met
    /// @param  Campaign status
    struct Campaign {
        address creator;
        uint256 goal;
        uint256 deadline;
        uint256 totalContributions;
        bool isFunded;
        CampaignStatus completed;
    }
    /// @notice  ERC20 contract reference
    IERC20 public token; 
    /// @dev Campaign details
    Campaign public campaign;
    /// @dev Tracks contributions per address.
    mapping(address => uint256) public contributions;

    /// @notice Emitted when the fundraising goal is reached.
    /// @param totalContributions of the  total amount of ETH raised.
    event GoalReached(uint256 totalContributions);
        /// @notice Emitted when the deadline is reached.
    /// @param totalContributions The final total amount raised.
    event DeadlineReached(uint256 totalContributions);



     /// dev Initializes the crowdfunding contract.
     /// @param _token The ERC20 token contract address.
     /// @param fundingGoalInEther The fundraising goal in ETH.
     /// @param durationInDays The campaign duration in days.

    constructor  (address _token, uint256 fundingGoalInEther, uint256 durationInDays) {
        token = IERC20(_token); 

        campaign = Campaign({
            creator: msg.sender,
            goal: fundingGoalInEther * 1 ether,
            deadline: block.timestamp + durationInDays * 1 days,
            totalContributions: 0,
            isFunded: false,
            completed: CampaignStatus.NotYet
        });
    }
    /// Restricts function access to the campaign creator.
    modifier onlyCreator() {
        require(msg.sender == campaign.creator, "Only the creator can call this function");
        _;
    }

    /// @notice Allows users to contribute ETH to the campaign.
    /// @dev Contributors receive ERC20 tokens in return.

    function contribute() public payable {
        require(block.timestamp < campaign.deadline, "Funding period has ended");
        require(campaign.completed == CampaignStatus.NotYet, "Crowdfunding is already completed");

        uint256 contribution = msg.value;
        contributions[msg.sender] += contribution;
        campaign.totalContributions += contribution;

        // Mint tokens based on contribution amount
        uint256 tokenAmount = contribution * 1000;
        token.mint(msg.sender, tokenAmount);

        if (campaign.totalContributions >= campaign.goal) {
            campaign.isFunded = true;
            emit GoalReached(campaign.totalContributions);
        }
    }

    /// @notice Allows the campaign creator to withdraw the raised funds.
     /// @dev Can only be called if the campaign goal is met.

    function withdrawContribution() public onlyCreator {
        require(campaign.isFunded, "Goal has not been reached");
        require(campaign.completed == CampaignStatus.NotYet, "Crowdfunding is already completed.");

        campaign.completed = CampaignStatus.Completed;
        payable(campaign.creator).transfer(address(this).balance);
    }

    
     /// notice Returns the contract's current ETH balance.
     /// @return The ETH balance held by the contract.
    function getCurrentBalance() public view returns (uint256) {
        return address(this).balance;
    }
    /// @notice Extends the campaign deadline.
     /// @param durationInDays The number of extra days to add.
    function extendDeadline(uint256 durationInDays) public onlyCreator {
        campaign.deadline += durationInDays * 1 days;
    }
}
