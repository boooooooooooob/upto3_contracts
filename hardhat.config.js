require('@nomicfoundation/hardhat-toolbox')
require('@nomicfoundation/hardhat-foundry')
require('@openzeppelin/hardhat-upgrades')

require('dotenv').config()

const ANKR_API_KEY = process.env.ANKR_API_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY
const BLAST_API_KEY = process.env.BLAST_API_KEY

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: '0.8.20',
  networks: {
    blast: {
      url: `https://rpc.ankr.com/blast/${ANKR_API_KEY}`,
      accounts: [PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      blast: BLAST_API_KEY,
    },
    customChains: [
      {
        network: 'blast',
        chainId: 81457,
        urls: {
          apiURL: 'https://api.blastscan.io/api',
          browserURL: 'https://blastscan.io',
        },
      },
    ],
  },
}
