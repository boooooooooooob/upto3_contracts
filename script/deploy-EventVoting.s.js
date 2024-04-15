const { ethers, upgrades } = require('hardhat')

async function main() {
  const contractFactory = await ethers.getContractFactory('EventVotingNFT')

  const contract = await upgrades.deployProxy(contractFactory, [
    '0x4300000000000000000000000000000000000002',
  ])
  await contract.waitForDeployment()

  console.log('deploy contract to:', await contract.getAddress())
}

main()
