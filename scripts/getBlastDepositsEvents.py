from web3 import Web3
import csv

# Initialize Web3
w3 = Web3(Web3.HTTPProvider('https://mainnet.infura.io/v3/key'))

# Smart contract ABI (simplified to include only the ETHDeposited event)
contract_abi = '''
[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"BridgeIsNotSet","type":"error"},{"inputs":[],"name":"CallerIsNotStaker","type":"error"},{"inputs":[],"name":"InsufficientFunds","type":"error"},{"inputs":[],"name":"InvalidRecipient","type":"error"},{"inputs":[],"name":"InvalidRecipientSignature","type":"error"},{"inputs":[],"name":"OnlyEOA","type":"error"},{"inputs":[],"name":"SharesNotInitiated","type":"error"},{"inputs":[],"name":"TransitionIsEnabled","type":"error"},{"inputs":[],"name":"TransitionNotEnabled","type":"error"},{"inputs":[],"name":"UserAlreadyTransitioned","type":"error"},{"inputs":[],"name":"ZeroDeposit","type":"error"},{"inputs":[],"name":"ZeroSharesIssued","type":"error"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"previousAdmin","type":"address"},{"indexed":false,"internalType":"address","name":"newAdmin","type":"address"}],"name":"AdminChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"beacon","type":"address"}],"name":"BeaconUpgraded","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"user","type":"address"},{"indexed":false,"internalType":"uint256","name":"shares","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"ETHDeposited","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint8","name":"version","type":"uint8"}],"name":"Initialized","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferStarted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"Paused","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"user","type":"address"},{"indexed":false,"internalType":"uint256","name":"shares","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"daiAmount","type":"uint256"}],"name":"USDDeposited","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"Unpaused","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"implementation","type":"address"}],"name":"Upgraded","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"user","type":"address"},{"indexed":false,"internalType":"uint256","name":"ethAmount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"stETHAmount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"daiAmount","type":"uint256"}],"name":"Withdraw","type":"event"},{"inputs":[],"name":"CURVE_3POOL","outputs":[{"internalType":"contract ICurve3Pool","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"DAI","outputs":[{"internalType":"contract IDAI","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"DSR_MANAGER","outputs":[{"internalType":"contract IDsrManager","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"LIDO","outputs":[{"internalType":"contract ILido","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"PSM","outputs":[{"internalType":"contract IDssPsm","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"USDC","outputs":[{"internalType":"contract IUSDC","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"USDT","outputs":[{"internalType":"contract IUSDT","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"acceptOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"user","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"ethBalance","type":"uint256"},{"internalType":"uint256","name":"usdBalance","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"daiAmount","type":"uint256"}],"name":"depositDAI","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"daiAmount","type":"uint256"},{"internalType":"uint256","name":"nonce","type":"uint256"},{"internalType":"uint256","name":"expiry","type":"uint256"},{"internalType":"uint8","name":"v","type":"uint8"},{"internalType":"bytes32","name":"r","type":"bytes32"},{"internalType":"bytes32","name":"s","type":"bytes32"}],"name":"depositDAIWithPermit","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"depositETH","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256","name":"stETHAmount","type":"uint256"}],"name":"depositStETH","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"stETHAmount","type":"uint256"},{"internalType":"uint256","name":"allowance","type":"uint256"},{"internalType":"uint256","name":"deadline","type":"uint256"},{"internalType":"uint8","name":"v","type":"uint8"},{"internalType":"bytes32","name":"r","type":"bytes32"},{"internalType":"bytes32","name":"s","type":"bytes32"}],"name":"depositStETHWithPermit","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"usdcAmount","type":"uint256"}],"name":"depositUSDC","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"usdcAmount","type":"uint256"},{"internalType":"uint256","name":"allowance","type":"uint256"},{"internalType":"uint256","name":"deadline","type":"uint256"},{"internalType":"uint8","name":"v","type":"uint8"},{"internalType":"bytes32","name":"r","type":"bytes32"},{"internalType":"bytes32","name":"s","type":"bytes32"}],"name":"depositUSDCWithPermit","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"usdtAmount","type":"uint256"},{"internalType":"uint256","name":"minDAIAmount","type":"uint256"}],"name":"depositUSDT","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"emergencyWithdraw","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"mainnetBridge","type":"address"}],"name":"enableTransition","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"ethShares","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getMainnetBridge","outputs":[{"internalType":"contract IMainnetBridge","name":"mainnetBridge","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_staker","type":"address"}],"name":"initialize","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"isTransitionEnabled","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"uint256","name":"nonce","type":"uint256"},{"internalType":"uint8","name":"v","type":"uint8"},{"internalType":"bytes32","name":"r","type":"bytes32"},{"internalType":"bytes32","name":"s","type":"bytes32"}],"name":"open","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"pause","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"paused","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"pendingOwner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"proxiableUUID","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_staker","type":"address"}],"name":"setStaker","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"stakeETH","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"stakeUSD","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"staker","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalETHBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalETHShares","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalUSDBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"totalUSDBalanceNoUpdate","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalUSDShares","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint8","name":"v","type":"uint8"},{"internalType":"bytes32","name":"r","type":"bytes32"},{"internalType":"bytes32","name":"s","type":"bytes32"},{"internalType":"uint32","name":"minGasLimit","type":"uint32"}],"name":"transition","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint32","name":"minGasLimit","type":"uint32"}],"name":"transition","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"transitioned","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"unpause","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newImplementation","type":"address"}],"name":"upgradeTo","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newImplementation","type":"address"},{"internalType":"bytes","name":"data","type":"bytes"}],"name":"upgradeToAndCall","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"usdShares","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"stateMutability":"payable","type":"receive"}]
'''

