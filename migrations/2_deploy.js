// const UzairCoin = artifacts.require("UzairCoin");
const DEX = artifacts.require("DEX");

module.exports = async function (deployer, network, accounts) {
  // Deploy MyToken
//   await deployer.deploy(UzairCoin)
//   const myToken = await UzairCoin.deployed();
//   ///Deploy Pool Token
  await deployer.deploy(DEX);
  const dex = await DEX.deployed();
}