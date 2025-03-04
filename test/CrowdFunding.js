const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Crowdfunding", function () {
  let owner, user1, user2;
  let crowdfunding, crowdToken, crowdNFT;
  const fundingGoal = ethers.parseEther("5"); // 5 ETH goal
  const nftThreshold = ethers.parseEther("1"); // 1 ETH for NFT reward
  const tokenConversionRate = 1000; // 1000 CTK per ETH

  beforeEach(async function () {
    [owner, user1, user2] = await ethers.getSigners();

    // Deploy ERC20 token
    const CrowdToken = await ethers.getContractFactory("CrowdToken");
    crowdToken = await CrowdToken.deploy();
    await crowdToken.waitForDeployment();

    // Deploy NFT contract
    const CrowdNFT = await ethers.getContractFactory("CrowdNFT");
    crowdNFT = await CrowdNFT.deploy();
    await crowdNFT.waitForDeployment();

    // Deploy Crowdfunding contract
    const Crowdfunding = await ethers.getContractFactory("Crowdfunding");
    crowdfunding = await Crowdfunding.deploy(
      fundingGoal,
      nftThreshold,
      tokenConversionRate,
      await crowdToken.getAddress(),
      await crowdNFT.getAddress()
    );
    await crowdfunding.waitForDeployment();

    // Set Crowdfunding contract as minter
    await crowdToken.setMinter(await crowdfunding.getAddress());
    await crowdNFT.setMinter(await crowdfunding.getAddress());
  });

  it("should deploy with correct initial values", async function () {
    expect(await crowdfunding.fundingGoal()).to.equal(fundingGoal);
    expect(await crowdfunding.nftThreshold()).to.equal(nftThreshold);
    expect(await crowdfunding.tokenConversionRate()).to.equal(tokenConversionRate);
    expect(await crowdfunding.owner()).to.equal(owner.address);
  });

  it("should allow users to contribute and receive ERC20 rewards", async function () {
    const contribution = ethers.parseEther("2"); // 2 ETH

    await crowdfunding.connect(user1).contribute({ value: contribution });

    expect(await crowdfunding.contributions(user1.address)).to.equal(contribution);
    expect(await crowdToken.balanceOf(user1.address)).to.equal(contribution * BigInt(tokenConversionRate));
  });

  it("should mint an NFT if contribution meets the threshold", async function () {
    const contribution = ethers.parseEther("1.5"); // 1.5 ETH (above threshold)

    await crowdfunding.connect(user1).contribute({ value: contribution });

    expect(await crowdNFT.balanceOf(user1.address)).to.equal(1);
  });

  it("should not mint an NFT if contribution is below threshold", async function () {
    const contribution = ethers.parseEther("0.5"); // Below NFT threshold

    await crowdfunding.connect(user1).contribute({ value: contribution });

    expect(await crowdNFT.balanceOf(user1.address)).to.equal(0);
  });

  it("should allow the owner to withdraw funds when goal is met", async function () {
    const contribution = ethers.parseEther("5"); // Fundraising goal met

    await crowdfunding.connect(user1).contribute({ value: contribution });

    const ownerBalanceBefore = await ethers.provider.getBalance(owner.address);
    await crowdfunding.connect(owner).withdrawFunds();
    const ownerBalanceAfter = await ethers.provider.getBalance(owner.address);

    expect(ownerBalanceAfter).to.be.greaterThan(ownerBalanceBefore);
  });

  it("should not allow withdrawal if funding goal is not met", async function () {
    const contribution = ethers.parseEther("2"); // Below goal

    await crowdfunding.connect(user1).contribute({ value: contribution });

    await expect(crowdfunding.connect(owner).withdrawFunds()).to.be.revertedWith("Funding goal not met");
  });

  it("should reject contributions of 0 ETH", async function () {
    await expect(crowdfunding.connect(user1).contribute({ value: 0 })).to.be.revertedWith("Send ETH to contribute");
  });
});
