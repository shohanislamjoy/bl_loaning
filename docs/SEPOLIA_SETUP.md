# Sepolia Testnet Setup Guide

## Complete Setup for Sepolia ETH Test Tokens

### Step 1: Get Sepolia Test ETH

1. **Visit Sepolia Faucets:**
   - [Alchemy Sepolia Faucet](https://sepoliafaucet.com/)
   - [Infura Sepolia Faucet](https://www.infura.io/faucet/sepolia)
   - [Chainlink Sepolia Faucet](https://faucets.chain.link/sepolia)

2. **Request Test ETH:**
   - Enter wallet address: `0x9EBA0526580292dF4e1C50e19AEB3ec69e12E270`
   - Request 0.5-1 ETH (should be enough for testing)
   - Wait for confirmation (usually 1-2 minutes)

3. **Verify Balance:**
   - Check on [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x9EBA0526580292dF4e1C50e19AEB3ec69e12E270)

### Step 2: Deploy Smart Contract to Sepolia

1. **Using Remix IDE:**
   ```
   1. Go to https://remix.ethereum.org/
   2. Create new file: CreditScoring.sol
   3. Paste the provided smart contract code
   4. Compile with Solidity 0.8.20+
   5. Deploy to Sepolia testnet using MetaMask
   6. Save the deployed contract address
   ```

2. **Contract Deployment Details:**
   - Network: Sepolia Testnet
   - Chain ID: 11155111
   - Gas Price: Use default (auto)
   - Estimated Gas: ~2,500,000

### Step 3: Update Flutter Configuration

Update `lib/config/blockchain_config.dart` with your actual values:

```dart
class BlockchainConfig {
  // Get free project ID from https://infura.io/
  static const String infuraProjectId = 'YOUR_INFURA_PROJECT_ID';
  
  // Your deployed contract address on Sepolia
  static const String contractAddress = '0xYOUR_CONTRACT_ADDRESS_HERE';
  
  // Private key for wallet 0x9EBA0526580292dF4e1C50e19AEB3ec69e12E270
  static const String privateKey = 'YOUR_PRIVATE_KEY_HERE';
  
  // Sepolia testnet RPC URL
  static const String rpcUrl = 'https://sepolia.infura.io/v3/$infuraProjectId';
  static const int chainId = 11155111;
  
  // Pre-configured wallet address
  static const String walletAddress = '0x9EBA0526580292dF4e1C50e19AEB3ec69e12E270';
}
```

### Step 4: Test Network Connection

Use this test function to verify connectivity:

```dart
Future<void> testSepoliaConnection() async {
  try {
    final client = Web3Client(BlockchainConfig.rpcUrl, Client());
    final balance = await client.getBalance(
      EthereumAddress.fromHex(BlockchainConfig.walletAddress)
    );
    print('Sepolia ETH Balance: ${balance.getInWei} wei');
    print('Sepolia ETH Balance: ${balance.getValueInUnit(EtherUnit.ether)} ETH');
  } catch (e) {
    print('Connection failed: $e');
  }
}
```

### Step 5: Transaction Cost Estimation

Typical transaction costs on Sepolia:
- `addBorrower()`: ~200,000 gas (~0.002 ETH)
- `requestLoan()`: ~150,000 gas (~0.0015 ETH)
- Contract calls (view): FREE (no gas needed)

### Important Sepolia Testnet Details:

- **Network Name:** Sepolia Test Network
- **RPC URL:** https://sepolia.infura.io/v3/YOUR_PROJECT_ID
- **Chain ID:** 11155111
- **Currency Symbol:** SepoliaETH
- **Block Explorer:** https://sepolia.etherscan.io/

### Security Notes for Sepolia Testing:

✅ **Safe for Testing:**
- Sepolia ETH has no real value
- Perfect for development and testing
- Reset wallet anytime if needed

⚠️ **Still Keep Secure:**
- Don't share private keys
- Use separate wallet for testing
- Never use mainnet private keys for testing
