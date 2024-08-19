// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TicTacToe} from "../src/TicTacToe.sol";
import "../src/TicTacToe.sol";

contract TicTacToeTest is Test {
    TicTacToe public sut;

    event GameStateEvent(string message);
    event MoveMadeEvent(string message);
    event GameOverEvent(string message);

    function setUp() public {
        sut = new TicTacToe();
    }

    function xtest_initGameBoard() public {
        vm.expectEmit();
        emit GameStateEvent("new game board created");
        sut.initGameBoard();
        assertEq(sut.gameBoard(0, 0), 10);
    }

    function xtest_newGameEvent() public {
        vm.expectEmit();
        emit GameStateEvent("new game board created");
        sut.initGameBoard();
    }

    function xtest_makeMove() public {
        vm.expectEmit();
        emit MoveMadeEvent("X moved to 1, 1");
        sut.makePlayerXMove(1, 1, 'nonce');
        uint8 x = sut.gameBoard(1, 1);
        assertEq(x, 1);
    }

    function xtest_makeBotMove() public {
        console.log(sut.nonce());
    }


    function xtest_isPlannedMoveLegal() public {
        vm.pauseGasMetering();
        sut.makePlayerXMove(2, 1, 'nonce');

        bool actual1 = sut.isPlannedMoveLegal(2, 1);
        bool actual2 = sut.isPlannedMoveLegal(0, 0);

        assertEq(actual1, false);
        assertEq(actual2, true);

        sut.makeBotMove();
    }

    function xtest_checkRowsForWinner() public {
        sut.makePlayerXMove(0, 0, 'nonce');
        sut.makePlayerXMove(0, 1, 'nonce');
        sut.makePlayerXMove(0, 2, 'nonce');

        bool actual = sut._checkBoardForWinner();
        assertTrue(actual);
    }

    function test_checkColumnsForWinner() public {
        sut.makePlayerXMove(0, 1, 'nonce');
        sut.makePlayerXMove(1, 1, 'nonce');
        sut.makePlayerXMove(2, 1, 'nonce');

        bool actual = sut._checkBoardForWinner();
        assertTrue(actual);
    }
}
