
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdToken {
    string public name = "CrowdToken";
    string public symbol = "CRT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        owner = msg.sender;
        totalSupply = 1000000 * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }
}

contract CrowdNFT {
    string public name = "CrowdNFT";
    string public symbol = "CNFT";
    uint256 public totalSupply;
    address public owner;
    mapping(uint256 => address) public tokenOwner;
    mapping(address => uint256) public ownerTokenCount;

    event Mint(address indexed owner, uint256 tokenId);

    constructor() {
        owner = msg.sender;
    }

    function mint(address to) public {
        require(msg.sender == owner, "Only owner can mint");
        totalSupply++;
        tokenOwner[totalSupply] = to;
        ownerTokenCount[to]++;
        emit Mint(to, totalSupply);
    }
}

contract CrowdFund {
    address public owner;
    uint256 public fundingGoal;
    uint256 public nftThreshold;
    uint256 public totalFunds;
    mapping(address => uint256) public contributions;
    CrowdToken public crowdToken;
    CrowdNFT public crowdNFT;

    event ContributionReceived(address indexed contributor, uint256 amount);
    event NFTRewarded(address indexed contributor, uint256 tokenId);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    constructor(uint256 _fundingGoal, uint256 _nftThreshold) {
        owner = msg.sender;
        fundingGoal = _fundingGoal;
        nftThreshold = _nftThreshold;
        crowdToken = new CrowdToken();
        crowdNFT = new CrowdNFT();
    }

    function contribute() public payable {
        require(msg.value > 0, "Contribution must be greater than 0");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;

        uint256 tokenAmount = msg.value * 100;
        crowdToken.transfer(msg.sender, tokenAmount);
        emit ContributionReceived(msg.sender, msg.value);

        if (contributions[msg.sender] >= nftThreshold) {
            crowdNFT.mint(msg.sender);
            emit NFTRewarded(msg.sender, crowdNFT.totalSupply());
        }
    }

    function withdrawFunds() public {
        require(msg.sender == owner, "Not the owner");
        require(totalFunds >= fundingGoal, "Funding goal not met");
        payable(owner).transfer(address(this).balance);
        emit FundsWithdrawn(owner, totalFunds);
    }
}
