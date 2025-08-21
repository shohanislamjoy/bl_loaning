import 'package:flutter/material.dart';
import '../services/blockchain_service_sepolia.dart';
import '../config/blockchain_config.dart';
import '../widgets/shared_widgets.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final BlockchainService _blockchainService = BlockchainService();
  bool _isLoading = true;
  Map<String, dynamic> _borrowerData = {};
  List<Map<String, dynamic>> _approvedLoans = [];

  @override
  void initState() {
    super.initState();
    _loadAccountData();
  }

  Future<void> _loadAccountData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch borrower data from blockchain
      final borrowerData = await _blockchainService.getBorrower(UserData.nid);
      setState(() {
        _borrowerData = borrowerData;
      });

      // Load approved loans (in a real app, this would come from a database)
      _loadApprovedLoans();
    } catch (e) {
      print('Error loading account data: $e');
      // Use fallback data
      setState(() {
        _borrowerData = {
          'name': UserData.name,
          'profession': UserData.profession,
          'accountBalance': UserData.accountBalance,
          'exists': true,
        };
      });
      _loadApprovedLoans();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadApprovedLoans() {
    // Get loan data from shared preferences or storage
    // For now, this is simulated but would typically be stored data

    // Check if there are any pending loans from the blockchain
    _blockchainService
        .getPendingLoans(UserData.nid)
        .then((loans) {
          setState(() {
            // Here we would add real blockchain loans
            // For now, we'll use data from blockchain_config.dart
            _approvedLoans = [
              {
                'loanId':
                    'LOAN${DateTime.now().millisecondsSinceEpoch - 86400000}',
                'amount': UserData.totalRemainingLoan.toString(),
                'approvedDate': '2024-08-${DateTime.now().day - 2}',
                'interestRate': '12.5%',
                'duration': '12 months',
                'monthlyEmi': (UserData.totalRemainingLoan.toInt() * 1.125 / 12)
                    .round()
                    .toString(),
                'status': 'Active',
                'remainingAmount': UserData.totalRemainingLoan.toString(),
                'nextEmiDate': '2024-09-${DateTime.now().day - 2}',
              },
            ];
          });
        })
        .catchError((error) {
          print('Error fetching pending loans: $error');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Header Section with standardized styling
          SharedWidgets.buildHeaderSection(context, 'My Account', 'Accounts'),

          // Main Content Area
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(12),
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2196F3),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Account Summary Card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet,
                                      color: Color(0xFF2196F3),
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Account Summary',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF2196F3),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                SharedWidgets.buildDataRow(
                                  'Account Holder',
                                  _borrowerData['name']?.toString() ??
                                      'Loading...',
                                ),
                                SharedWidgets.buildDataRow('NID', UserData.nid),
                                SharedWidgets.buildDataRow(
                                  'Profession',
                                  _borrowerData['profession']?.toString() ??
                                      'Loading...',
                                ),
                                SharedWidgets.buildDataRow(
                                  'Account Balance',
                                  '${SharedWidgets.formatBigInt(_borrowerData['accountBalance'])} BDT',
                                ),
                                SharedWidgets.buildDataRow(
                                  'Total Active Loans',
                                  '${_approvedLoans.length}',
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 16),

                          // Approved Loans Section
                          Text(
                            'My Loans',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),

                          // Loans List
                          if (_approvedLoans.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.account_balance,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No Active Loans',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Apply for a loan to see it here',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...(_approvedLoans
                                .map((loan) => _buildLoanCard(loan))
                                .toList()),

                          SizedBox(height: 80), // Space for bottom navigation
                        ],
                      ),
                    ),
            ),
          ),

          // Bottom Section with standardized styling
          Container(
            color: Color(0xFF2196F3),
            child: Column(
              children: [
                // QR Code Section with standard size
                SharedWidgets.buildQrSection(),

                // Bottom Navigation with standard styling
                SharedWidgets.buildBottomNavigation(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanCard(Map<String, dynamic> loan) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loan ID: ${loan['loanId']}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2196F3),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  loan['status'],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.green[800],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SharedWidgets.buildDataRow(
                      'Loan Amount',
                      '${loan['amount']} BDT',
                    ),
                    SharedWidgets.buildDataRow(
                      'Interest Rate',
                      loan['interestRate'],
                    ),
                    SharedWidgets.buildDataRow('Duration', loan['duration']),
                    SharedWidgets.buildDataRow(
                      'Approved Date',
                      loan['approvedDate'],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SharedWidgets.buildDataRow(
                      'Monthly EMI',
                      '${loan['monthlyEmi']} BDT',
                    ),
                    SharedWidgets.buildDataRow(
                      'Remaining',
                      '${loan['remainingAmount']} BDT',
                    ),
                    SharedWidgets.buildDataRow(
                      'Next EMI Date',
                      loan['nextEmiDate'],
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        _showPaymentDialog(loan);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2196F3),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                      ),
                      child: Text(
                        'Pay EMI',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(Map<String, dynamic> loan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pay EMI', style: TextStyle(fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Loan ID: ${loan['loanId']}'),
              SizedBox(height: 8),
              Text('EMI Amount: ${loan['monthlyEmi']} BDT'),
              SizedBox(height: 8),
              Text('Due Date: ${loan['nextEmiDate']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('EMI payment successful!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Pay Now'),
            ),
          ],
        );
      },
    );
  }
}
