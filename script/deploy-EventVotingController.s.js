const { ethers, upgrades } = require('hardhat')

async function main() {
  const contractFactory = await ethers.getContractFactory(
    'EventVotingController'
  )

  const contract = await upgrades.deployProxy(contractFactory, [
    '0x8bc67D8BF0dBB3Dcd0d7dF0Aff55f2c3D661d2f6',
    '0xB05a3b113957757BD03E3ba35C1D242861199194',
    '0x08e0948E952063a6396a24fc59554aC476bEa66e',
    '0x4300000000000000000000000000000000000002',
  ])
  await contract.waitForDeployment()

  console.log('deploy contract to:', await contract.getAddress())
}

main()
