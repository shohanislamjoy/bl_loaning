class AppConstants {
  // Blockchain Constants
  static const String sepoliaChainName = 'Sepolia Testnet';
  static const String etherscanBaseUrl = 'https://sepolia.etherscan.io';

  // UI Constants
  static const String appName = 'BANK OF IUB';
  static const String loanApplicationTitle = 'Loan Application';

  // Error Messages
  static const String networkError =
      'Network connection failed. Please check your internet connection.';
  static const String contractError =
      'Smart contract interaction failed. Please try again.';
  static const String invalidAmountError = 'Please enter a valid loan amount.';
  static const String insufficientFundsError =
      'Insufficient funds for transaction fees.';

  // Success Messages
  static const String borrowerAddedSuccess =
      'Borrower data successfully added to blockchain.';
  static const String loanApplicationSuccess =
      'Loan application submitted successfully!';

  // Loading Messages
  static const String loadingCreditData =
      'Loading credit data from blockchain...';
  static const String submittingLoan = 'Submitting loan application...';
  static const String addingBorrower = 'Adding borrower to blockchain...';
}
