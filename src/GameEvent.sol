// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin-contracts-5.0.2/utils/Strings.sol";

contract GameEvent {
    string internal lastEventMessage;

    event GameStateEvent(string message);
    event MoveMadeEvent(string message);

    function emitGameEvent(string memory _message) public {
        lastEventMessage = _message;
        emit GameStateEvent(_message);
    }

    function emitMoveMadeEvent(uint8 _x, uint8 _y, uint8 _player) public {
        string memory positionX = Strings.toString(_x);
        string memory positionY = Strings.toString(_y);
        string memory player = _player == 0 ? 'BOT' : 'X';
        string memory playerMovedToXYMessage = string.concat(player, " moved to ", positionX, ", ", positionY);

        emit MoveMadeEvent(playerMovedToXYMessage);
    }
}
