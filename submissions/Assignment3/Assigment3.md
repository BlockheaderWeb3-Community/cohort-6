# Assignment3

here's link to [assignment 3](../../contracts/Assignment3/crowdFunding.sol)

# Tokenized Crowdfunding Platform

## Overview

This project is a decentralized crowdfunding platform where contributors receive **ERC20 reward tokens**, and top funders receive **ERC721 NFTs** as recognition. The platform tracks contributions, distributes rewards, and allows the project owner to withdraw funds upon reaching the funding goal.

## Features

- **ERC20 Reward Token (`CrowdToken`)**: Contributors receive tokens based on their contribution amount.
- **ERC721 NFT Reward (`CrowdNFT`)**: Top contributors exceeding a set threshold receive an NFT.
- **Crowdfunding Contract (`CrowdFunding`)**:
  - Tracks contributions and distributes rewards.
  - Allows fund withdrawal once the funding goal is met.

## Smart Contracts

### 1. `CrowdToken.sol` (ERC20 Reward Token)

- Implements a custom ERC20 token (`CrowdToken`).
- Allows minting of tokens based on the contributor's donation.
- Functions:
  - `mint(address to, uint256 amount)`: Mints tokens to a contributor.
  - `transfer(address to, uint256 amount)`: Transfers tokens.
  - `approve(address spender, uint256 amount)`: Approves token spending.
  - `transferFrom(address from, address to, uint256 amount)`: Transfers approved tokens.

### 2. `CrowdNFT.sol` (ERC721 NFT Reward)

- Implements an ERC721 contract (`CrowdNFT`) to reward top funders.
- Only one NFT per contributor.
- Functions:
  - `mint(address to)`: Mints an NFT to a top contributor.
  - `transferFrom(address from, address to, uint256 tokenId)`: Transfers ownership of an NFT.
  - `approve(address to, uint256 tokenId)`: Approves an NFT transfer.
  - `getApproved(uint256 tokenId)`: Returns the approved address for an NFT.

### 3. `CrowdFunding.sol` (Crowdfunding Contract)

- Handles contributions and rewards.
- Allows fund withdrawal upon reaching the funding goal.
- Functions:
  - `contribute()`: Accepts ETH contributions, distributes ERC20 tokens, and mints NFTs if applicable.
  - `withdrawFunds()`: Allows the owner to withdraw funds if the funding goal is reached.

## Deployment & Testing

### **Prerequisites**

- Solidity compiler (`solc`)
- Hardhat or Remix IDE
- Sepolia testnet setup with MetaMask

### **Deployment Steps**

1. **Deploy `CrowdToken.sol`**
2. **Deploy `CrowdNFT.sol`**
3. **Deploy `CrowdFunding.sol`** with addresses of `CrowdToken` and `CrowdNFT`

### **Testing**

1. **Contribute ETH** and receive ERC20 tokens.
2. **Contribute above the NFT threshold** to receive an ERC721 NFT.
3. **Withdraw funds** after reaching the funding goal.

## Sample Transactions

- Contributor donates `0.5 ETH` → Receives `500 CRWD`
- Contributor donates `2 ETH` (above threshold) → Receives `2000 CRWD` + `1 NFT`
- Owner withdraws funds after goal is met.

## License

This project is licensed under the **MIT License**.

---
