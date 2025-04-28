// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

interface IERC20{
    function transfer(address recipient, uint256 amount) external returns (bool);
     function mint(address _to, uint256 _amount) external;
}