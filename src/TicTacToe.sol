// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin-contracts-5.0.2/utils/Strings.sol";
import "@openzeppelin-contracts-5.0.2/token/ERC20/ERC20.sol";
import {Test, console} from "forge-std/Test.sol";
import {GameEvent} from "./GameEvent.sol";
//import "../dependencies/@openzeppelin-contracts-5.0.2/token/ERC20/ERC20.sol";


contract TicTacToe is GameEvent, ERC20 {
    address owner;
    uint256 public gamePurse = 0;

    uint8[9] public gameBoard;
    string public nonce = 'default';
    uint8 playersLastMove;
    uint8 constant BOT = 0;
    uint8 constant PLAYER = 1;
    uint8 constant EMPTY_SPACE = 10;
    uint8 public moveCounter = 0;

    struct Winner {
        uint8 player;
        uint8[3] positions;
    }

    Winner public winner;

    constructor() ERC20("TicTacToe", "TTT"){
        owner = msg.sender;
    }

    function mint() external {
        gamePurse++;
        _mint(owner, gamePurse);
    }

    function initGameBoard() external {
        gameBoard = [EMPTY_SPACE, EMPTY_SPACE, EMPTY_SPACE,
                    EMPTY_SPACE, EMPTY_SPACE, EMPTY_SPACE,
                    EMPTY_SPACE, EMPTY_SPACE, EMPTY_SPACE];
        emitGameEvent("new game board created");
    }

    function makePlayerMove(uint8 _pos, string calldata _nonce) external {
//        require(nonce != null, "nonce value is required");
        require(_isMoveLegal(_pos), string.concat("move not allowed at " , Strings.toString(_pos)));
        nonce = _nonce;
        moveCounter++;
        playersLastMove = _pos;
        gameBoard[_pos] = PLAYER;
//        emitMoveMadeEvent(_pos, PLAYER);

        makeBotMove();

        bool winnerFound = _checkBoardForWinner();
        if (winnerFound) {
//            emitGameOverEvent(winnerFound, winner.player, winner.positions);
        }

        bool isDraw = _gameIsADraw();
        if(isDraw){
            //emitGameOverEvent()
        }

    }


    function makeBotMove() public {
        uint8 botPos = _generateRandomXYPoint();
        bool isMoveLegal = false;
        while (!isMoveLegal) {
            isMoveLegal = _isMoveLegal(botPos);
            botPos++;
        }
        gameBoard[botPos] = BOT;

        emitMoveMadeEvent(botPos, BOT, gameBoard);
    }

    function _checkBoardForWinner() public returns (bool){
//        require(moveCounter >= 3, "too few moves to win game");
        if (_findColumnWinner()) return true;
        if (_findRowWinner()) return true;
        if (_findDiagonalWinner()) return true;

        return false;
    }

    function _gameIsADraw() public returns(bool){
        for (uint8 i = 0; i < gameBoard.length; i++) {
            if (gameBoard[i] == EMPTY_SPACE) return false;
        }

        return true;
    }

    function _findDiagonalWinner() public returns (bool)  {
        //0,4,8; 2,4,6
        if (gameBoard[4] == EMPTY_SPACE) return false;

        if (gameBoard[4] == gameBoard[0] && gameBoard[4] == gameBoard[8]) {
            winner.player = gameBoard[4];
            winner.positions[0] = gameBoard[0];
            winner.positions[1] = gameBoard[4];
            winner.positions[2] = gameBoard[8];

            return true;
        }
        if (gameBoard[4] == gameBoard[2] && gameBoard[4] == gameBoard[6]) {
            winner.player = gameBoard[4];
            winner.positions[0] = gameBoard[2];
            winner.positions[1] = gameBoard[4];
            winner.positions[2] = gameBoard[6];

            return true;
        }

        return false;
    }

    function _findColumnWinner() public returns (bool){
        //1,4,7; 2,5,8; 3,6,9;
        //0,3,6; 1,4,7; 2,5,8;
        for (uint8 col = 0; col < 3; col++) {
            if (gameBoard[col] == EMPTY_SPACE) continue;

            if (gameBoard[col] == gameBoard[col + 3] &&
                gameBoard[col] == gameBoard[col + 6]) {
                winner.player = gameBoard[col];
                winner.positions[0] = col;
                winner.positions[0] = col + 3;
                winner.positions[0] = col + 6;

                return true;
            }
        }

        return false;
    }

    function _findRowWinner() public returns (bool){
        //0,1,2; 3,4,5;, 6,7,8;
        for (uint8 row = 0; row < 3; row++) {
            if (gameBoard[row] == EMPTY_SPACE) continue;
            if (gameBoard[row] == gameBoard[row + 1] &&
                gameBoard[row] == gameBoard[row + 2]) {

                winner.player = gameBoard[row];
                winner.positions[0] = gameBoard[row];
                winner.positions[1] = gameBoard[row + 1];
                winner.positions[2] = gameBoard[row + 2];

                return true;
            }

        }
        return false;
    }

    function _generateRandomXYPoint() public returns (uint8) {
        uint aNumber = uint(keccak256(abi.encodePacked(msg.sender, nonce)));
        aNumber = (aNumber % 900) + 100;
        uint8 pos = uint8(aNumber) % 9;

        return pos;
    }

    function _isMoveLegal(uint8 _pos) public returns (bool) {
        return gameBoard[_pos] == 10;
    }


    function _convertMarkToXorY(uint8 mark) public returns (string memory) {
        if (mark == 0) return "y";

        return "x";
    }


}
