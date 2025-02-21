// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

interface IERC20 {
    function mint(address _to, uint256 _amount) external;
}

interface IOLOWONFT {
    function mint(address _to, uint256 _tokenId) external;
}

contract Crowdfunding {
    enum CampaignStatus {
        NotYet,
        Completed
    }

    struct Campaign {
        address creator;
        uint256 goal;
        uint256 deadline;
        uint256 totalContributions;
        bool isFunded;
        CampaignStatus completed;
    }

    IERC20 public token;
    IOLOWONFT public nft;
    Campaign public campaign;
    mapping(address => uint256) public contributions;
    mapping(address => bool) public hasReceivedNFT;

    event GoalReached(uint256 totalContributions);
    event DeadlineReached(uint256 totalContributions);
    event NFTRewarded(address indexed user, uint256 tokenId);
    event ContributionMade(address indexed contributor, uint256 amountInEther);

    constructor(address _token, address _nft, uint256 fundingGoalInEther, uint256 durationInDays) {
        token = IERC20(_token);
        nft = IOLOWONFT(_nft);

        campaign = Campaign({
            creator: msg.sender,
            goal: fundingGoalInEther * 1 ether,
            deadline: block.timestamp + durationInDays * 1 days,
            totalContributions: 0,
            isFunded: false,
            completed: CampaignStatus.NotYet
        });
    }

    modifier onlyCreator() {
        require(msg.sender == campaign.creator, "Only the creator can call this function");
        _;
    }

    function contribute() public payable {
        require(block.timestamp < campaign.deadline, "Funding period has ended");
        require(campaign.completed == CampaignStatus.NotYet, "Crowdfunding is already completed");
        require(msg.value > 0, "Contribution must be greater than 0");

        uint256 contribution = msg.value;
        contributions[msg.sender] += contribution;
        campaign.totalContributions += contribution;

        emit ContributionMade(msg.sender, contribution / 1 ether);

        uint256 tokenAmount = contribution * 1000;
        token.mint(msg.sender, tokenAmount);

        if (contributions[msg.sender] >= (campaign.goal * 30) / 100 && !hasReceivedNFT[msg.sender]) {
            uint256 tokenId = uint256(uint160(msg.sender));
            nft.mint(msg.sender, tokenId);
            hasReceivedNFT[msg.sender] = true;
            emit NFTRewarded(msg.sender, tokenId);
        }

        if (campaign.totalContributions >= campaign.goal) {
            campaign.isFunded = true;
            emit GoalReached(campaign.totalContributions);
        }
    }

    function withdrawContribution() public onlyCreator {
        require(campaign.isFunded, "Goal has not been reached");
        require(campaign.completed == CampaignStatus.NotYet, "Crowdfunding is already completed.");

        campaign.completed = CampaignStatus.Completed;
        payable(campaign.creator).transfer(address(this).balance);
    }

    function getCurrentBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function extendDeadline(uint256 durationInDays) public onlyCreator {
        campaign.deadline += durationInDays * 1 days;
    }

    function getGoalAmount() public view returns (uint256) {
        return campaign.goal;
    }
}
