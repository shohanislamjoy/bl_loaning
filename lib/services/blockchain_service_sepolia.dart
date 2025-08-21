import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import '../config/blockchain_config.dart';

class BlockchainService {
  late Web3Client _client;
  late DeployedContract _contract;
  late ContractFunction _addBorrowerFunction;
  late ContractFunction _calculateCreditScoreFunction;
  late ContractFunction _getMaxLoanAmountFunction;
  late ContractFunction _requestLoanFunction;
  late ContractFunction _getCreditRatingFunction;
  late ContractFunction _getBorrowerFunction;

  bool _isInitialized = false;

  // Contract ABI - simplified version focusing on the functions we need
  static const String _contractABI = '''
  [
    {
      "inputs": [
        {"internalType": "string", "name": "nid", "type": "string"},
        {"internalType": "string", "name": "name", "type": "string"},
        {"internalType": "string", "name": "profession", "type": "string"},
        {"internalType": "uint256", "name": "accountBalance", "type": "uint256"},
        {"internalType": "uint256", "name": "totalTransactions", "type": "uint256"},
        {"internalType": "uint256", "name": "onTimePayments", "type": "uint256"},
        {"internalType": "uint256", "name": "missedPayments", "type": "uint256"},
        {"internalType": "uint256", "name": "totalRemainingLoan", "type": "uint256"},
        {"internalType": "uint256", "name": "creditAgeMonths", "type": "uint256"},
        {"internalType": "uint256", "name": "professionRiskScore", "type": "uint256"}
      ],
      "name": "addBorrower",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [{"internalType": "string", "name": "nid", "type": "string"}],
      "name": "calculateCreditScore",
      "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "string", "name": "nid", "type": "string"},
        {"internalType": "uint256", "name": "monthlyIncome", "type": "uint256"}
      ],
      "name": "getMaxLoanAmount",
      "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {"internalType": "string", "name": "nid", "type": "string"},
        {"internalType": "uint256", "name": "amount", "type": "uint256"}
      ],
      "name": "requestLoan",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [{"internalType": "string", "name": "nid", "type": "string"}],
      "name": "getCreditRating",
      "outputs": [{"internalType": "string", "name": "", "type": "string"}],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [{"internalType": "string", "name": "nid", "type": "string"}],
      "name": "getBorrower",
      "outputs": [
        {"internalType": "string", "name": "name", "type": "string"},
        {"internalType": "string", "name": "profession", "type": "string"},
        {"internalType": "uint256", "name": "accountBalance", "type": "uint256"},
        {"internalType": "uint256", "name": "totalTransactions", "type": "uint256"},
        {"internalType": "uint256", "name": "onTimePayments", "type": "uint256"},
        {"internalType": "uint256", "name": "missedPayments", "type": "uint256"},
        {"internalType": "uint256", "name": "totalRemainingLoan", "type": "uint256"},
        {"internalType": "uint256", "name": "creditAgeMonths", "type": "uint256"},
        {"internalType": "uint256", "name": "professionRiskScore", "type": "uint256"},
        {"internalType": "bool", "name": "exists", "type": "bool"}
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ]
  ''';

  BlockchainService() {
    _initializeContract();
  }

