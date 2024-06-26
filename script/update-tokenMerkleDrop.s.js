const { ethers, upgrades } = require('hardhat')

async function main() {
  const contractFactory = await ethers.getContractFactory('UPTMerkleDrop')

  const contract = await upgrades.upgradeProxy(
    // '0x562d60dA90925Ea3d69Dae1A6A55D440fc144354',
    '0x07a9dA97DbBBB57F83C7c1390dafa13fdB20Ce5e',
    contractFactory
  )

  console.log('contract upgraded')
}

main()
