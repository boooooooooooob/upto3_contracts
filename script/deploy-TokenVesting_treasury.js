const hre = require('hardhat')

async function main() {
  const tokenVesting = await hre.ethers.deployContract('TokenVesting', [
    '0xD0CB60183Fd036E8a67be4ebDAB5BD9434C873e7',
    1714176000,
    93312000,
  ])

  await tokenVesting.waitForDeployment()

  console.log(`Deployed to ${tokenVesting.target}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
