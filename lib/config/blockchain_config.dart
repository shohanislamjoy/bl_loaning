class BlockchainConfig {
  // Infura Project Details
  static const String infuraProjectId = 'a5d9f7740993427e96a0277723ec7c44';
  static const String projectName =
      'My First Key'; // Optional, just for reference

  // Sepolia testnet configuration
  static const String rpcUrl = 'https://sepolia.infura.io/v3/$infuraProjectId';
  static const int chainId = 11155111; // Sepolia chain ID

  // Contract details (replace with your actual deployed contract address)
  static const String contractAddress =
      '0x4365a53810CD51A3618Aae11F4568A81922d8C5C';

  // Developer private key (⚠️ Only for testing! Never expose real wallet keys)
  static const String privateKey =
      'ad6201382b7bf714e26b2f951a9038bc6a1eff243014223d457509f71be67ac3';

  // Example user wallet address (replace with one from your privateKey)
  static const String walletAddress =
      '0x9EBA0526580292dF4e1C50e19AEB3ec69e12E270';
}

class UserData {
  static const String nid = '1029384999';
  static const String name = 'Mr.karim Uddin';
  static const String profession = 'Software Engineer';
  static final BigInt accountBalance = BigInt.from(70218);
  static final BigInt totalTransactions = BigInt.from(150520);
  static final BigInt onTimePayments = BigInt.from(
    45,
  ); // Assuming good payment history
  static final BigInt missedPayments = BigInt.from(3); // Few missed payments
  static final BigInt totalRemainingLoan = BigInt.from(83000);
  static final BigInt creditAgeMonths = BigInt.from(60); // 5 years
  static final BigInt professionRiskScore = BigInt.from(
    20,
  ); // Low risk for tech industry
  static final BigInt monthlyIncome = BigInt.from(
    80000,
  ); // Estimated monthly income
}
