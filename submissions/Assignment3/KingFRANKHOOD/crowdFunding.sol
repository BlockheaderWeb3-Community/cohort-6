// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./ERC20.sol";
import "./ERC721.sol";

/// @title A CrowdFunding Contract
/// @author FRANKHOOD
/// @notice this contract ERC20 and ERC721 tokens from the crowdFunding folder 
abstract contract CrowdFund is ERC20, ERC721{
    uint public amount;
    uint public _threshhold;
    address private crowdFund;
    bool TokenClaimed;
    bool NFTClaimed;

/// @notice funder and alreadyClaimed are the addresses that interact with the contract
/// @dev these addresse hold the ERC20 and ERC721 tokens
    mapping (address  => uint) funder;
    mapping (address => uint) alreadyClaimed;

/// @param _from is the address that calls this function by adding ERC20 to the crowFund
/// @param _amount is the amount of ERC20 added by the _from address
    event ContributionMade(address indexed _from, uint _amount);
    event TreshholdExceeded(address indexed _from, uint _amount);

/// @param _to is the address that calls this function by adding ERC20 to the crowFund
    event TokenWithdrawn(address indexed _to, uint _amount);
    event RewardReceived(address indexed _to, uint _amount);


/// @notice this function is payable so it receives the ERC20 tokens
/// @param _from is the address that calls this function by adding ERC20 to the crowFund
/// @param _amount is the amount of ERC20 added by the _from address
    function contribution(address _from, uint _amount) payable public {
        require(_amount > 0,"Contribution cannot be 0");
        balanceOf[crowdFund] += _amount;
        balanceOf[_from] -= _amount;

        funder[_from] += _amount;
        TokenClaimed = false;//this argument says that the address has not received reward tokens yet

        emit ContributionMade(_from, _amount);
    }


/// @notice this function requires the address to contribute an amount greater than 0 to the crowdFund before executing
/// @notice the receiving address cannot be address(0) 
/// @notice the tokenClaimed boolean returns as true after the function executes 
/// @param _to is the address that calls this function by adding ERC20 to the crowFund
/// @param _amount is the amount of ERC20 added by the _from address
    function _mint (address _to, uint256 _amount) virtual override public {
        require(TokenClaimed = false, "already claimed reward");
        require(alreadyClaimed[_to] == funder[_to]);
        require(funder[_to] > 0,"amount must be greater than 0");
        require(msg.sender != address(0), "zero address");
        balanceOf[_to] += _amount;
        totalSupply += _amount;

        TokenClaimed = true;//returns TokenClaimed boolean as true after execuion

        emit Transfer(address(0), _to, _amount);
        emit RewardReceived(_to, amount);
    }

/// @notice this function sets the _threshhold at 10 ether and a requirement for execution
    function threshhold(address _from, uint _amount)  public returns (uint) {
        require(_amount >= 10 ether, "not up to 10 ether");
        _threshhold = _amount;

        balanceOf[crowdFund] += _threshhold;
        balanceOf[_from] -= _threshhold;

        funder[_from] += _threshhold;

        emit TreshholdExceeded(_from, _amount);

        return _threshhold;
    }


/// @notice this function does not mint to address 0 and prevents double minting by returning NFTclaimed boolean as true after execuion
/// @param tokenId is the NFT minted when an address reaches the threshhold
    function _mintNFT(address _to, uint256 tokenId) internal override {
        require(_to != address(0), "mint to zero address");
        require(_ownerOf[tokenId] == address(0), "already minted");
        require(NFTClaimed = false,"Already Claimed");
        require(funder[_to] >= _threshhold);
        _balanceOf[_to]++;
        _ownerOf[tokenId] = _to;

        NFTClaimed = true;//returns NFTclaimed boolean as true after execuion

        emit Transfer(address(0), _to, tokenId);
        emit RewardReceived(_to, amount);
    }


/// @notice this function enables the user to withdraw their contribution
/// @notice this function requires the amount withdrawable to be less than their contribution
    function withrawal(address _to, uint _amount) public {
        require(funder[_to] <= funder[_to], "amount withdrawable cannot exceed amount comitted");
        balanceOf[crowdFund] -= _amount;
        balanceOf[_to] += _amount;

        emit TokenWithdrawn(_to, _amount);
    }
}