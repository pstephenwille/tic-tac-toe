// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract GameEvent {
    string internal lastEventMessage;

    event GameStateEvent(string message);


    function emitGameEvent(string memory _message) public {
        lastEventMessage = _message;
        emit GameStateEvent(_message);
    }
}
