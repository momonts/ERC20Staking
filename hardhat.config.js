require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({path: ".env"});
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  networks: {
    core_testnet: {
      url: "https://rpc.test2.btcs.network",
      accounts: [process.env.PRIVATE_KEY],
      chainId: 1114
  }
}};
