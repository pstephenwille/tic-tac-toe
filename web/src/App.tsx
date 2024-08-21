import React, {useEffect, useState} from 'react';
import logo from './logo.svg';
import './App.css';
import {BrowserProvider, Contract, ethers, JsonRpcSigner} from "ethers";
import TIC_TAC_TOE_ABI from './ttt.abi.json';
import {GameBoard} from "./GameBoard";
import {GameTitle} from "./GameTitle";
import * as sol from './solidity-utils';

const CONTRACT_ADDRESS = '0x5FbDB2315678afecb367f032d93F642f64180aa3';

declare global {
    interface Window {
        ethereum: any;
    }
}

function App() {
    const [contract, setContract] = useState<Contract | null>(null);
    const [provider, setProvider] = useState<BrowserProvider | null>(null);
    const [signer, setSigner] = useState<JsonRpcSigner | null>(null)

    useEffect(() => {
        if (window.ethereum) {
            setProvider(new ethers.BrowserProvider(window.ethereum));
        } else {
            console.error("Please install MetaMask!");
        }
    }, []);


    useEffect(() => {
        sol.getSolidityContract().then(solidity => {
            setContract(solidity.contract);
            setSigner(solidity.signer);
        });
    }, [provider]);

    return (
        <div className="App">
            <header className="App-header">
                <img src={logo} className="App-logo" alt="logo"/>
                <a
                    className="App-link"
                    href="https://reactjs.org"
                    target="_blank"
                    rel="noopener noreferrer"
                >
                    Learn React
                </a>
            </header>
            <div id={'game'}>
                {contract
                    ? <>
                        <GameTitle/>
                        <GameBoard contract={contract} provider={provider} signer={signer} />
                    </>
                    : ''
                }
            </div>

        </div>
    );
}

export default App;
