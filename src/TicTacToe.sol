// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin-contracts-5.0.2/utils/Strings.sol";
import {Test, console} from "forge-std/Test.sol";
import {GameEvent} from "./GameEvent.sol";


contract TicTacToe is GameEvent {
    address owner;
    uint8[3][3] public gameBoard;
    string public nonce = 'nnnonce';

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
        gameBoard[_x][_y] = 1;
        string memory positionX = Strings.toString(_x);
        string memory positionY = Strings.toString(_y);
        string memory playerMovedToXYMessage = string.concat("X moved to ", positionX, ", ", positionY);

        emitGameEvent(playerMovedToXYMessage);
        makeBotMove();
    }

//    function decodeData(bytes memory data) public pure returns (uint256, string memory) {
//        (uint256 number, string memory text) = abi.decode(data, (uint256, string));
//        return (number, text);
//    }

    function makeBotMove() public {
        uint randNum = _random();
//        uint8 n8 = uint8(randNum);
        bytes memory bytesNum;
        assembly {
            bytesNum := randNum
        }

        (uint256 number1) = abi.decode(bytesNum, (uint256));
    }


    function _random() internal returns (uint) {
        uint randomnumber = uint(keccak256(abi.encodePacked(msg.sender, nonce)));
        randomnumber = (randomnumber % 900) + 100;

        return randomnumber;
    }

    function makeCoordinate(uint num) public returns (uint) {
        uint coord = (num <= 300) ? 0 : num;
        coord = (num > 300 && num < 600) ? 1 : coord;
        coord = (num >= 600) ? 2 : coord;

        return coord;
    }

    function _convertMarkToXorY(uint8 mark) public returns (string memory) {
        if (mark == 0) return "y";

        return "x";
    }
}
