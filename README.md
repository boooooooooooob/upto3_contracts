## Upto3

### Sepolia contract addresses

|  contract | address |   |   |   |
|---|---|---|---|---|
| Event Voting NFT | 0x39F0B612c06A9bf0Fec5Feb233864e645fc872a0 |   |   |   |
| Event Voting NFT Proxy  | 0x1dB31D9b412Eba16D1fBF3E3Df0952202016589f |   |   |   |
| Event Voting Controller | 0x562d60dA90925Ea3d69Dae1A6A55D440fc144354 |   |   |   |
| Event Voting Controller Proxy | 0x3289320CD8631B24662800dd167Ac5bb8534dd53 |   |   |   |

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