## Upto3

### Sepolia contract addresses

|  contract | address |   |   |   |
|---|---|---|---|---|
| Event Voting NFT | 0xc8E94a05fE0F93f247290dc10D2593e12622CE59 |   |   |   |
| Event Voting NFT Proxy  | 0x37ab95a25A548042b106358b14d1b11dd61c7AFd |   |   |   |
|   |   |   |   |   |

### Deploy and Verify contracts on Sepolia

```bash
export PRIVATE_KEY=0x...
export ETHERSCAN_API_KEY=...
```

- Event Voting NFT

```bash
forge script script/DeployEventVotingNFT.s.sol --rpc-url sepolia --private-key $PRIVATE_KEY --broadcast --etherscan-api-key $ETHERSCAN_API_KEY --verify
```

- Event Voting NFT Proxy

```bash
forge script script/deployProxy.s.sol:DeployUUPSProxy --rpc-url sepolia --private-key $PRIVATE_KEY --broadcast --etherscan-api-key $ETHERSCAN_API_KEY --verify
```