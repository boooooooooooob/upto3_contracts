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
| Event Voting NFT | 0x39F0B612c06A9bf0Fec5Feb233864e645fc872a0 |   |   |   |
| Event Voting NFT Proxy  | 0x1dB31D9b412Eba16D1fBF3E3Df0952202016589f |   |   |   |
| Event Voting Controller | 0x562d60dA90925Ea3d69Dae1A6A55D440fc144354 |   |   |   |
| Event Voting Controller Proxy | 0x3289320CD8631B24662800dd167Ac5bb8534dd53 |   |   |   |
| Upto3 Token | 0xF4bCb898d8EF5816C3b4E58Cce5555633E241B87 |   |   |   |
| Staking Contract | 0xB866DCbfAaF76ecA00d46309f0f8123Ea6061789 |   |   |   |
| Staking Contract Proxy | 0x2FC99b4733c4532E6cB5343219Ec27cA0Dcaa76D |   |   |   |


### Blast mainnet contract addresses
|  contract | address |   
|---|---|---|---|---|
| PassCard NFT | 0x333f50702DFB7FC32CFccEA9F587326D27c6E214 |   
| UPT Token | 0x08e0948E952063a6396a24fc59554aC476bEa66e |
| Token merkle drop | 0x562d60dA90925Ea3d69Dae1A6A55D440fc144354 |

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
forge script script/DeployEventVotingNFT.s.sol:DeployEventVotingNFTImplementation \
--broadcast --rpc-url blast_testnet \
--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/168587773/etherscan'\
--etherscan-api-key "verifyContract" \
--private-key $PRIVATE_KEY
```

- Event Voting NFT Proxy

```bash
forge script script/DeployEventVotingNFTProxy.s.sol:DeployUUPSProxy \
--broadcast --rpc-url blast_testnet \
--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/168587773/etherscan'\
--etherscan-api-key "verifyContract" \
--private-key $PRIVATE_KEY
```

- Event Voting Controller NFT

```bash
forge script script/DeployEventVotingController.s.sol:DeployEventVotingControllerImplementation \
--broadcast --rpc-url blast_testnet \
--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/168587773/etherscan'\
--etherscan-api-key "verifyContract" \
--private-key $PRIVATE_KEY
```

- Event Voting NFT Controller Proxy

```bash
forge script script/DeployEventVotingControllerProxy.s.sol:DeployUUPSProxy \
--broadcast --rpc-url blast_testnet \
--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/168587773/etherscan'\
--etherscan-api-key "verifyContract" \
--private-key $PRIVATE_KEY
```

- Upto3 Token

```bash
forge create --rpc-url blast_testnet \
    --constructor-args 100000000000000000000000000 \
	--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/168587773/etherscan'\
    --private-key $PRIVATE_KEY \
    --etherscan-api-key "verifyContract" \
    src/Upto3Token.sol:UPTToken
```

```bash
forge verify-contract 0xF4bCb898d8EF5816C3b4E58Cce5555633E241B87 src/Upto3Token.sol:UPTToken \
	--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/168587773/etherscan' \
	--etherscan-api-key "verifyContract" \
	--constructor-args $(cast abi-encode "constructor(uint256 param1)" 100000000000000000000000000)
```

- Staking Contract

```bash
forge script script/DeployStakingContract.s.sol:DeployStakingContract \
	--broadcast --rpc-url blast_testnet \
	--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/168587773/etherscan'\
	--etherscan-api-key "verifyContract" \
	--private-key $PRIVATE_KEY
```
- Staking Contract Proxy

```bash
forge script script/DeployStakingContractProxy.s.sol:DeployUUPSProxy \
	--broadcast --rpc-url blast_testnet \
	--verifier-url 'https://api.routescan.io/v2/network/testnet/evm/168587773/etherscan'\
	--etherscan-api-key "verifyContract" \
	--private-key $PRIVATE_KEY
```

### Publish on TheGraph

- Initialize subgraph.

```bash
graph init --studio event-voting-on-blast
```

- AUTH 

```bash
graph auth --studio $key
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