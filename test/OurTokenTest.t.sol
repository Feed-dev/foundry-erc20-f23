// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address Bob = makeAddr("Bob");
    address Alice = makeAddr("Alice");
    address ZeroAddress = address(0);

    uint256 public constant STARTING_BALANCE = 100 ether;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(Bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(ourToken.balanceOf(Bob), STARTING_BALANCE);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Alice approves Bob to spend tokens on her behalf
        vm.prank(Bob);
        ourToken.approve(Alice, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(Alice);
        ourToken.transferFrom(Bob, Alice, transferAmount);
        assertEq(ourToken.balanceOf(Alice), transferAmount);
        assertEq(ourToken.balanceOf(Bob), STARTING_BALANCE - transferAmount);
    }

    function testBalanceAfterTransfer() public {
        // test balances after transfer
        uint256 transferAmount = 50;
        vm.prank(Bob);
        ourToken.transfer(Alice, transferAmount);
        assertEq(ourToken.balanceOf(Alice), transferAmount);
        assertEq(ourToken.balanceOf(Bob), STARTING_BALANCE - transferAmount);
    }
}
