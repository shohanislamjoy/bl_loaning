import 'package:flutter/material.dart';
import '../services/blockchain_service_sepolia.dart';
import '../config/blockchain_config.dart';

class BlockchainTestWidget extends StatefulWidget {
  const BlockchainTestWidget({super.key});

  @override
  State<BlockchainTestWidget> createState() => _BlockchainTestWidgetState();
}

class _BlockchainTestWidgetState extends State<BlockchainTestWidget> {
  String _status = 'Ready to test blockchain connection';
  bool _isLoading = false;
  Map<String, dynamic>? _testResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blockchain Connection Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Configuration Info
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Configuration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildConfigRow('Network', 'Sepolia Testnet'),
                    _buildConfigRow(
                      'Chain ID',
                      BlockchainConfig.chainId.toString(),
                    ),
                    _buildConfigRow('RPC URL', BlockchainConfig.rpcUrl),
                    _buildConfigRow(
                      'Contract Address',
                      BlockchainConfig.contractAddress,
                    ),
                    _buildConfigRow(
                      'Wallet Address',
                      BlockchainConfig.walletAddress,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Status
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connection Status',
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

            // Test Button
            ElevatedButton(
              onPressed: _isLoading ? null : _testBlockchainConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Test Blockchain Connection'),
            ),

            SizedBox(height: 16),

            // Test Results
            if (_testResult != null) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test Results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      if (_testResult!['success'] == true) ...[
                        Text(
                          '✅ Connection successful!',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildResultRow('Network', _testResult!['network']),
                        _buildResultRow('Wallet', _testResult!['wallet']),
                        _buildResultRow(
                          'Balance (ETH)',
                          _testResult!['balance_eth'],
                        ),
                        _buildResultRow(
                          'Balance (Wei)',
                          _testResult!['balance_wei'],
                        ),
                      ] else ...[
                        Text(
                          '❌ Connection failed',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Error: ${_testResult!['error']}'),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _testBlockchainConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing blockchain connection...';
      _testResult = null;
    });

    try {
      final blockchainService = BlockchainService();
      final result = await blockchainService.testSepoliaConnection();

      setState(() {
        _testResult = result;
        _status = result['success']
            ? 'Connection test completed successfully'
            : 'Connection test failed';
      });

      blockchainService.dispose();
    } catch (e) {
      setState(() {
        _testResult = {'success': false, 'error': e.toString()};
        _status = 'Connection test failed with exception';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
