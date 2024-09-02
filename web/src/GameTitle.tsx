import React from 'react';

export const GameTitle = () => {
    return (<div id={'gameTitle'}>
        <h1>Tic Tac Toe in Solidity</h1>
        <p>This game is written in Solidity and ran on the Ethereum block chain</p>
        <p>You are 'X' and can make the first move by clicking a square. The move is sent to the Solidity contract to
            execute which then makes it's own random move for 'O', and the board is updated.</p>
    </div>)
}
