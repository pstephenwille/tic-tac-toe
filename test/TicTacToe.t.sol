// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console, stdStorage, StdStorage} from "forge-std/Test.sol";
import {TicTacToe} from "../src/TicTacToe.sol";
import "../src/TicTacToe.sol";

contract TicTacToeTest is Test {
    using stdStorage for StdStorage;

    TicTacToe public sut;

    event GameStateEvent(string message);
    event MoveMadeEvent(string message);
    event GameOverEvent(string message);

    function setUp() public {
        sut = new TicTacToe();
        sut.initGameBoard();
    }

    function test_initGameBoard() public {
        vm.expectEmit();
        emit GameStateEvent("new game board created");
        sut.initGameBoard();
    }

    function xtest_newGameEvent() public {
        vm.expectEmit();
        emit GameStateEvent("new game board created");
        sut.initGameBoard();
    }


    function test_makePlayerXMove() public {
        sut.makePlayerMove(5, "fake nonce");
    }

    function xtest_makeBotMove() public {
        console.log(sut.nonce());
    }

    function test_findColumnWinner() public {
        sut.makePlayerMove(1, "1111");
        sut.makePlayerMove(4, "1111");
        sut.makePlayerMove(7, "1111");

        bool actual = sut._findColumnWinner();

        assertTrue(actual);
    }

    function test_findRowWinner() public {
    }

    function xtest_isPlannedMoveLegal() public {
        vm.pauseGasMetering();
        sut.makePlayerMove(2, 'nonce');

        bool actual1 = sut.isMoveLegal(2);
        bool actual2 = sut.isMoveLegal(0);

        assertEq(actual1, false);
        assertEq(actual2, true);

        sut.makeBotMove();
    }

    function xtest_checkRowsForWinner() public {
//        sut.makePlayerXMove(0, 0, 'nonce');
//        sut.makePlayerXMove(0, 1, 'nonce');
//        sut.makePlayerXMove(0, 2, 'nonce');
//
//        bool actual = sut._checkBoardForWinner();
//        assertTrue(actual);
    }

    function xtest_checkColumnsForWinner() public {
//        sut.makePlayerXMove(0, 1, 'nonce');
//        sut.makePlayerXMove(1, 1, 'nonce');
//        sut.makePlayerXMove(2, 1, 'nonce');
//
//        bool actual = sut._checkBoardForWinner();
//        assertTrue(actual);
    }
}
