const hre = require('hardhat')

async function main() {
  const drop = await hre.ethers.deployContract('UPTMerkleDrop', [
    '0x08e0948E952063a6396a24fc59554aC476bEa66e',
    '0x333f50702DFB7FC32CFccEA9F587326D27c6E214',
  ])

  await drop.waitForDeployment()

  console.log(`Deployed to ${drop.target}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
