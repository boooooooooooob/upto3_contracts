const { ethers, upgrades } = require('hardhat')

async function main() {
  const contractFactory = await ethers.getContractFactory(
    'EventVotingController'
  )

  const contract = await upgrades.upgradeProxy(
    '0x35d147377D2e5921CaA5b910c33B99c893C84Ee4',
    contractFactory
  )

  console.log('contract upgraded')
}

main()
