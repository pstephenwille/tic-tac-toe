// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TicTacToe} from "../src/TicTacToe.sol";

contract TicTacToeTest is Test {
    TicTacToe public sut;

    event GameStateEvent(string message);

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
        emit GameStateEvent("x moved to 1, 1");
        sut.makePlayerXMove(1, 1, 'xxx');
        uint8 x = sut.gameBoard(1, 1);
        assertEq(x, 1);
    }

    function xtest_botMoves() public {
    }

    function test_coords() public {
        sut.makeBotMove();

    }
}
