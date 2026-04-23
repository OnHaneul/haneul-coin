// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {HaneulCoin} from "../src/HaneulCoin.sol";

contract HaneulCoinTest is Test {
    HaneulCoin internal token;

    function setUp() public {
        token = new HaneulCoin();
    }

    function test_NameAndSymbol() public view {
        assertEq(token.name(), "HaneulCoin");
        assertEq(token.symbol(), "HNL");
    }

    function test_InitialBalanceIs100k() public view {
        uint256 expected = 100_000 * 10 ** token.decimals();
        assertEq(token.balanceOf(address(this)), expected);
    }
}
