const { ethers, upgrades } = require('hardhat')

async function main() {
  const contractFactory = await ethers.getContractFactory('RedStarEnergy')

  const contract = await upgrades.upgradeProxy(
    '0xB05a3b113957757BD03E3ba35C1D242861199194',
    contractFactory
  )

  console.log('contract upgraded')
}

main()
