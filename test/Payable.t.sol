// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.24;

// import {Test, console} from "forge-std/Test.sol";
// import {Payable} from "../src/Payable.sol";

// contract PayableTest is Test {
//     Payable public payableContract;
//     address public owner;
//     address public user1;
//     address public user2;

//     function setUp() public {
//         owner = vm.addr(1);
//         user1 = vm.addr(2);
//         user2 = vm.addr(3);

//         console.log("Owner: ", owner);
//         console.log("User 1: ", user1);
//         console.log("User 2: ", user2);

//         vm.prank(owner);
//         payableContract = new Payable();
//     }

//     function test_Deposit() public {
//         vm.deal(user1, 1 ether); // Give user1 some ETH
//         vm.startPrank(user1);

//         payableContract.deposit{value: 0.1 ether}(0.1 ether);

//         assertEq(payableContract.getInvestment(user1), 0.1 ether);
//         assertEq(payableContract.getContractBalance(), 0.1 ether);

//         vm.stopPrank();
//     }

//     function test_GetInvestment() public {
//         vm.deal(user1, 1 ether); // Give user1 some ETH
//         vm.startPrank(user1);

//         payableContract.deposit{value: 0.1 ether}(0.1 ether);

//         assertEq(payableContract.getInvestment(user1), 0.1 ether);

//         vm.stopPrank();
//     }

//     function test_GetContractBalance() public {
//         vm.deal(user1, 1 ether); // Give user1 some ETH
//         vm.startPrank(user1);

//         payableContract.deposit{value: 0.1 ether}(0.1 ether);

//         assertEq(payableContract.getContractBalance(), 0.1 ether);

//         vm.stopPrank();
//     }

//     function test_GetMyEthBalance() public {
//         vm.deal(user1, 1 ether); // Give user1 some ETH
//         vm.startPrank(user1);

//         payableContract.deposit{value: 0.1 ether}(0.1 ether);

//         assertEq(payableContract.getMyEthBalance(), 0.9 ether);

//         vm.stopPrank();
//     }
// }
