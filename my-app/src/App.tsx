import React, {useEffect, useState} from 'react';
import './App.css';
import Web3 from "web3";
// import UzairCoin from "./abi/UzairCoin.json";
import DEX from "./abi/DEX.json";

const web3 = new Web3(Web3.givenProvider);

declare global {
  interface Window {
      ethereum: any;
      web3: any;
  }
}

function App() {

  const [loading, setLoading] = useState<Boolean>(false);
  const [account, setAccount] = useState("");
  const [dexAdress, setDEXAdress] = useState<any>();
  const [uzairCoinBalance, setUzairCoinBalance] = useState<any>(0);
  const [dex, setDEX] = useState<any>({});

  console.log("dexAdress ", dexAdress);

  useEffect(() => {
    (async() => {
      await initialize();
    })();
  }, []);

  const initialize = async () => {
    if(Web3.givenProvider){
      const addresses = await web3.eth.getAccounts();
      if(addresses.length > 0){
        setAccount(addresses[0]);
        const UzairNetworkData = DEX.networks["5777"];
        if(UzairNetworkData) {
          const dexToken: any = new web3.eth.Contract(DEX.abi as any, UzairNetworkData.address);
          setDEX(dexToken);
          const DEXAdress = await dexToken?.methods.token().call();
          setDEXAdress(DEXAdress);
          const ubalance = await dexToken?.methods.balanceOf().call();
          console.log("ubalance ", ubalance);
        } else {
          window.alert('Marketplace contract not deployed to detected network.')
        }
      }
    }
  }

  // const checkBalance = async () => {
  //   const ubalance = await uzairCoin?.methods.balanceOf(account).call();
  //   setUzairCoinBalance(ubalance);
  // }

  const getAccount = async () => {
    setLoading(true);
    try{
      if(typeof window !== undefined){
        const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
        const account = accounts[0];
        setAccount(account);
        const UzairNetworkData = DEX.networks["5777"];
        if(UzairNetworkData) {
          const dexToken: any = new web3.eth.Contract(DEX.abi as any, UzairNetworkData.address);
          setDEX(dexToken);
          const DEXAdress = await dexToken?.methods.token().call();
          setDEXAdress(DEXAdress);
          const ubalance = await dexToken?.methods.balanceOf().call();
          console.log("ubalance ", ubalance);
        }
      }
      setLoading(false);
    }
    catch(err){
      setLoading(false);
    }
  }

  const buy = async () => {
    setLoading(true);
    const sended = await dex.methods.buy().send({ from: account, value: web3.utils.toWei("1",'ether')});
    console.log("sended ", sended)
    // await checkBalance();
    setLoading(false);
  }

  const sell = async () => {
    setLoading(true);
    const amount = web3.utils.toWei("1", "ether");
    console.log("amount", amount)
    const sended = await dex.methods.sell(amount).send({ from: account });
    console.log("sended ", sended)
    // await checkBalance();
    setLoading(false);
  }


  return (
    <div className="App">
      {
        account
        ?
        <>
          <h3>Connected Account : {account}</h3>
          <h3>BALANCE : {uzairCoinBalance} UZC</h3>
          <br/>
          <br/>
          <br/>
          <br/>
          <h5>1 Ether = 1 UZC</h5>
          
          {!loading && <button onClick={buy}>Buy UZC Token</button>}
          {!loading && <button onClick={sell}>Sell UZC Token</button>}
        </>
        :
          loading
          ?
          <button className="enableEthereumButton" disabled={true}>loading ....</button>
          :
          <button className="enableEthereumButton" onClick={getAccount}>Connect Wallet</button>

      }
    </div>
  );
}

export default App;
