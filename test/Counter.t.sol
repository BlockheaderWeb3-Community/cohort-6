// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "forge-std/Test.sol";
import { Counter } from "../contracts/with-foundry/Counter.sol";

contract CounterTest is Test {
  Counter public counter;
  address public owner;
  address public nonOwner;
  // set up the counter contract deployment

  function setUp() public {
    // Set up addresses
    owner = address(1);
    nonOwner = address(2);

    console.log("Owner: ", owner);
    console.log("Non-Owner: ", nonOwner);

    // Deploy contract as owner
    vm.prank(owner);
    counter = new Counter();
  }
  // test increment function

  function test_Increment() public {
    assertEq(counter.number(), 0);
    vm.prank(owner);
    counter.increment();
    assertEq(counter.number(), 1);
  }

  // test decrement function
  function test_Decrement() public {
    assertEq(counter.number(), 0);
    vm.prank(owner);
    counter.add(5);
    assertEq(counter.number(), 5);
    vm.prank(owner);
    counter.decrement();
    assertEq(counter.number(), 4);
  }

  // test add by value function
  function test_Add() public {
    assertEq(counter.number(), 0);
    vm.prank(owner);
    counter.add(5);
    assertEq(counter.number(), 5);
  }

  // test substract by value function
  function test_Sub() public {
    assertEq(counter.number(), 0);
    counter.setNumber(10);
    vm.prank(owner);
    counter.sub(5);
    assertEq(counter.number(), 5);
  }

  // test multiply by value function
  function test_Mul() public {
    assertEq(counter.number(), 0);
    counter.setNumber(5);
    vm.prank(owner);
    counter.mul(5);
    assertEq(counter.number(), 25);
  }

  // test divide by value function
  function test_Div() public {
    assertEq(counter.number(), 0);
    counter.setNumber(10);
    vm.prank(owner);
    counter.div(2);
    assertEq(counter.number(), 5);
  }

  // test if a number is even
  function test_IsEven() public {
    vm.startPrank(owner);

    // Test even numbers
    assertTrue(counter.isEven(2), "2 should be even");
    assertTrue(counter.isEven(0), "0 should be even");
    assertTrue(counter.isEven(100), "100 should be even");

    // Test that odd numbers return false
    assertFalse(counter.isEven(1), "1 should not be even");
    assertFalse(counter.isEven(99), "99 should not be even");

    vm.stopPrank();
  }

  // test if a number is odd
  function testIsOdd() public {
    vm.startPrank(owner);

    // Test odd numbers
    assertTrue(counter.isOdd(1), "1 should be odd");
    assertTrue(counter.isOdd(99), "99 should be odd");
    assertTrue(counter.isOdd(777), "777 should be odd");

    // Test that even numbers return false
    assertFalse(counter.isOdd(2), "2 should not be odd");
    assertFalse(counter.isOdd(0), "0 should not be odd");

    vm.stopPrank();
  }

  // test reset function
  function test_Reset() public {
    counter.setNumber(10);
    vm.prank(owner);
    counter.reset();
    assertEq(counter.number(), 0);
  }

  // test get total function
  function test_Get_Total() public {
    assertEq(counter.number(), 0);
    counter.setNumber(10);
    vm.prank(owner);
    counter.getTotal();
    assertEq(counter.number(), 10);
  }

  // Testing for non-owner and expect revert with error message
  // test increment function
  function test_IncrementNonOwner() public {
    assertEq(counter.number(), 0);
    vm.prank(nonOwner);
    vm.expectRevert("Only owner can call this function");
    counter.increment();
    assertEq(counter.number(), 0);
  }

  // test decrement function
  function test_DecrementNonOwner() public {
    assertEq(counter.number(), 0);
    vm.prank(nonOwner);
    vm.expectRevert("Only owner can call this function");
    counter.add(5);
    assertEq(counter.number(), 0);
    vm.prank(nonOwner);
    vm.expectRevert("Only owner can call this function");
    counter.decrement();
    assertEq(counter.number(), 0);
  }

  // test add by value function
  function test_AddNonOwner() public {
    assertEq(counter.number(), 0);
    vm.prank(nonOwner);
    vm.expectRevert("Only owner can call this function");
    counter.add(5);
    assertEq(counter.number(), 0);
  }

  // test substract by value function
  function test_SubNonOwner() public {
    assertEq(counter.number(), 0);
    counter.setNumber(10);
    vm.prank(nonOwner);
    vm.expectRevert("Only owner can call this function");
    counter.sub(5);
    assertEq(counter.number(), 10);
  }

  // test multiply by value function
  function test_MulNonOwner() public {
    assertEq(counter.number(), 0);
    counter.setNumber(5);
    vm.prank(nonOwner);
    vm.expectRevert("Only owner can call this function");
    counter.mul(5);
    assertEq(counter.number(), 5);
  }

  // test divide by value function
  function test_DivNonOwner() public {
    assertEq(counter.number(), 0);
    counter.setNumber(10);
    vm.prank(nonOwner);
    vm.expectRevert("Only owner can call this function");
    counter.div(2);
    assertEq(counter.number(), 10);
  }

  // test if a number is even
  function test_IsEvenNonOwner() public {
    // Test even numbers
    vm.prank(nonOwner);
    vm.expectRevert("Only owner can call this function");
    counter.isEven(2);
  }

  // test if a number is odd
  function testIsOddNonOwner() public {
    // Test odd numbers
    vm.prank(nonOwner);
    vm.expectRevert("Only owner can call this function");
    counter.isOdd(9);
  }

  // test reset function
  function test_ResetNonOwner() public {
    counter.setNumber(10);
    vm.prank(nonOwner);
    vm.expectRevert("Only owner can call this function");
    counter.reset();
    assertEq(counter.number(), 10);
  }

  // // test get total function
  function test_Get_TotalNonOwner() public {
    assertEq(counter.number(), 0);
    counter.setNumber(10);
    vm.prank(nonOwner);
    vm.expectRevert("Only owner can call this function");
    counter.getTotal();
    assertEq(counter.number(), 10);
  }
}
