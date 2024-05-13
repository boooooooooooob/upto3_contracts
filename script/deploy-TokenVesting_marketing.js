const hre = require('hardhat')

async function main() {
  const tokenVesting = await hre.ethers.deployContract('TokenVesting', [
    '0x1890Fcd62bb87C7DE4a3235cfde0A983dAc5CEf2',
    1714176000,
    62208000,
  ])

  await tokenVesting.waitForDeployment()

  console.log(`Deployed to ${tokenVesting.target}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
