import 'package:flutter/material.dart';
import '../services/blockchain_service_sepolia.dart';
import '../config/blockchain_config.dart';

class SepoliaTestPage extends StatefulWidget {
  const SepoliaTestPage({super.key});

  @override
  State<SepoliaTestPage> createState() => _SepoliaTestPageState();
}

class _SepoliaTestPageState extends State<SepoliaTestPage> {
  final BlockchainService _blockchainService = BlockchainService();

  bool _isLoading = false;
  Map<String, dynamic>? _connectionTest;
  String _status = 'Ready to test Sepolia connection';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sepolia Testnet Test'),
        backgroundColor: Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sepolia Testnet Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(_status),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Test Connection Button
            ElevatedButton(
              onPressed: _isLoading ? null : _testConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2196F3),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Test Sepolia Connection'),
            ),

            SizedBox(height: 16),

            // Connection Results
            if (_connectionTest != null) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connection Test Results',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      ...(_connectionTest!['success'] == true
                          ? _buildSuccessResults()
                          : _buildErrorResults()),
                    ],
                  ),
                ),
              ),
            ],

            SizedBox(height: 16),

            // Configuration Info
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuration',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Network: Sepolia Testnet'),
                    Text('Chain ID: ${BlockchainConfig.chainId}'),
                    Text('Wallet: ${BlockchainConfig.walletAddress}'),
                    Text('RPC: ${BlockchainConfig.rpcUrl.split('/').last}'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Instructions
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Setup Instructions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('1. Get Sepolia ETH from faucet'),
                    Text('2. Deploy smart contract to Sepolia'),
                    Text('3. Update blockchain_config.dart'),
                    Text('4. Test connection above'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing Sepolia connection...';
    });

    try {
      final result = await _blockchainService.testSepoliaConnection();
      setState(() {
        _connectionTest = result;
        _status = result['success']
            ? 'Connected to Sepolia successfully!'
            : 'Connection failed';
      });
    } catch (e) {
      setState(() {
        _connectionTest = {'success': false, 'error': e.toString()};
        _status = 'Connection error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Widget> _buildSuccessResults() {
    return [
      Text(
        '✅ Successfully connected to Sepolia',
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      Text('Network: ${_connectionTest!['network']}'),
      Text('Wallet: ${_connectionTest!['wallet']}'),
      Text('Balance: ${_connectionTest!['balance_eth']} SepoliaETH'),
      Text('Balance (wei): ${_connectionTest!['balance_wei']}'),
      SizedBox(height: 8),
      if (double.parse(_connectionTest!['balance_eth']) > 0.01)
        Text(
          '✅ Sufficient balance for transactions',
          style: TextStyle(color: Colors.green),
        )
      else
        Text(
          '⚠️ Low balance - get more from faucet',
          style: TextStyle(color: Colors.orange),
        ),
    ];
  }

  List<Widget> _buildErrorResults() {
    return [
      Text(
        '❌ Connection failed',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      Text('Error: ${_connectionTest!['error']}'),
      SizedBox(height: 8),
      Text(
        'Check your configuration:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text('• Infura Project ID'),
      Text('• Contract Address'),
      Text('• Private Key'),
      Text('• Internet connection'),
    ];
  }

  @override
  void dispose() {
    _blockchainService.dispose();
    super.dispose();
  }
}
