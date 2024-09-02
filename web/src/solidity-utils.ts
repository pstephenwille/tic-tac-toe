import {BrowserProvider, Contract, ethers, JsonRpcSigner} from "ethers";
import TIC_TAC_TOE_ABI from "./ttt.abi.json";

const CONTRACT_ADDRESS = '0x5FbDB2315678afecb367f032d93F642f64180aa3';


export interface GameEventHandlers {
    MoveMadeEvent: (event: any) => void,
    GameStateEvent: (event: any) => void
    GameOverEvent: (event: any) => void
    DrawGameEvent: (event: any) => void
}

export type HandlerKeys = keyof GameEventHandlers;

interface Sol {
    contract: Contract | null;
    provider: BrowserProvider | null;
    signer: JsonRpcSigner | null;
}

let sol: Sol = {contract: null, provider: null, signer: null}

export const getSolidityContract = async () => {
    if (sol && sol.provider && sol.signer && sol.contract) return sol;

    sol.provider = await new ethers.BrowserProvider(window.ethereum);
    sol.signer = await sol.provider.getSigner();
    sol.contract = await new ethers.Contract(CONTRACT_ADDRESS, TIC_TAC_TOE_ABI, sol.signer);


    return sol;
}

export const makePlayerMove = async (position: number, nonce: string) => {
    const sol = await getSolidityContract();
    const resp = await sol.contract!.makePlayerMove(Number(position), nonce);
    // const resp = await sol.contract!.mint();

    console.log('resp ', resp);
}

