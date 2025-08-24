// fill the needed credentials\

class BlockchainConfig {
  // Infura Project Details
  static const String infuraProjectId = '';
  static const String projectName =
      'My First Key'; // Optional, just for reference

  // Sepolia testnet configuration
  static const String rpcUrl = 'https://sepolia.infura.io/v3/$infuraProjectId';
  static const int chainId = 11155111; // Sepolia chain ID

  // Contract details
  static const String contractAddress = '';

  // Developer private key
  static const String privateKey = '';

  // Example user wallet address
  static const String walletAddress = '';
}

class UserData {
  static const String nid = '1029384957';
  // static const String name = 'Mr.karim Uddin';
  static const String name = 'Mr.Hamim Alam';
  static const String profession = 'junior Software Engineer';
  static final BigInt accountBalance = BigInt.from(506988);
  static final BigInt totalTransactions = BigInt.from(1505200);
  static final BigInt onTimePayments = BigInt.from(
    45,
  ); // Assuming good payment history
  static final BigInt missedPayments = BigInt.from(1); // Few missed payments
  static BigInt totalRemainingLoan = BigInt.from(
    83000,
  ); // Made non-final to allow updates
  static final BigInt creditAgeMonths = BigInt.from(60); // 5 years
  static final BigInt professionRiskScore = BigInt.from(
    20,
  ); // Low risk for tech industry
  static final BigInt monthlyIncome = BigInt.from(
    90000,
  ); // Estimated monthly income

  // Store the last approved loan data
  static Map<String, dynamic>? lastApprovedLoan;
}
