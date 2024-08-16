// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TicTacToe} from "../src/TicTacToe.sol";

contract TicTacToeTest is Test {
    TicTacToe public sut;

    function setUp() public {
        sut = new TicTacToe();
        sut.setNumber(0);
    }

    function test_initGameBoard() public{
        sut.initGameBoard();
    }

    function test_Increment() public {
        sut.increment();
        assertEq(sut.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        sut.setNumber(x);
        assertEq(sut.number(), x);
    }
}
