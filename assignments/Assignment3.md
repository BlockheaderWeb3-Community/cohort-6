# **Assignment 3**

## Tokenized Crowdfunding Platform
---

### **Objective**  
Develop a decentralized crowdfunding platform where contributors receive **ERC20 reward tokens**, and top funders get **ERC721 NFTs** as recognition.

### **Requirements**  
1. **ERC20 Reward Token Contract**  
   - Implement a custom ERC20 token (`CrowdToken`) used as a reward for funders.  
   - Mint tokens based on contribution amount.  
   
2. **ERC721 NFT Reward Contract**  
   - Implement an ERC721 contract (`CrowdNFT`) for top funders.  
   - Automatically mint NFTs to contributors exceeding a funding threshold.  

3. **Crowdfunding Smart Contract**  
   - Track contributions and distribute ERC20 tokens according to contributions.  
   - If contribution exceeds a set threshold, mint an ERC721 NFT and send to contributor's account.  
   - Project owner can withdraw funds if a funding goal is met.  

4. **Deployment & Interaction**  
   - Deploy contracts on a testnet (Sepolia).  
   - Provide sample transactions showing funding, reward distribution, and withdrawal.  

## How to submit
- Open a pull request that adds a folder to `/submissions/Assignment3/` 
- The name of the folder should be your Github username
- The folder should contain all your work, such as your Solidity smart contracts, as well as other files that supports your submission.

## ETD (Expected Time of Delivery)
**_21/02/2025_**