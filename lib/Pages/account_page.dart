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
  String _activeTab = 'Accounts'; // Track the current active tab

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
    // Check if there's a recently approved loan
    if (UserData.lastApprovedLoan != null) {
      setState(() {
        _approvedLoans = [UserData.lastApprovedLoan!];
      });
      return;
    }

    // Check if totalRemainingLoan is greater than 83000 (original amount)
    if (UserData.totalRemainingLoan > BigInt.from(83000)) {
      setState(() {
        _approvedLoans = [
          {
            'loanId': 'LOAN${DateTime.now().millisecondsSinceEpoch - 86400000}',
            'amount': UserData.totalRemainingLoan.toString(),
            'approvedDate': DateTime.now().toIso8601String().substring(0, 10),
            'interestRate': '12.5%',
            'duration': '12 months',
            'monthlyEmi': (UserData.totalRemainingLoan.toInt() * 1.125 / 12)
                .round()
                .toString(),
            'status': 'Active',
            'remainingAmount': UserData.totalRemainingLoan.toString(),
            'nextEmiDate': DateTime.now()
                .add(Duration(days: 30))
                .toIso8601String()
                .substring(0, 10),
          },
        ];
      });
    } else {
      // No active loans
      setState(() {
        _approvedLoans = [];
      });
    }

    // Also check blockchain for any pending loans (keep original functionality)
    _blockchainService.getPendingLoans(UserData.nid).then((loans) {
      // Blockchain loans can be added here if needed
    }).catchError((error) {
      print('Error fetching pending loans: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Header Section with interactive tabs
          SharedWidgets.buildInteractiveHeaderSection(
            context,
            'My Account',
            _activeTab,
            (String newTab) {
              setState(() {
                _activeTab = newTab;
              });
            },
          ),

          // Main Content Area - changes based on active tab
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
                  : _buildTabContent(),
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

  // Build content based on active tab
  Widget _buildTabContent() {
    switch (_activeTab) {
      case 'Accounts':
        return _buildAccountsContent();
      case 'FDR/DPS':
        return _buildFDRDPSContent();
      case 'Credit card':
        return _buildCreditCardContent();
      case 'Loans':
        return _buildLoansContent();
      default:
        return _buildAccountsContent();
    }
  }

  Widget _buildAccountsContent() {
    return SingleChildScrollView(
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
                  _borrowerData['name']?.toString() ?? 'Loading...',
                ),
                SharedWidgets.buildDataRow('NID', UserData.nid),
                SharedWidgets.buildDataRow(
                  'Profession',
                  _borrowerData['profession']?.toString() ?? 'Loading...',
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

          // Recent Transactions (if any loans exist)
          if (_approvedLoans.isNotEmpty) ...[
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.trending_up,
                          color: Colors.green,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Loan Disbursed Successfully',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '${_approvedLoans.first['approvedDate']}',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount Credited: ${_approvedLoans.first['amount']} BDT',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green[800],
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Monthly EMI: ${_approvedLoans.first['monthlyEmi']} BDT',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Next Payment Date: ${_approvedLoans.first['nextEmiDate']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 80), // Space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildFDRDPSContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(Icons.savings, size: 48, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  'No FDR/DPS Accounts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'You don\'t have any Fixed Deposit or DPS accounts yet',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCreditCardContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(Icons.credit_card, size: 48, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  'No Credit Cards',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'You don\'t have any credit cards yet',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildLoansContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/loan');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2196F3),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Apply for Loan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          else
            ...(_approvedLoans.map((loan) => _buildLoanCard(loan)).toList()),

          SizedBox(height: 80), // Space for bottom navigation
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
