const { ethers, upgrades } = require('hardhat')

async function main() {
  const RedStarEnergy = await ethers.getContractFactory('RedStarEnergy')

  const redStarEnergy = await upgrades.deployProxy(RedStarEnergy, [
    '0x08e0948E952063a6396a24fc59554aC476bEa66e',
    '0x4300000000000000000000000000000000000002',
  ])
  await redStarEnergy.waitForDeployment()

  console.log('drop redStarEnergy to:', await redStarEnergy.getAddress())
}

main()