  // Test Sepolia connection and wallet balance
  Future<Map<String, dynamic>> testSepoliaConnection() async {
    try {
      final balance = await _client.getBalance(
        EthereumAddress.fromHex(BlockchainConfig.walletAddress),
      );

      final balanceInEther = balance.getValueInUnit(EtherUnit.ether);

      return {
        'success': true,
        'balance_wei': balance.getInWei.toString(),
        'balance_eth': balanceInEther.toString(),
        'network': 'Sepolia Testnet',
        'wallet': BlockchainConfig.walletAddress,
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  void _initializeContract() {
    try {
      _client = Web3Client(BlockchainConfig.rpcUrl, Client());

      _contract = DeployedContract(
        ContractAbi.fromJson(_contractABI, 'CreditScoring'),
        EthereumAddress.fromHex(BlockchainConfig.contractAddress),
      );

      _addBorrowerFunction = _contract.function('addBorrower');
      _calculateCreditScoreFunction = _contract.function(
        'calculateCreditScore',
      );
      _getMaxLoanAmountFunction = _contract.function('getMaxLoanAmount');
      _requestLoanFunction = _contract.function('requestLoan');
      _getCreditRatingFunction = _contract.function('getCreditRating');
      _getBorrowerFunction = _contract.function('getBorrower');

      _isInitialized = true;
      print('Blockchain service initialized successfully');
    } catch (e) {
      print('Failed to initialize blockchain service: $e');
      print('Check your configuration in blockchain_config.dart');
      _isInitialized = false;
      // Don't rethrow to allow app to continue with mock data
    }
  }

  Future<String> addBorrower({
    required String nid,
    required String name,
    required String profession,
    required BigInt accountBalance,
    required BigInt totalTransactions,
    required BigInt onTimePayments,
    required BigInt missedPayments,
    required BigInt totalRemainingLoan,
    required BigInt creditAgeMonths,
    required BigInt professionRiskScore,
  }) async {
    try {
      if (!_isInitialized) {
        print('Blockchain not initialized, simulating borrower addition');
        return 'mock_tx_hash_${DateTime.now().millisecondsSinceEpoch}';
      }

      final credentials = EthPrivateKey.fromHex(BlockchainConfig.privateKey);

      final transaction = Transaction.callContract(
        contract: _contract,
        function: _addBorrowerFunction,
        parameters: [
          nid,
          name,
          profession,
          accountBalance,
          totalTransactions,
          onTimePayments,
          missedPayments,
          totalRemainingLoan,
          creditAgeMonths,
          professionRiskScore,
        ],
      );

      final result = await _client.sendTransaction(
        credentials,
        transaction,
        chainId: BlockchainConfig.chainId,
      );

      print('Borrower added successfully. Transaction hash: $result');
      return result;
    } catch (e) {
      print('Error adding borrower: $e');
      print('Simulating borrower addition with mock data');
      return 'mock_tx_hash_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<BigInt> calculateCreditScore(String nid) async {
    try {
      if (!_isInitialized) {
        print('Blockchain not initialized, returning mock credit score');
        return BigInt.from(780); // Mock credit score
      }

      final result = await _client.call(
        contract: _contract,
        function: _calculateCreditScoreFunction,
        params: [nid],
      );

      return result.first as BigInt;
    } catch (e) {
      print('Error calculating credit score: $e');
      print('Returning mock credit score');
      return BigInt.from(780); // Mock fallback
    }
  }

  Future<BigInt> getMaxLoanAmount(String nid, BigInt monthlyIncome) async {
    try {
      if (!_isInitialized) {
        print('Blockchain not initialized, returning mock max loan amount');
        return BigInt.from(1500000); // Mock max loan amount
      }

      final result = await _client.call(
        contract: _contract,
        function: _getMaxLoanAmountFunction,
        params: [nid, monthlyIncome],
      );

      return result.first as BigInt;
    } catch (e) {
      print('Error getting max loan amount: $e');
      print('Returning mock max loan amount');
      return BigInt.from(1500000); // Mock fallback
    }
  }

  Future<String> getCreditRating(String nid) async {
    try {
      if (!_isInitialized) {
        print('Blockchain not initialized, returning mock credit rating');
        return 'B'; // Mock credit rating
      }

      final result = await _client.call(
        contract: _contract,
        function: _getCreditRatingFunction,
        params: [nid],
      );

      return result.first as String;
    } catch (e) {
      print('Error getting credit rating: $e');
      print('Returning mock credit rating');
      return 'B'; // Mock fallback
    }
  }

  Future<String> requestLoan(String nid, BigInt amount) async {
    try {
      if (!_isInitialized) {
        print('Blockchain not initialized, simulating loan request');
        return 'mock_loan_tx_${DateTime.now().millisecondsSinceEpoch}';
      }

      final credentials = EthPrivateKey.fromHex(BlockchainConfig.privateKey);

      final transaction = Transaction.callContract(
        contract: _contract,
        function: _requestLoanFunction,
        parameters: [nid, amount],
      );

      final result = await _client.sendTransaction(
        credentials,
        transaction,
        chainId: BlockchainConfig.chainId,
      );

      print('Loan requested successfully. Transaction hash: $result');
      return result;
    } catch (e) {
      print('Error requesting loan: $e');
      print('Simulating loan request with mock data');
      return 'mock_loan_tx_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<Map<String, dynamic>> getBorrower(String nid) async {
    try {
      if (!_isInitialized) {
        print('Blockchain not initialized, returning mock borrower data');
        return {
          'name': 'Mr. Karim Uddin',
          'profession': 'Software Engineer',
          'accountBalance': BigInt.from(750218),
          'totalTransactions': BigInt.from(1505220),
          'onTimePayments': BigInt.from(28),
          'missedPayments': BigInt.from(2),
          'totalRemainingLoan': BigInt.from(83000),
          'creditAgeMonths': BigInt.from(60),
          'professionRiskScore': BigInt.from(20),
          'exists': true,
        };
      }

      final result = await _client.call(
        contract: _contract,
        function: _getBorrowerFunction,
        params: [nid],
      );

      return {
        'name': result[0],
        'profession': result[1],
        'accountBalance': result[2],
        'totalTransactions': result[3],
        'onTimePayments': result[4],
        'missedPayments': result[5],
        'totalRemainingLoan': result[6],
        'creditAgeMonths': result[7],
        'professionRiskScore': result[8],
        'exists': result[9],
      };
    } catch (e) {
      print('Error getting borrower: $e');
      print('Returning mock borrower data');
      // Return mock data as fallback
      return {
        'name': 'Mr. Karim Uddin',
        'profession': 'Software Engineer',
        'accountBalance': BigInt.from(750218),
        'totalTransactions': BigInt.from(1505220),
        'onTimePayments': BigInt.from(28),
        'missedPayments': BigInt.from(2),
        'totalRemainingLoan': BigInt.from(83000),
        'creditAgeMonths': BigInt.from(60),
        'professionRiskScore': BigInt.from(20),
        'exists': true,
      };
    }
  }

  void dispose() {
    _client.dispose();
  }
}
