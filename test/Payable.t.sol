// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../contracts/Payable.sol"; 

contract ContractsTest is Test {
    // Contracts to test
    Payable payableContract;
    Funder funderContract;

    // Test accounts
    address owner = address(this);
    address addr1 = address(0x1);
    address addr2 = address(0x2);

    // Initial values
    uint256 initialDeployAmount = 1 ether;

    function setUp() public {
        // Deploy contracts
        vm.startPrank(owner);
        payableContract = new Payable{value: initialDeployAmount}();
        funderContract = new Funder();
        vm.stopPrank();

        // Fund test accounts
        vm.deal(addr1, 10 ether);
        vm.deal(addr2, 10 ether);
        vm.deal(address(funderContract), 5 ether);
    }

    //---------- Payable Contract Tests ----------//

    function test_Constructor() public {
        assertEq(payableContract.owner(), owner);
        assertEq(address(payableContract).balance, initialDeployAmount);
    }

    function test_Deposit() public {
        uint256 depositAmount = 2 ether;

        // Check initial state
        assertEq(payableContract.getInvestment(addr1), 0);

        // Make deposit
        vm.prank(addr1);
        uint256 returnedAmount = payableContract.deposit{value: depositAmount}(depositAmount);

        // Check results
        assertEq(returnedAmount, depositAmount);
        assertEq(payableContract.getInvestment(addr1), depositAmount);
        assertEq(address(payableContract).balance, initialDeployAmount + depositAmount);
    }

    function test_Deposit_With_Incorrect_Value() public {
        // Try to deposit with mismatched values
        vm.prank(addr1);
        vm.expectRevert("msg.value must equal eth");
        payableContract.deposit{value: 1 ether}(2 ether);
    }

    function test_Get_Investment() public {
        // Make deposits from different accounts
        vm.prank(addr1);
        payableContract.deposit{value: 2 ether}(2 ether);

        vm.prank(addr2);
        payableContract.deposit{value: 3 ether}(3 ether);

        // Check investments
        assertEq(payableContract.getInvestment(addr1), 2 ether);
        assertEq(payableContract.getInvestment(addr2), 3 ether);
        assertEq(payableContract.getInvestment(owner), 0);
    }

    function test_Get_Contract_Balance() public {
        // Initial balance
        assertEq(payableContract.getContractBalance(), 1); // 1 ether

        // Add funds
        vm.prank(addr1);
        payableContract.deposit{value: 2 ether}(2 ether);
        assertEq(payableContract.getContractBalance(), 3); // 3 ether

        // Add more funds
        vm.deal(address(payableContract), address(payableContract).balance + 0.5 ether);
        assertEq(payableContract.getContractBalance(), 3); // Still shows 3 because of division by 1 ether

        // Add enough to see change
        vm.deal(address(payableContract), address(payableContract).balance + 1 ether);
        assertEq(payableContract.getContractBalance(), 4); // Now 4 ether
    }

    function test_GetMyEthBalance() public {
        // Test with addr1
        vm.deal(addr1, 5 ether);
        vm.prank(addr1);
        assertEq(payableContract.getMyEthBalance(), 5 ether);

        // Test with addr2
        vm.deal(addr2, 7 ether);
        vm.prank(addr2);
        assertEq(payableContract.getMyEthBalance(), 7 ether);
    }

    function test_ReceiveFunction() public {
        uint256 initialBalance = address(payableContract).balance;

        // Send ETH directly
        vm.prank(addr1);
        (bool success,) = address(payableContract).call{value: 1 ether}("");

        assertTrue(success);
        assertEq(address(payableContract).balance, initialBalance + 1 ether);
    }

    function test_FallbackFunction() public {
        // Initial counter
        assertEq(payableContract.counter(), 0);

        // Call non-existent function
        vm.prank(addr1);
        (bool success,) =
            address(payableContract).call{value: 0.5 ether}(abi.encodeWithSignature("nonExistentFunction()"));

        assertTrue(success);
        assertEq(payableContract.counter(), 1);
        assertEq(address(payableContract).balance, initialDeployAmount + 0.5 ether);

        // Call another non-existent function
        vm.prank(addr2);
        (success,) =
            address(payableContract).call{value: 0.3 ether}(abi.encodeWithSignature("anotherNonExistentFunction()"));

        assertTrue(success);
        assertEq(payableContract.counter(), 2);
        assertEq(address(payableContract).balance, initialDeployAmount + 0.8 ether);
    }

    //---------- Funder Contract Tests ----------//

    function test_SendWithTransfer() public {
        uint256 initialBalance = address(payableContract).balance;
        uint256 sendAmount = 1 ether;

        // Send ETH using transfer
        vm.prank(addr1);
        funderContract.sendWithTransfer{value: sendAmount}(payable(address(payableContract)));

        // Check the balance
        assertEq(address(payableContract).balance, initialBalance + sendAmount);
    }

    function test_SendWithSend() public {
        uint256 initialBalance = address(payableContract).balance;
        uint256 sendAmount = 2 ether;

        // Send ETH using send
        vm.prank(addr2);
        bool sent = funderContract.sendWithSend{value: sendAmount}(payable(address(payableContract)));

        // Check results
        assertTrue(sent);
        assertEq(address(payableContract).balance, initialBalance + sendAmount);
    }

    function test_SendWithCall() public {
        uint256 initialBalance = address(payableContract).balance;
        uint256 sendAmount = 1.5 ether;

        // Send ETH using call
        vm.prank(addr1);
        (bool sent, bytes memory data) =
            funderContract.sendWithCall{value: sendAmount}(payable(address(payableContract)));

        // Check results
        assertTrue(sent);
        assertEq(data.length, 0); // No data returned from receive function
        assertEq(address(payableContract).balance, initialBalance + sendAmount);
    }

    function test_CallDeposit() public {
        uint256 initialBalance = address(payableContract).balance;
        uint256 depositAmount = 3 ether;

        // Before deposit
        assertEq(payableContract.getInvestment(address(funderContract)), 0);

        // Call deposit through funder
        vm.prank(addr2);
        funderContract.callDeposit{value: depositAmount}(payable(address(payableContract)));

        // Check results
        assertEq(payableContract.getInvestment(address(funderContract)), depositAmount);
        assertEq(address(payableContract).balance, initialBalance + depositAmount);
    }

    function test_SendWithCall_ToNonPayableContract() public {
        // Deploy a non-payable contract
        MockNonPayableContract nonPayableContract = new MockNonPayableContract();

        // Try to send ETH with send (should fail butit won't revert yet)
        vm.prank(addr1);
        vm.expectRevert(Funder.FailedToSendEth.selector);
        funderContract.sendWithSend{value: 1 ether}(payable(address(nonPayableContract)));

        // Try to send ETH with call (should revert)
        vm.prank(addr1);
        vm.expectRevert("failed to send eth");
        funderContract.sendWithCall{value: 1 ether}(payable(address(nonPayableContract)));
    }

    // Fuzz testing for deposit
    function testFuzz_Deposit(uint96 amount) public {
        vm.assume(amount > 0 && amount <= 10 ether); // Keep values reasonable

        // Fund addr1
        vm.deal(addr1, uint256(amount));

        // Make deposit
        vm.prank(addr1);
        uint256 returnedAmount = payableContract.deposit{value: amount}(amount);

        // Check results
        assertEq(returnedAmount, amount);
        assertEq(payableContract.getInvestment(addr1), amount);
        assertEq(address(payableContract).balance, initialDeployAmount + amount);
    }

    // Fuzz testing for different ETH sending methods
    function testFuzz_SendMethods(uint96 amount) public {
        vm.assume(amount > 0 && amount <= 5 ether); // Keep values reasonable

        uint256 amountValue = uint256(amount);
        uint256 initialBalance = address(payableContract).balance;

        // Test transfer
        vm.deal(addr1, amountValue);
        vm.prank(addr1);
        funderContract.sendWithTransfer{value: amountValue}(payable(address(payableContract)));
        assertEq(address(payableContract).balance, initialBalance + amountValue);
        initialBalance = address(payableContract).balance;

        // Test send
        vm.deal(addr2, amountValue);
        vm.prank(addr2);
        bool sent = funderContract.sendWithSend{value: amountValue}(payable(address(payableContract)));
        assertTrue(sent);
        assertEq(address(payableContract).balance, initialBalance + amountValue);
        initialBalance = address(payableContract).balance;

        // Test call
        vm.deal(addr1, amountValue);
        vm.prank(addr1);
        (bool success,) = funderContract.sendWithCall{value: amountValue}(payable(address(payableContract)));
        assertTrue(success);
        assertEq(address(payableContract).balance, initialBalance + amountValue);
    }
}

// Mock contract without receive or fallback functions
//To test for a failed send using call
contract MockNonPayableContract {
// This contract cannot receive ETH
}
