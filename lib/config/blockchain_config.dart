// class BlockchainConfig {
//   // Infura Project Details
//   static const String infuraProjectId = 'a5d9f7740993427e96a0277723ec7c44';
//   static const String projectName =
//       'My First Key'; // Optional, just for reference

//   // Sepolia testnet configuration
//   static const String rpcUrl = 'https://sepolia.infura.io/v3/$infuraProjectId';
//   static const int chainId = 11155111; // Sepolia chain ID

//   // Contract details (replace with your actual deployed contract address)
//   static const String contractAddress =
//       '0x0629904487d908D5C5fCe3B89C8234fcf4d78DAE';

//   // Developer private key (⚠️ Only for testing! Never expose real wallet keys)
//   static const String privateKey =
//       'ad6201382b7bf714e26b2f951a9038bc6a1eff243014223d457509f71be67ac3';

//   // Example user wallet address (replace with one from your privateKey)
//   static const String walletAddress =
//       '0x9EBA0526580292dF4e1C50e19AEB3ec69e12E270';
// }

//office laptop credentials

class BlockchainConfig {
  // Infura Project Details
  static const String infuraProjectId = 'bc4ac4847d624b2ea23a2d1b02eb6efe';
  static const String projectName =
      'My First Key'; // Optional, just for reference

  // Sepolia testnet configuration
  static const String rpcUrl = 'https://sepolia.infura.io/v3/$infuraProjectId';
  static const int chainId = 11155111; // Sepolia chain ID

  // Contract details (replace with your actual deployed contract address)
  static const String contractAddress =
      '0x0629904487d908D5C5fCe3B89C8234fcf4d78DAE';

  // Developer private key (⚠️ Only for testing! Never expose real wallet keys)
  static const String privateKey =
      '2abce993632d07da38f06dccfd5574656a358e41ddb295dd068ee478f729cfa3';

  // Example user wallet address (replace with one from your privateKey)
  static const String walletAddress =
      '0x566258671Fe2c24f8966b822700710cC3b7227d3';
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
