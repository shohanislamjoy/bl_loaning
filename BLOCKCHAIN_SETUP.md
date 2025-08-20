# Blockchain Loan Application Setup Guide

This Flutter application integrates with Ethereum blockchain (Sepolia testnet) for credit scoring and loan applications using smart contracts.

## Prerequisites

1. **Flutter SDK** installed and configured
2. **Infura Account** for Ethereum RPC access
3. **MetaMask Wallet** or any Ethereum wallet
4. **Sepolia ETH** for transaction fees
5. **Deployed Smart Contract** on Sepolia testnet

## Setup Instructions

### 1. Deploy Smart Contract

First, deploy the provided Solidity smart contract to Sepolia testnet:

```solidity
// Use Remix IDE or Hardhat to deploy the CreditScoring contract
// Save the deployed contract address
```

### 2. Configure Blockchain Settings

Update the configuration in `lib/config/blockchain_config.dart`:

```dart
class BlockchainConfig {
  // Get your Infura project ID from https://infura.io/
  static const String infuraProjectId = 'YOUR_INFURA_PROJECT_ID_HERE';
  
  // Replace with your deployed contract address
  static const String contractAddress = '0xYourDeployedContractAddress';
  
  // Replace with your wallet's private key (KEEP THIS SECURE!)
  static const String privateKey = 'YOUR_PRIVATE_KEY_HERE';
  
  // Sepolia testnet configuration (don't change these)
  static const String rpcUrl = 'https://sepolia.infura.io/v3/$infuraProjectId';
  static const int chainId = 11155111;
  
  // User wallet address (already configured)
  static const String walletAddress = '0x9EBA0526580292dF4e1C50e19AEB3ec69e12E270';
}
```

### 3. Security Considerations

⚠️ **IMPORTANT SECURITY NOTES:**

- **Never commit private keys to version control**
- Use environment variables for sensitive data in production
- Consider using secure key management solutions
- The current setup is for development/testing only

### 4. Get Sepolia Test ETH

1. Visit [Sepolia Faucet](https://sepoliafaucet.com/)
2. Enter your wallet address: `0x9EBA0526580292dF4e1C50e19AEB3ec69e12E270`
3. Request test ETH for transaction fees

### 5. Install Dependencies

```bash
flutter pub get
```

### 6. Run the Application

```bash
flutter run
```

## How It Works

### Blockchain Integration Flow:

1. **App Launch**: Automatically adds borrower data to smart contract
2. **Credit Calculation**: Fetches real-time credit score from blockchain
3. **Loan Application**: Submits loan requests as blockchain transactions
4. **Real-time Updates**: All data is stored and retrieved from Sepolia testnet

### Smart Contract Functions Used:

- `addBorrower()`: Stores user credit data on blockchain
- `calculateCreditScore()`: Calculates credit score using weighted algorithm
- `getCreditRating()`: Returns letter grade (A, B, C, D)
- `getMaxLoanAmount()`: Calculates maximum loan based on credit score
- `requestLoan()`: Submits loan application to blockchain

### User Data (Demo):

```dart
- Name: Mr.karim Uddin
- NID: 1029384756
- Profession: Software Engineer
- Account Balance: 750,218 BDT
- Total Transactions: 1,505,220 BDT
- Credit Age: 5 years
- Profession Risk: Low (Tech industry)
```

## Features

- ✅ Real blockchain transactions on Sepolia testnet
- ✅ Smart contract-based credit scoring
- ✅ Dynamic loan amount calculation
- ✅ Real-time transaction status
- ✅ Secure wallet integration
- ✅ Loading states and error handling

## Troubleshooting

### Common Issues:

1. **"Insufficient funds"**: Ensure wallet has Sepolia ETH
2. **"Contract call failed"**: Verify contract address and ABI
3. **"Network error"**: Check Infura project ID and internet connection

### Debugging:

- Check Flutter console for detailed error messages
- Verify all configuration values are correct
- Ensure Sepolia testnet is accessible

## Next Steps

For production deployment:

1. Deploy to Ethereum mainnet
2. Implement proper key management
3. Add multi-signature wallet support
4. Integrate with real banking APIs
5. Add comprehensive testing suite

## Support

If you encounter issues:

1. Check the Flutter console for error messages
2. Verify all configuration values
3. Ensure you have sufficient Sepolia ETH
4. Test the smart contract separately using Remix IDE
