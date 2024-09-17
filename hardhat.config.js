require('@nomicfoundation/hardhat-toolbox');
require("dotenv").config();

module.exports = {
  solidity: "0.8.9",
  networks: {
    blastSepolia: {
      url: process.env.BLAST_SEPOLIA_RPC_URL, 
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
