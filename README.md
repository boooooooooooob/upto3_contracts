## Upto3

### Sepolia contract addresses

|  contract | address |   |   |   |
|---|---|---|---|---|
| Event Voting NFT | 0x8bc67D8BF0dBB3Dcd0d7dF0Aff55f2c3D661d2f6 |   |   |   |
| Event Voting NFT Proxy  | 0x1dB31D9b412Eba16D1fBF3E3Df0952202016589f |   |   |   |
| Event Voting Controller | 0x35d147377D2e5921CaA5b910c33B99c893C84Ee4 |   |   |   |
| Event Voting Controller Proxy | 0x868bf4e537112a196bdb9161a69779ACe0331dfE |   |   |   |

### Blast testnet contract addresses
|  contract | address |   |   |   |
|---|---|---|---|---|
| Event Voting NFT | 0x333f50702DFB7FC32CFccEA9F587326D27c6E214 |   |   |   |
| Event Voting NFT Proxy  | 0xc8E94a05fE0F93f247290dc10D2593e12622CE59 |   |   |   |
| Event Voting Controller | 0xFf073575A5c1A1F0EC0D9aE5f59DE4d8acecFC81 |   |   |   |
| Event Voting Controller Proxy | 0x7A2775A97BDE364D0B96B003e6dC344267344F3c |   |   |   |

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
forge script script/DeployEventVotingNFTProxy.s.sol:DeployUUPSProxy --rpc-url sepolia --private-key $PRIVATE_KEY --broadcast --etherscan-api-key $ETHERSCAN_API_KEY --verify
```

- Event Voting Controller NFT

```bash
forge script script/DeployEventVotingController.s.sol --rpc-url sepolia --private-key $PRIVATE_KEY --broadcast --etherscan-api-key $ETHERSCAN_API_KEY --verify
```

- Event Voting NFT Controller Proxy

```bash
forge script script/DeployEventVotingControllerProxy.s.sol:DeployUUPSProxy --rpc-url sepolia --private-key $PRIVATE_KEY --broadcast --etherscan-api-key $ETHERSCAN_API_KEY --verify
```

### Deploy and Verify contracts on Blast Testnet

```bash
export PRIVATE_KEY=0x...
export ETHERSCAN_API_KEY=...
```

- Event Voting NFT

```bash
forge script script/DeployEventVotingNFT.s.sol --rpc-url blast_testnet --private-key $PRIVATE_KEY --broadcast --verifier-url 'https://api.routescan.io/v2/network/testnet/evm/168587773/etherscan' --etherscan-api-key $ETHERSCAN_API_KEY --verify
```

- Event Voting NFT Proxy

```bash
forge script script/DeployEventVotingNFTProxy.s.sol:DeployUUPSProxy --rpc-url blast_testnet --private-key $PRIVATE_KEY --broadcast --verifier-url 'https://api.routescan.io/v2/network/testnet/evm/168587773/etherscan' --etherscan-api-key $ETHERSCAN_API_KEY --verify
```

- Event Voting Controller NFT

```bash
forge script script/DeployEventVotingController.s.sol --rpc-url blast_testnet --private-key $PRIVATE_KEY --broadcast --verifier-url 'https://api.routescan.io/v2/network/testnet/evm/168587773/etherscan' --etherscan-api-key $ETHERSCAN_API_KEY --verify
```

- Event Voting NFT Controller Proxy

```bash
forge script script/DeployEventVotingControllerProxy.s.sol:DeployUUPSProxy --rpc-url blast_testnet --private-key $PRIVATE_KEY --broadcast --verifier-url 'https://api.routescan.io/v2/network/testnet/evm/168587773/etherscan' --etherscan-api-key $ETHERSCAN_API_KEY --verify
```


### Publish on TheGraph

- Initialize subgraph.

```bash
graph init --studio event-voting-nft
```

- AUTH 

```bash
graph auth --studio 49956ada4ee48d4881a0e91c561bfb95
```

- Build

```bash
graph codegen && graph build
```

- Deploy

```bash
graph deploy --studio event-voting-nft
```

## Bridge ETH from sepolia to balst testnet

https://docs.blast.io/building/bridges/testnet