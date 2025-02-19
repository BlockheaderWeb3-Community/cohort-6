// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

import "./ERC20.sol";
import "./ERC721.sol";

contract CrowdFundingContract{
    bool public fundingGoalMet = false;
    uint public fundingThreshold;
    uint public fundingGoal;
    address public owner;

    // initialize imported files
    ERC20 private erc20;
    ERC721 private erc721; 

    // Mapping
    mapping(address => uint256) public _tokenBalances;
    mapping(address => uint256) public _contributions;

    // Events
    event trackContributions(address contributor, uint amount);

    constructor(uint  _fundingGoal, uint _fundingThreshold, address payable Erc20Address, address Erc721Address){
        fundingGoal = _fundingGoal;
        fundingThreshold = _fundingThreshold;
        owner = msg.sender;
        erc20 = ERC20(Erc20Address); //0xdA36e707Af22009FA453Fe3D2707c510C8E4AC46
        erc721 = ERC721(Erc721Address); //0xee41a93503C6007c72BbfEc027412430B3c743F0
    }


    // modifiers
    modifier onlyOwner(){
        require(msg.sender == owner, "Not owner");    
    _;
    }

    // Functions
    // Tracking contributions
    // Contribution exceed a set threshold, mint an ERC721 NFT and send to contributor's account
    function exceedThreshold(address to ) external onlyOwner payable {
        if (address(this).balance < fundingGoal){
            require(msg.value > 0, "contributions must be above 0");
            _contributions[msg.sender] += msg.value;
            if(msg.value > fundingThreshold){
                uint256 tokenId = uint256(keccak256(abi.encodePacked(msg.sender)));
                erc721._mint(to, tokenId);
            }
            else{
                erc20.mint(to, msg.value);
            }
        }
        else{
        // withdraw funds
        uint balance = address(this).balance;
        address payable sendTo = payable(owner);
        sendTo.transfer(balance);
        fundingGoalMet = true;
        }
        
    }

    
}