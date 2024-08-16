// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Test, console} from "forge-std/Test.sol";

contract TicTacToe {
    uint256 public number;

    uint8[3] public foo = [1,2,3];
    uint8[3][3] public gameBoard;

    function initGameBoard() public {
        gameBoard = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
        console.log('foo');
        for(uint8 i =0; i<gameBoard.length; i++){
            console.log('foo');
            for(uint8 j=0; j<gameBoard[i].length; j++){
                console.log('board ', gameBoard[i][j]);
            }
        }
    }

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }

}
