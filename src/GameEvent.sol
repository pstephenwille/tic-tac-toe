// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin-contracts-5.0.2/utils/Strings.sol";

import {Test, console} from "forge-std/Test.sol";

contract GameEvent {
    event GameStateEvent(string message, uint8[9] board);
    event MoveMadeEvent(string message, uint8[9] board);
    event GameOverEvent(string message, uint8[3] positions, uint8[9] board);
    event DrawGameEvent(string message, uint8[9] board);
    event WinningsTransferedEvent(bool message, uint gamePurse);

    function convertToPlayerMark(uint8 _player) public returns (string memory){
        return _player == 0 ? 'BOT' : 'X';
    }

    function emitGameOverEvent(uint8 _player, uint8[3] memory positions, uint8[9] memory board) public {
        string memory player = convertToPlayerMark(_player);

        emit GameOverEvent(string.concat(player, " won!"), positions, board);
    }

    function emitDrawGameEvent(uint8[9] memory board) public {
        emit DrawGameEvent("Game is a draw", board);
    }

    function emitGameEvent(string memory _message, uint8[9] memory gameBoard) public {
        emit GameStateEvent(_message, gameBoard);
    }

    function emitMoveMadeEvent(uint8 _pos, uint8 _player, uint8[9] memory gameBoard) public {
        string memory player = convertToPlayerMark(_player);
        string memory playerMovedToXMessage = string.concat(player, " moved to: ", Strings.toString(_pos));

        emit MoveMadeEvent(playerMovedToXMessage, gameBoard);
    }

}
