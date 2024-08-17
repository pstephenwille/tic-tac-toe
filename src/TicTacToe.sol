// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin-contracts-5.0.2/utils/Strings.sol";
import {Test, console} from "forge-std/Test.sol";
import {GameEvent} from "./GameEvent.sol";


contract TicTacToe is GameEvent {
    address owner;
    uint8[3][3] public gameBoard;

    constructor() {
        owner = msg.sender;
        initGameBoard();
    }

    function initGameBoard() public {
        gameBoard = [[10, 10, 10], [10, 10, 10], [10, 10, 10]];
//        emit GameStateEvent("new game board created");
        emitGameEvent("new game board created");
    }

    function makeMove(uint8 _x, uint8 _y, uint8 _mark) public {
        gameBoard[_x][_y] = _mark;
        string memory player = _convertMarkToXorY(_mark);
        string memory positionX = Strings.toString(_x);
        string memory positionY = Strings.toString(_y);
        string memory playerMovedToXYMessage = string.concat(player, " moved to ", positionX, ", ", positionY);

        emitGameEvent(playerMovedToXYMessage);
    }

    function makeBotMove() public {
        uint randy = _random();
    }

    function _random() internal returns (uint) {
        uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, lastEventMessage)));
        randomnumber = (randomnumber & 900) + 100;

        return randomnumber;
    }

    function makeCoordinate(uint num) public returns (uint) {
        uint coord = (num <= 300) ? 0 : num;
        coord = (num > 300) ? 1 : num;
        coord = (num > 600) ? 2 : coord;

        return coord;
    }

    function _convertMarkToXorY(uint8 mark) public returns (string memory) {
        if (mark == 0) return "y";

        return "x";
    }
}
