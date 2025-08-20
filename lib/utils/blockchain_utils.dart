class BlockchainUtils {
  static String formatBigInt(BigInt value) {
    return value.toString();
  }

  static String formatEther(BigInt wei) {
    // Convert wei to ether (1 ether = 10^18 wei)
    final ether = wei / BigInt.from(1000000000000000000);
    return ether.toString();
  }

  static String formatCurrency(String amount, {String currency = 'BDT'}) {
    try {
      final value = BigInt.parse(amount);
      return '${value.toString()} $currency';
    } catch (e) {
      return '$amount $currency';
    }
  }

  static String getCreditRatingDescription(String rating) {
    switch (rating.toUpperCase()) {
      case 'A':
        return 'Excellent';
      case 'B':
        return 'Good';
      case 'C':
        return 'Fair';
      case 'D':
        return 'Poor';
      default:
        return 'Unknown';
    }
  }

  static bool isValidAmount(String amount) {
    if (amount.isEmpty) return false;
    try {
      final value = BigInt.parse(amount);
      return value > BigInt.zero;
    } catch (e) {
      return false;
    }
  }

  static String getTransactionUrl(String txHash) {
    return 'https://sepolia.etherscan.io/tx/$txHash';
  }
}
