// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin-contracts-5.0.2/utils/Strings.sol";
import {Test, console} from "forge-std/Test.sol";
import {GameEvent} from "./GameEvent.sol";


contract TicTacToe is GameEvent {
    address owner;
    uint8[3][3] public gameBoard;
    string public nonce = 'default';
    uint8[2] playersLastMove;
    uint8 constant BOT = 0;
    uint8 constant PLAYER = 1;
    uint8 public moveCounter = 0;

    struct Winner {
        uint player;
        uint8[2][3] positions;
    }

    Winner public winner;

    constructor() {
        owner = msg.sender;
        initGameBoard();
    }

    function initGameBoard() public {
        gameBoard = [[10, 10, 10], [10, 10, 10], [10, 10, 10]];
        emitGameEvent("new game board created");
    }

    function makePlayerXMove(uint8 _x, uint8 _y, string calldata _nonce) public {
//        require(nonce != null, "nonce value is required");
        nonce = _nonce;
        moveCounter++;
        playersLastMove[0] = _x;
        playersLastMove[1] = _y;
        gameBoard[_x][_y] = PLAYER;

        emitMoveMadeEvent(_x, _y, PLAYER);

        makeBotMove();

        bool isWinner = _checkBoardForWinner();

        if(isWinner){
            //emit winner event
        }
    }


    function makeBotMove() public {
        (uint8 botPosX, uint8 botPosY) = _generateRandomXYPoint();
        bool isMoveLegal = false;
        while (!isMoveLegal) {
            isMoveLegal = isPlannedMoveLegal(botPosX, botPosY);
            botPosX = botPosX++ % 3;
            botPosY = botPosY++ % 3;
        }
        gameBoard[botPosX][botPosY] = BOT;

//        string memory botX = Strings.toString(botPosX);
//        string memory botY = Strings.toString(botPosY);
//        string memory message = string.concat("Bot moved to", " ", botX, ", ", botY);
//        emitGameEvent(message);

        emitMoveMadeEvent(botPosX, botPosY, BOT);
    }

    function _checkBoardForWinner() public returns (bool){
//        require(moveCounter >= 3, "too few moves to win game");

        if (_findColumnWinner()) return true;
        if (_findRowWinner()) return true;
        if (_findDiagonalWinner()) return true;

        return false;
    }

    function _findDiagonalWinner() public returns (bool)  {
        uint8 a = gameBoard[0][0];
        uint8 b = gameBoard[1][1];
        uint8 c = gameBoard[2][2];

        if (a != 10) {
            if (a == b && a == c) {
                winner.player = a;
                winner.positions[0] = [0, 0];
                winner.positions[1] = [1, 1];
                winner.positions[2] = [2, 2];

                return true;
            }
        }

        uint8 aa = gameBoard[0][2];
        uint8 bb = gameBoard[1][1];
        uint8 cc = gameBoard[2][0];

        if (aa != 10) {
            if (aa == bb && aa == cc) {
                winner.player = a;
                winner.positions[0] = [0, 2];
                winner.positions[1] = [1, 1];
                winner.positions[2] = [2, 0];

                return true;
            }
        }

        return false;
    }

    function _findColumnWinner() internal returns (bool){
        for (uint8 col = 0; col < gameBoard.length; col++) {
            uint8 a = gameBoard[0][col];
            uint8 b = gameBoard[1][col];
            uint8 c = gameBoard[2][col];

            if (a == 10) continue;

            if (a == b && b == c) {
                winner.player = a;
                winner.positions[0] = [0, col];
                winner.positions[1] = [1, col];
                winner.positions[2] = [2, col];

                return true;
            }
        }

        return false;
    }

    function _findRowWinner() internal returns (bool){
        for (uint8 row = 0; row < gameBoard.length; row++) {
            uint8 a = gameBoard[row][0];
            uint8 b = gameBoard[row][1];
            uint8 c = gameBoard[row][2];

            if (a == 10) continue;

            if (a == b && b == c) {
                winner.player = a;
                winner.positions[0] = [row, 0];
                winner.positions[1] = [row, 1];
                winner.positions[2] = [row, 2];

                return true;
            }
        }

        return false;
    }

    function _generateRandomXYPoint() internal returns (uint8, uint8) {
        uint randomnumber = uint(keccak256(abi.encodePacked(msg.sender, nonce)));
        randomnumber = (randomnumber % 900) + 100;
        uint8 playerPosX = uint8(randomnumber) % 3;
        uint playerPosY = (randomnumber % 3);

        return (playerPosX, uint8(playerPosY));
    }

    function isPlannedMoveLegal(uint8 _x, uint8 _y) public returns (bool) {
        for (uint8 row = 0; row < gameBoard.length; row++) {
            for (uint col = 0; col < gameBoard.length; col++) {
                if (row == _x && col == _y) {
                    return gameBoard[row][col] == 10;
                }
            }
        }
        return false;
    }


    function _convertMarkToXorY(uint8 mark) public returns (string memory) {
        if (mark == 0) return "y";

        return "x";
    }
}
