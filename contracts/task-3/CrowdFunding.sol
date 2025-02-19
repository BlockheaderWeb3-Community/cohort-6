// SPDX License Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./CrowdToken.sol";
import "./CrowdNFT.sol";

/// @title CrowdFunding Contract
/// @notice This contract provides a simple crowdfunding platform.
contract CrowdFunding {
    /// @dev State variable to store the owner of the contract
    address public owner;

    /// @dev State variable to store the funding goal
    uint256 public fundingGoal;

    /// @dev State variable to store the deadline
    uint256 public deadline;

    /// @dev State variable to store the amount raised
    uint256 public amountRaised;

    /// @dev State variable to store the balance of the contract
    uint256 public balance;

    /// @dev State variable to store the ERC20 token
    CrowdToken private crowdToken;

    /// @dev State variable to store the ERC721 token
    CrowdNFT private crowdNFT;

    /// @dev State variable to store the funders
    mapping(address => uint256) public funders;

    /// @dev Event to be emitted when the contract is funded
    event Funded(address indexed funder, uint256 amount);

    /// @dev Event to be emitted when the contract is withdrawn
    event Withdrawn(address indexed owner, uint256 amount);

    /// @dev Event to be emitted when the contract is refunded
    event Refunded(address indexed funder, uint256 amount);

    /// @dev State variable to store the NFT threshold
    uint256 public nftThreshold;

    /// @notice Constructor to set the owner, funding goal, and deadline
    /// @param _fundingGoal The funding goal for the contract
    /// @param _duration The duration for the contract
    constructor(
        uint256 _fundingGoal,
        uint256 _duration,
        address payable _crowdToken,
        address _crowdNFT,
        uint256 _nftThreshold
    ) {
        owner = msg.sender;
        fundingGoal = _fundingGoal;
        deadline = block.timestamp + _duration;
        crowdToken = CrowdToken(_crowdToken);
        crowdNFT = CrowdNFT(_crowdNFT);
        nftThreshold = _nftThreshold;
    }

    /// @notice Modifier to check if the sender is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    /// @notice Modifier to check if the deadline has passed
    modifier afterDeadline() {
        require(block.timestamp >= deadline, "Deadline has not passed");
        _;
    }

    /// @notice Modifier to check if the funding goal has been reached
    modifier goalReached() {
        require(amountRaised >= fundingGoal, "Funding goal has not been reached");
        _;
    }

    /// @notice Modifier to check if the funding goal has not been reached
    modifier goalNotReached() {
        require(amountRaised < fundingGoal, "Funding goal has been reached");
        _;
    }

    /// @notice Function to fund the contract
    function fund() public payable {
        require(block.timestamp < deadline, "Deadline has passed");
        require(msg.value > 0, "Amount must be greater than 0");

        amountRaised += msg.value;
        balance += msg.value;
        funders[msg.sender] += msg.value;

        // Mint ERC20 tokens based on contribution amount
        crowdToken.mint(address(this), msg.value);

        emit Funded(msg.sender, msg.value);

        if (funders[msg.sender] >= nftThreshold) {
            // minting NFT for the funder
            uint256 tokenId = uint256(keccak256(abi.encodePacked(msg.sender)));
            crowdNFT._mint(msg.sender, tokenId);
        }
    }

    /// @notice Function to withdraw funds if funding goal is met
    function withdrawFunds() public onlyOwner goalReached afterDeadline {
        payable(owner).transfer(balance);
        emit Withdrawn(owner, balance);
    }

    /// @notice Function to refund contributors if funding goal is not met
    function refund() public goalNotReached afterDeadline {
        uint256 amount = funders[msg.sender];
        require(amount > 0, "No funds to refund");

        funders[msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit Refunded(msg.sender, amount);
    }
}
