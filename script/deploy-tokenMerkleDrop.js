const hre = require('hardhat')

async function main() {
  const Drop = await hre.ethers.getContractFactory('UPTMerkleDrop')

  const drop = await hre.upgrades.deployProxy(Drop, [
    '0x08e0948E952063a6396a24fc59554aC476bEa66e',
    '0x333f50702DFB7FC32CFccEA9F587326D27c6E214',
    '0x4300000000000000000000000000000000000002',
  ])
  await drop.waitForDeployment()

  console.log('drop deployed to:', await drop.getAddress())
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
