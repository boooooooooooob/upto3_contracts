const { ethers, upgrades } = require('hardhat')

async function main() {
  const contractFactory = await ethers.getContractFactory('EventVotingNFT')

  const contract = await upgrades.upgradeProxy(
    '0x8bc67D8BF0dBB3Dcd0d7dF0Aff55f2c3D661d2f6',
    contractFactory
  )

  console.log('contract upgraded')
}

main()
