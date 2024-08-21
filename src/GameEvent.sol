// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin-contracts-5.0.2/utils/Strings.sol";

import {Test, console} from "forge-std/Test.sol";

contract GameEvent {
    string internal lastEventMessage;

    event GameStateEvent(string message);
    event MoveMadeEvent(string message);
    event GameOverEvent(string message);

    function emitGameOverEvent(bool _isWinner, uint8 _player, uint8[2][3] memory _positions) public {
        string memory player = _player == 0 ? 'BOT' : 'X';
        string memory positions = 'positions: ';
        for (uint8 i = 0; i < _positions.length; i++) {
            string.concat(positions, '[');
            uint8 posX = _positions[i][0];
            uint8 posY = _positions[i][1];
            positions = string.concat(Strings.toString(posX), ',', Strings.toString(posY));
            string.concat(positions, ']');
        }
        string memory message = string.concat(player, " won with ", positions);
        emit GameOverEvent(message);
    }

    function emitGameEvent(string memory _message) public {
        lastEventMessage = _message;
        emit GameStateEvent(_message);
    }

    function emitMoveMadeEvent(uint8 _pos, uint8 _player, uint8[9] memory gameBoard) public {
        string memory player = _player == 0 ? 'BOT' : 'X';
        string memory board = "[";
        for (uint8 i = 0; i < gameBoard.length; i++) {
            if (i == gameBoard.length - 1) {
                board = string.concat(board, Strings.toString(gameBoard[i]), "]");
            } else {
                board = string.concat(board, Strings.toString(gameBoard[i]), ",");
            }
        }
        string memory playerMovedToXYMessage = string.concat(player, " moved to: ", Strings.toString(_pos), ". ", "Board state: ", board);

        emit MoveMadeEvent(playerMovedToXYMessage);
    }
}
