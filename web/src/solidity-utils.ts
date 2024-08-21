import {BrowserProvider, Contract, ethers, JsonRpcSigner} from "ethers";
import TIC_TAC_TOE_ABI from "./ttt.abi.json";
import React, {useEffect, useState} from 'react';
import {sign} from "node:crypto";

const CONTRACT_ADDRESS = '0x5FbDB2315678afecb367f032d93F642f64180aa3';

export default () => {
}

interface Sol {
    contract: Contract | null;
    provider: BrowserProvider | null;
    signer: JsonRpcSigner | null;
}
let sol:Sol = {contract:null, provider:null, signer:null}

export const getSolidityContract = async () => {
    if (sol && sol.provider && sol.signer && sol.contract) return sol;

    sol.provider = await new ethers.BrowserProvider(window.ethereum);
    sol.signer = await sol.provider.getSigner();
    sol.contract = await new ethers.Contract(CONTRACT_ADDRESS, TIC_TAC_TOE_ABI, sol.signer);
    // const sym = await sol.contract.symbol();
    // const mint = await sol.contract.mint();
    // console.log('sum ', sym);
    // await mint.wait();

    // const foo2 = await contract.getFunction('mint').call(null);
    // const foo3 = await contract.getFunction('totalSupply').call(null);
    //     console.log('%c...event', 'color:gold', event);
    // })

    return sol;
}

export const makePlayerMove = async (position:number, nonce:string) => {
    const sol = await getSolidityContract();
    const resp = await sol.contract!.makePlayerMove(Number(position), nonce);
    // const resp = await sol.contract!.mint();

    console.log('resp ', resp);
}