# Smart contract address
contract_address = '0x5F6AE08B8AeB7078cf2F96AFb089D7c9f51DA47d'
# Create the contract instance
contract = w3.eth.contract(address=contract_address, abi=contract_abi)

def get_eth_deposit_events(contract, start_block, end_block, block_range_increment=1000):
	deposit_events = []
	current_block = start_block
	while current_block < end_block:
		try:
			# Adjust the range for each iteration
			to_block = min(current_block + block_range_increment, end_block)

			logs = contract.events.ETHDeposited().get_logs(
				fromBlock=current_block,
				toBlock=to_block,
			)
			for log in logs:
				deposit_events.append({
					'transactionHash': log.transactionHash.hex(),
					'user': log.args.user,
					'symbol': 'ETH',
					'amount': log.args.amount,
					'blockNumber': log.blockNumber
				})

			# Prepare for the next iteration
			current_block = to_block + 1
		except ValueError as e:
			print(f"Error querying range {current_block} to {to_block}: {e}")
			block_range_increment -= 100

	return deposit_events

def get_usd_deposit_events(contract, start_block, end_block, block_range_increment=1000):
	deposit_events = []
	current_block = start_block
	while current_block < end_block:
		try:
			# Adjust the range for each iteration
			to_block = min(current_block + block_range_increment, end_block)

			logs = contract.events.USDDeposited().get_logs(
				fromBlock=current_block,
				toBlock=to_block,
			)
			for log in logs:
				deposit_events.append({
					'transactionHash': log.transactionHash.hex(),
					'user': log.args.user,
					'symbol': 'DAI',
					'amount': log.args.daiAmount,
					'blockNumber': log.blockNumber
				})

			# Prepare for the next iteration
			current_block = to_block + 1
		except ValueError as e:
			print(f"Error querying range {current_block} to {to_block}: {e}")
			block_range_increment -= 100

	return deposit_events

def export_to_csv(data, csv_file, fieldnames):
	with open(csv_file, mode='w', newline='') as file:
		writer = csv.DictWriter(file, fieldnames=fieldnames)

		# Write the header
		writer.writeheader()

		# Write the rows
		for event in data:
			writer.writerow(event)

	print(f"Data exported to {csv_file}")



def main():
	# Specify your CSV file name
	csv_file = './eth_deposit_events.csv'
	# Field names in the CSV
	fieldnames = ['transactionHash', 'user', 'symbol', 'amount', 'blockNumber']

	deposit_eth_events = get_eth_deposit_events(contract, 18615614, 19267906)
	export_to_csv(deposit_eth_events, csv_file, fieldnames)

	deposit_usd_events = get_eth_deposit_events(contract, 18615614, 19267906)
	export_to_csv(deposit_usd_events, csv_file, fieldnames)