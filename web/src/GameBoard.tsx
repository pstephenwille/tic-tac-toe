import React, {useCallback, useEffect, useMemo, useState} from 'react';
import './GameBoard.css'
import * as sol from './solidity-utils'

export const GameBoard = ({contract, provider, signer}: any) => {
    const EMPTY_SQUARE = 10;
    const USER = 'X';
    const BOT = 'O';
    const DISPLAY_PLAYER: any = {0: BOT, 1: USER, 10: ' '};
    const [board, setBoard] = useState(new Array(9).fill(EMPTY_SQUARE));
    const [spinnerSquareIdToggle, setSpinnerSquareIdToggle] = useState(-1)

    const tableClickHandler = (evt: any) => {
        const squareNumber: number = Number(evt.target.id);
        setSpinnerSquareIdToggle(squareNumber);
        const nonce = Math.floor(Math.random() * Number.MAX_SAFE_INTEGER)
        sol.makePlayerMove(squareNumber, String(nonce))

    }

    const createTicTacToeTable = () => {
        let table = []
        let children = []
        for (let i = 0; i < board.length; i++) {
            const square = board[i];
            const td = (
                <td key={i} id={String(i)}>
                    {(spinnerSquareIdToggle === i)
                        ? <div id={`spinner-${i}`} className="loading-circle">
                            <div></div>
                        </div>
                        : <>{DISPLAY_PLAYER[square]}</>
                    }
                </td>)
            children.push(td);

            if (children.length === 3) {
                table.push(<tr key={i}>{children}</tr>);
                children = [];
            }
        }
        return table;
    }

    const gameStateEvent: sol.GameEventHandlers = {
        GameStateEvent: (event: any) => {
            console.log('game-state', event);
            const freshBoard = event.args[1].map((n: BigInt) => Number(n));
            setBoard(freshBoard);
        },
        MoveMadeEvent: (event: any) => {
            console.log('move-made', event);
            const freshBoard = event.args[1].map((n: BigInt) => Number(n));
            setBoard(freshBoard);
            setSpinnerSquareIdToggle(-1);
        },
        GameOverEvent: (event: any) => {
            console.log('%c...game-over', 'color:gold', event);
        },
        DrawGameEvent: (event: any) => {
            console.log('%c...draw-game', 'color:gold', event);
        }
    }

    const onAllContractEvents = useCallback(() => {
        contract.on('*', (event: any) => {
            console.log('event', event)
            const key = event.fragment.name as sol.HandlerKeys;
            gameStateEvent[key](event);
        }).catch((error: any) => {
            console.log(error);
        })
    }, []);


    useEffect(() => {
        onAllContractEvents();


        return () => {
            contract.removeAllListeners();
        }
    }, []);

    return (<div id={'gameBoard'}>
        <table onClick={tableClickHandler}>
            <tbody>
            {createTicTacToeTable()}
            </tbody>
        </table>
    </div>)
}
