const hre = require('hardhat')

async function main() {
  const tokenVesting = await hre.ethers.deployContract('TokenVesting', [
    '0xb9bD713F4965428dF718e765d52f064bFDF43088',
    1729987200,
    62208000,
  ])

  await tokenVesting.waitForDeployment()

  console.log(`Deployed to ${tokenVesting.target}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
