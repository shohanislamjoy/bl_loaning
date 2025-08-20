# 🚀 Sepolia ETH Quick Start Guide

## 1. Get FREE Sepolia Test ETH (2 minutes)

### Option A: Alchemy Faucet (Recommended)
1. Go to: https://sepoliafaucet.com/
2. Enter wallet: `0x9EBA0526580292dF4e1C50e19AEB3ec69e12E270`
3. Click "Send Me ETH"
4. Wait 1-2 minutes for confirmation

### Option B: Infura Faucet
1. Go to: https://www.infura.io/faucet/sepolia
2. Enter wallet: `0x9EBA0526580292dF4e1C50e19AEB3ec69e12E270`
3. Complete verification
4. Receive test ETH

### Option C: Chainlink Faucet
1. Go to: https://faucets.chain.link/sepolia
2. Connect wallet or enter address
3. Request test ETH

## 2. Get FREE Infura Project ID (1 minute)

1. Go to: https://infura.io/
2. Sign up for free account
3. Create new project
4. Copy the Project ID

## 3. Deploy Smart Contract (5 minutes)

### Using Remix IDE:
1. Go to: https://remix.ethereum.org/
2. Create new file: `CreditScoring.sol`
3. Paste the provided smart contract code
4. Go to "Solidity Compiler" tab
5. Select version 0.8.20+
6. Click "Compile"
7. Go to "Deploy & Run Transactions" tab
8. Select "Injected Provider - MetaMask"
9. Switch MetaMask to Sepolia network
10. Click "Deploy"
11. Copy the deployed contract address

## 4. Configure Flutter App (30 seconds)

1. Open `lib/config/blockchain_config.dart`
2. Replace these 3 values:
   ```dart
   static const String infuraProjectId = 'YOUR_INFURA_PROJECT_ID';
   static const String contractAddress = '0xYOUR_CONTRACT_ADDRESS';
   static const String privateKey = 'YOUR_PRIVATE_KEY';
   ```

## 5. Test Everything (1 minute)

1. Run the Flutter app
2. Go to "Sepolia Test Page" (add navigation button)
3. Click "Test Sepolia Connection"
4. Verify ✅ green checkmarks

## 🎉 You're Ready!

Now your loan application will:
- ✅ Store credit data on Sepolia blockchain
- ✅ Calculate credit scores using smart contract
- ✅ Submit loan applications as blockchain transactions
- ✅ All data verifiable on https://sepolia.etherscan.io/

## 💡 Pro Tips:

- Sepolia ETH is FREE and has no real value
- Perfect for testing and development
- Transactions take 15-30 seconds to confirm
- Each transaction costs ~0.001-0.003 SepoliaETH
- 0.5 ETH from faucet = ~200 transactions

## 🔗 Useful Links:

- **Sepolia Explorer:** https://sepolia.etherscan.io/
- **Faucet:** https://sepoliafaucet.com/
- **Remix IDE:** https://remix.ethereum.org/
- **Infura:** https://infura.io/
- **MetaMask:** https://metamask.io/
