import React, {useCallback, useEffect, useMemo, useState} from 'react';
import './GameBoard.css'
import * as sol from './solidity-utils'
import {makePlayerMove} from "./solidity-utils";

export const GameBoard = ({contract, provider, signer}: any) => {
    const EMPTY_SQUARE = 10;
    const USER = 'X';
    const BOT = 'O';
    const DISPLAY_PLAYER: any = {0: BOT, 1: USER, 10: '--'};
    const [board, setBoard] = useState(new Array(9).fill(EMPTY_SQUARE));

    const tableClickHandler = (evt: any) => {
        const position: number = evt.target.id;
        board[position] = 1;
        setBoard([...board]);
        const nonce = Math.floor(Math.random() * Number.MAX_SAFE_INTEGER)
        sol.makePlayerMove(position, String(nonce))

    }

    const createTicTacToeTable = () => {
        let table = []
        let children = []
        for (let i = 0; i < board.length; i++) {
            const square = board[i];
            children.push(<td key={i} id={String(i)}>{DISPLAY_PLAYER[square]}</td>)

            if (children.length === 3) {
                table.push(<tr key={i}>{children}</tr>);
                children = [];
            }
        }
        return table;
    }

    const onAllContractEvents = useCallback(() => {
       return contract.on('*', (event: any) => {
            console.log('%c...sol-event', 'color:gold', event)
        })
    }, []);


    useEffect(() => {
        if (!contract) return;
console.log('effect')
        contract.initGameBoard();
        onAllContractEvents();

    }, [contract]);

    return (<div id={'gameBoard'}>
        <table onClick={tableClickHandler}>
            <tbody>
            {createTicTacToeTable()}
            </tbody>
        </table>
    </div>)
}
