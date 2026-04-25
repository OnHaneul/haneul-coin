// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test,console} from "forge-std/Test.sol";
import {HaneulCoin} from "../src/HaneulCoin.sol";

contract HaneulCoinTest is Test {
    HaneulCoin public token;

    address public owner = makeAddr("owner");
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");

    uint256 public transferAmount;

    function setUp() public {
        vm.startPrank(owner);
        token = new HaneulCoin();
        vm.stopPrank();

        transferAmount = 100 * 10 ** token.decimals();
    }

    function test_NameAndSymbol() public view {
        assertEq(token.name(), "HaneulCoin");
        assertEq(token.symbol(), "HNL");
    }

    function test_InitialState() public view {
        assertEq(token.balanceOf(owner), 100_000 * 10 ** token.decimals());
        assertTrue(token.isWhitelisted(owner));
    }

    function test_OwnerCanAddWhitelist() public {
        vm.prank(owner);
        token.addToWhitelist(alice);
        assertTrue(token.isWhitelisted(alice));
    }

    function testRevert_NonOwnerCannotAddWhitelist() public {
        vm.prank(alice);
        vm.expectRevert();
        token.addToWhitelist(bob);
    }

    function test_TransferBetweenWhitelisted() public {
        vm.prank(owner);
        token.addToWhitelist(alice);

        vm.prank(owner);
        token.transfer(alice, transferAmount);

        assertEq(token.balanceOf(alice), transferAmount);
    }

    function testRevert_TransferToNonWhitelisted() public {
        vm.prank(owner);
        vm.expectRevert("HaneulCoin: Receiver is not whitelisted");
        token.transfer(bob, transferAmount);
    }

    function testRevert_TransferFromNonWhitelisted() public {
        vm.startPrank(owner);
        token.addToWhitelist(alice);
        token.transfer(alice, transferAmount);
        token.removeFromWhitelist(alice);
        vm.stopPrank();

        vm.prank(alice);
        vm.expectRevert("HaneulCoin: Sender is not whitelisted");
        token.transfer(owner, transferAmount / 2);
    }

}
