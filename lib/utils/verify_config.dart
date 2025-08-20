// Simple verification script for blockchain configuration
import '../config/blockchain_config.dart';

void verifyBlockchainConfig() {
  print('=== Blockchain Configuration Verification ===');

  // Check Infura Project ID
  print('Infura Project ID: ${BlockchainConfig.infuraProjectId}');
  print('Is valid format: ${BlockchainConfig.infuraProjectId.length == 32}');

  // Check Contract Address
  print('\nContract Address: ${BlockchainConfig.contractAddress}');
  print(
    'Is valid format: ${_isValidEthereumAddress(BlockchainConfig.contractAddress)}',
  );

  // Check Private Key
  print('\nPrivate Key: ${BlockchainConfig.privateKey.substring(0, 10)}...');
  print('Is valid format: ${_isValidPrivateKey(BlockchainConfig.privateKey)}');

  // Check Wallet Address
  print('\nWallet Address: ${BlockchainConfig.walletAddress}');
  print(
    'Is valid format: ${_isValidEthereumAddress(BlockchainConfig.walletAddress)}',
  );

  // Check RPC URL
  print('\nRPC URL: ${BlockchainConfig.rpcUrl}');
  print('Is Sepolia: ${BlockchainConfig.rpcUrl.contains('sepolia')}');

  // Check Chain ID
  print('\nChain ID: ${BlockchainConfig.chainId}');
  print('Is Sepolia: ${BlockchainConfig.chainId == 11155111}');

  print('\n=== Configuration Check Complete ===');
}

bool _isValidEthereumAddress(String address) {
  // Ethereum address should be 42 characters (0x + 40 hex chars)
  final regex = RegExp(r'^0x[a-fA-F0-9]{40}$');
  return regex.hasMatch(address);
}

bool _isValidPrivateKey(String privateKey) {
  // Private key should be 64 hex characters (or 66 with 0x prefix)
  final regex = RegExp(r'^(0x)?[a-fA-F0-9]{64}$');
  return regex.hasMatch(privateKey);
}

void main() {
  verifyBlockchainConfig();
}
