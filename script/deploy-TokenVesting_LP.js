const hre = require('hardhat')

async function main() {
  const tokenVesting = await hre.ethers.deployContract('TokenVesting', [
    '0x80F61A12f8627ebdB983a371B0cFF15700F28Dbf',
    1714176000,
    15552000,
  ])

  await tokenVesting.waitForDeployment()

  console.log(`Deployed to ${tokenVesting.target}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
