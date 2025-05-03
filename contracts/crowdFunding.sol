// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CrowdToken is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("CrowdToken", "CTK") {
        _mint(msg.sender, 1000000 * 10 ** decimals()); // Initial supply
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}

contract CrowdNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("CrowdNFT", "CNFT") {}

    function mintNFT(address recipient) external onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        return newItemId;
    }
}

contract CrowdfundingPlatform is Ownable {
    CrowdToken public rewardToken;
    CrowdNFT public rewardNFT;
    uint256 public fundingGoal;
    uint256 public totalFunds;
    uint256 public nftThreshold;
    mapping(address => uint256) public contributions;

    event Funded(address indexed contributor, uint256 amount);
    event NFTAwarded(address indexed recipient, uint256 tokenId);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    constructor(address _rewardToken, address _rewardNFT, uint256 _fundingGoal, uint256 _nftThreshold) {
        rewardToken = CrowdToken(_rewardToken);
        rewardNFT = CrowdNFT(_rewardNFT);
        fundingGoal = _fundingGoal;
        nftThreshold = _nftThreshold;
    }

    function contribute() public payable {
        require(msg.value > 0, "Contribution must be greater than 0");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;

        uint256 rewardAmount = msg.value * 10; // Reward calculation logic
        rewardToken.mint(msg.sender, rewardAmount);
        emit Funded(msg.sender, msg.value);

        if (contributions[msg.sender] >= nftThreshold) {
            uint256 tokenId = rewardNFT.mintNFT(msg.sender);
            emit NFTAwarded(msg.sender, tokenId);
        }
    }

    function withdrawFunds() public onlyOwner {
        require(totalFunds >= fundingGoal, "Funding goal not met");
        payable(owner()).transfer(address(this).balance);
        emit FundsWithdrawn(owner(), totalFunds);
    }
}
