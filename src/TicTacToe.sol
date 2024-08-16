// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Test, console} from "forge-std/Test.sol";

contract TicTacToe {
    uint256 public number;

    uint8[][] public gameBoard;

    function initGameBoard() public {
        gameBoard = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
        console.log('foo');
    }

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }

}
