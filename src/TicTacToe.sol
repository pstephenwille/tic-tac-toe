
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin-contracts-5.0.2/utils/Strings.sol";
import "@openzeppelin-contracts-5.0.2/token/ERC20/ERC20.sol";
import {Test, console} from "forge-std/Test.sol";
import {GameEvent} from "./GameEvent.sol";


contract TicTacToe is GameEvent, ERC20 {
    address  payable public owner;
    uint256 public gamePurse = 0;
    uint8[9] public gameBoard;
    string public nonce;
    uint8 constant BOT = 0;
    uint8 constant PLAYER = 1;
    uint8 constant EMPTY_SPACE = 10;
    uint8 public playerMoveCounter = 0;

    struct Winner {
        address payable playerAddress;
        uint8 playerMark;
        uint8[3] positions;
    }

    Winner public winner;

    constructor()  ERC20("TicTacToe", "TTT") payable {
        owner = payable(msg.sender);
    }

    function mint() public {
        gamePurse++;
        _mint(owner, gamePurse);
    }

    function initGameBoard() external {
        gameBoard = [EMPTY_SPACE, EMPTY_SPACE, EMPTY_SPACE,
                    EMPTY_SPACE, EMPTY_SPACE, EMPTY_SPACE,
                    EMPTY_SPACE, EMPTY_SPACE, EMPTY_SPACE];
        mint();
        winner.playerAddress = payable(msg.sender);
        emitGameEvent("new game board created", gameBoard);
    }

    function _setupGameBoard(uint8[9] memory _gameBoard) public {
        gameBoard = _gameBoard;
    }

    function makePlayerMove(uint8 _pos, string calldata _nonce) external {
        require(keccak256(abi.encodePacked(_nonce)) != keccak256(abi.encodePacked("")), "nonce value is required");
        require(_isMoveLegal(_pos), string.concat("move not allowed at ", Strings.toString(_pos)));
        nonce = _nonce;
        playerMoveCounter++;


    }

    function _orchestrateGame(uint8 _pos) public {
        gameBoard[_pos] = PLAYER;

        _makeBotMove();

        _checkIfGameIsOver();

        if (winner.playerMark == PLAYER) {
            _transferWinningsToPlayer();
        }
    }

    function _transferWinningsToPlayer() public {
//        (bool sent, bytes memory data) = payable(msg.sender).call{value: 1}("");
        (bool sent, bytes memory data) = winner.playerAddress.call{value: 1 ether}("");
//        emit WinningsTransferedEvent(sent, gamePurse);
    }

    function _checkIfGameIsOver() public {
        bool winnerFound = _checkBoardForWinner();
        if (winnerFound) {
            emitGameOverEvent(winner.playerMark, winner.positions, gameBoard);
        } else {
            bool isDraw = _gameIsADraw();
            if (isDraw) {
                emitDrawGameEvent(gameBoard);
            }
        }
    }

    function _makeBotMove() public {
        uint8 botPos = _generateRandomXYPoint();
        bool moveIsLegal = _isMoveLegal(botPos);
        while (!moveIsLegal) {
            botPos++;
            moveIsLegal = _isMoveLegal(botPos);
        }
        gameBoard[botPos] = BOT;

        emitMoveMadeEvent(botPos, BOT, gameBoard);
    }

    function _checkBoardForWinner() public returns (bool){
        if (playerMoveCounter < 3) return false;

        if (_findColumnWinner()) return true;
        if (_findRowWinner()) return true;
        if (_findDiagonalWinner()) return true;

        return false;
    }

    function _gameIsADraw() public returns (bool){
        if (playerMoveCounter < 3) return false;

        for (uint8 i = 0; i < gameBoard.length; i++) {
            if (gameBoard[i] == EMPTY_SPACE) return false;
        }

        return true;
    }

    function _findDiagonalWinner() public returns (bool)  {
        //0,4,8; 2,4,6
        if (gameBoard[4] == EMPTY_SPACE) return false;

        if (gameBoard[4] == gameBoard[0] && gameBoard[4] == gameBoard[8]) {
            winner.playerMark = gameBoard[4];
            winner.positions[0] = gameBoard[0];
            winner.positions[1] = gameBoard[4];
            winner.positions[2] = gameBoard[8];

            return true;
        }
        if (gameBoard[4] == gameBoard[2] && gameBoard[4] == gameBoard[6]) {
            winner.playerMark = gameBoard[4];
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
                winner.playerMark = gameBoard[col];
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

                winner.playerMark = gameBoard[row];
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
    receive() external payable{
        console.log(msg.sender, msg.value);
    }
    fallback() external payable {}
}
