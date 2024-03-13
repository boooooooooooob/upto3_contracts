const hre = require('hardhat')

async function main() {
  const nft = await hre.ethers.deployContract('PassCardNFT')

  await nft.waitForDeployment()

  console.log(`Deployed to ${nft.target}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
