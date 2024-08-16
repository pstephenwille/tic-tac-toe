// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TicTacToe} from "../src/TicTacToe.sol";

contract TicTacToeScript is Script {
    TicTacToe public sut;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        sut = new TicTacToe();

        vm.stopBroadcast();
    }
}
