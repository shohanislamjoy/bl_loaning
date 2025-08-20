// STEP 1: Replace YOUR_INFURA_PROJECT_ID with your actual Infura project ID
// Get it free from: https://infura.io/

// STEP 2: Deploy the smart contract and replace YOUR_CONTRACT_ADDRESS
// Use Remix IDE: https://remix.ethereum.org/

// STEP 3: Replace YOUR_PRIVATE_KEY with the private key for wallet 0x9EBA0526580292dF4e1C50e19AEB3ec69e12E270
// ⚠️ Keep this secure! Never share or commit to git!

class BlockchainConfig {
  // 🔧 CONFIGURE THESE VALUES:
  static const String infuraProjectId = 'YOUR_INFURA_PROJECT_ID';
  static const String contractAddress = '0xYOUR_CONTRACT_ADDRESS';
  static const String privateKey = 'YOUR_PRIVATE_KEY';

  // ✅ PRE-CONFIGURED (don't change):
  static const String rpcUrl = 'https://sepolia.infura.io/v3/$infuraProjectId';
  static const int chainId = 11155111; // Sepolia testnet
  static const String walletAddress =
      '0x9EBA0526580292dF4e1C50e19AEB3ec69e12E270';
}

class UserData {
  static const String nid = '1029384756';
  static const String name = 'Mr.karim Uddin';
  static const String profession = 'Software Engineer';
  static final BigInt accountBalance = BigInt.from(750218);
  static final BigInt totalTransactions = BigInt.from(1505220);
  static final BigInt onTimePayments = BigInt.from(45);
  static final BigInt missedPayments = BigInt.from(3);
  static final BigInt totalRemainingLoan = BigInt.from(83000);
  static final BigInt creditAgeMonths = BigInt.from(60); // 5 years
  static final BigInt professionRiskScore = BigInt.from(20); // Low risk
  static final BigInt monthlyIncome = BigInt.from(80000);
}

// 📋 SETUP CHECKLIST:
// □ Get Sepolia ETH from faucet: https://sepoliafaucet.com/
// □ Get Infura project ID: https://infura.io/
// □ Deploy smart contract on Sepolia testnet
// □ Update the 3 configuration values above
// □ Test connection using the Sepolia Test Page in the app
