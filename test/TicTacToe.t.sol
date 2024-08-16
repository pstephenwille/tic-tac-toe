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

        uint8 board = sut.gameBoard(1,2);
        console.log(board);
    }


}
