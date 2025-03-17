// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    // test increment function
    function increment() public onlyOwner {
        number++;
    }

    // test decrement function
    function decrement() public onlyOwner {
        number--;
    }

    // test add by value function
    function add(uint256 x) public onlyOwner {
        number += x;
    }

    // test substract by value function
    function sub(uint256 x) public onlyOwner {
        number -= x;
    }

    // test multiply by value function
    function mul(uint256 x) public onlyOwner {
        number *= x;
    }

    // test divide by value function
    function div(uint256 x) public onlyOwner {
        number /= x;
    }

    // test if a number is even
    function isEven(uint256 x) public view onlyOwner returns (bool) {
        return x % 2 == 0;
    }

    // test if a number is odd
    function isOdd(uint256 x) public view onlyOwner returns (bool) {
        return x % 2 != 0;
    }

    // test reset function
    function reset() public onlyOwner {
        number = 0;
    }

    // test get total function
    function getTotal() public view onlyOwner returns (uint256) {
        return number;
    }
}
