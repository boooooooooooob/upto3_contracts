const hre = require('hardhat')

async function main() {
  const token = await hre.ethers.deployContract('UPTToken', [
    '100000000000000000000000000',
  ])

  await token.waitForDeployment()

  console.log(`Deployed to ${token.target}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
