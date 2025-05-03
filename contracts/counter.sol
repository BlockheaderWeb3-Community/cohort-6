// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter {
    uint256 private count;
    address public owner;

    event CounterIncremented(uint256 newCount);
    event CounterDecremented(uint256 newCount);

    constructor() {
        owner = msg.sender;
        count = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can modify the counter");
        _;
    }

    function increment() public onlyOwner {
        count++;
        emit CounterIncremented(count);
    }

    function decrement() public onlyOwner {
        require(count > 0, "Counter cannot be negative");
        count--;
        emit CounterDecremented(count);
    }

    function getCount() public view returns (uint256) {
        return count;
    }
}
