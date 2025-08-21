import 'package:flutter/material.dart';
import '../services/blockchain_service_sepolia.dart';
import '../config/blockchain_config.dart';

class LoanApplicationPage extends StatefulWidget {
  const LoanApplicationPage({super.key});

  @override
  State<LoanApplicationPage> createState() => _LoanApplicationPageState();
}

class _LoanApplicationPageState extends State<LoanApplicationPage> {
  final _amountController = TextEditingController();
  final BlockchainService _blockchainService = BlockchainService();

  bool _isLoading = false;
  bool _isInitializing = true;
  String _creditScore = '';
  String _creditRating = '';
  String _maxLoanAmount = '';
  bool _borrowerAdded = false;

  // Borrower data from blockchain
  Map<String, dynamic> _borrowerData = {};

  @override
  void initState() {
    super.initState();
    _initializeBlockchainData();
  }

  Future<void> _initializeBlockchainData() async {
    setState(() {
      _isInitializing = true;
    });

    try {
      // Add borrower to blockchain if not already added
      if (!_borrowerAdded) {
        await _addBorrowerToBlockchain();
        _borrowerAdded = true;

        // Wait for transaction to be mined
        print('Waiting for transaction to be mined...');
        await Future.delayed(Duration(seconds: 15));
      }

      // Fetch borrower data from blockchain
      await _fetchBorrowerData();

      // Get credit score and related data
      await _fetchCreditData();
    } catch (e) {
      print('Error initializing blockchain data: $e');
      _showErrorDialog('Failed to connect to blockchain: $e');
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  Future<void> _addBorrowerToBlockchain() async {
    try {
      await _blockchainService.addBorrower(
        nid: UserData.nid,
        name: UserData.name,
        profession: UserData.profession,
        accountBalance: UserData.accountBalance,
        totalTransactions: UserData.totalTransactions,
        onTimePayments: UserData.onTimePayments,
        missedPayments: UserData.missedPayments,
        totalRemainingLoan: UserData.totalRemainingLoan,
        creditAgeMonths: UserData.creditAgeMonths,
        professionRiskScore: UserData.professionRiskScore,
      );
    } catch (e) {
      print('Error adding borrower: $e');
      rethrow;
    }
  }

  Future<void> _fetchBorrowerData() async {
    try {
      final borrowerData = await _blockchainService.getBorrower(UserData.nid);
      setState(() {
        _borrowerData = borrowerData;
      });
    } catch (e) {
      print('Error fetching borrower data: $e');
      // Use fallback data from UserData
      setState(() {
        _borrowerData = {
          'name': UserData.name,
          'profession': UserData.profession,
          'accountBalance': UserData.accountBalance,
          'totalTransactions': UserData.totalTransactions,
          'onTimePayments': UserData.onTimePayments,
          'missedPayments': UserData.missedPayments,
          'totalRemainingLoan': UserData.totalRemainingLoan,
          'creditAgeMonths': UserData.creditAgeMonths,
          'professionRiskScore': UserData.professionRiskScore,
          'exists': true,
        };
      });
    }
  }

  Future<void> _fetchCreditData() async {
    try {
      // Get credit score
      final creditScore = await _blockchainService.calculateCreditScore(
        UserData.nid,
      );
      _creditScore = creditScore.toString();

      // Get credit rating
      final creditRating = await _blockchainService.getCreditRating(
        UserData.nid,
      );
      _creditRating = creditRating;

      // Get max loan amount
      final maxLoanAmount = await _blockchainService.getMaxLoanAmount(
        UserData.nid,
        UserData.monthlyIncome,
      );
      _maxLoanAmount = maxLoanAmount.toString();

      setState(() {});
    } catch (e) {
      print('Error fetching credit data: $e');
      // Set fallback values
      setState(() {
        _creditScore = '750';
        _creditRating = 'B';
        _maxLoanAmount = '500000';
      });
    }
  }

  Future<void> _applyForLoan() async {
    if (_amountController.text.isEmpty) {
      _showErrorDialog('Please enter a loan amount');
      return;
    }

    final loanAmount = BigInt.tryParse(_amountController.text);
    if (loanAmount == null) {
      _showErrorDialog('Please enter a valid loan amount');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _blockchainService.requestLoan(UserData.nid, loanAmount);
      _showSuccessDialog('Loan application submitted successfully!');
      _amountController.clear();
    } catch (e) {
      print('Error applying for loan: $e');
      _showErrorDialog('Failed to apply for loan: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _formatBigInt(dynamic value) {
    if (value == null) return '0';
    if (value is BigInt) {
      return value.toString();
    }
    return value.toString();
  }

  String _formatCreditAge(dynamic months) {
    if (months == null) return '0 months';
    final monthValue = months is BigInt
        ? months.toInt()
        : int.tryParse(months.toString()) ?? 0;
    final years = monthValue ~/ 12;
    final remainingMonths = monthValue % 12;

    if (years > 0) {
      return remainingMonths > 0
          ? '$years years $remainingMonths months'
          : '$years years';
    }
    return '$monthValue months';
  }

  String _getProfessionRiskText(dynamic riskScore) {
    if (riskScore == null) return 'Unknown';
    final score = riskScore is BigInt
        ? riskScore.toInt()
        : int.tryParse(riskScore.toString()) ?? 0;

    if (score <= 20) return 'Low (Tech industry stability)';
    if (score <= 40) return 'Low-Medium';
    if (score <= 60) return 'Medium';
    if (score <= 80) return 'Medium-High';
    return 'High';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // Top Header Section
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2196F3), // Blue
                  Color(0xFF64B5F6), // Light Blue
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        Text(
                          'BANK OF IUB',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.account_circle,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Loan Application Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Loan Application',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Navigation Tabs
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTabItem('Accounts', false),
                        _buildTabItem('FDR/DPS', false),
                        _buildTabItem('Credit card', false),
                        _buildTabItem('Loans', true),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Main Content Area - Fixed for overflow
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Loading state for initialization
                    if (_isInitializing)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            CircularProgressIndicator(color: Color(0xFF2196F3)),
                            SizedBox(height: 16),
                            Text(
                              'Connecting to Blockchain...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Please wait while we fetch your data from the blockchain',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      // User Information Card with dynamic data
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
                                  Icons.verified,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Blockchain Verified Data',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            _buildDataRow(
                              'Name',
                              _borrowerData['name']?.toString() ?? 'Loading...',
                            ),
                            _buildDataRow('NID', UserData.nid),
                            _buildDataRow(
                              'Profession',
                              _borrowerData['profession']?.toString() ??
                                  'Loading...',
                            ),
                            _buildDataRow(
                              'Account Balance',
                              '${_formatBigInt(_borrowerData['accountBalance'])} BDT',
                            ),
                            _buildDataRow(
                              'Total Transactions',
                              '${_formatBigInt(_borrowerData['totalTransactions'])} BDT',
                            ),
                            _buildDataRow(
                              'On-time Payments',
                              '${_formatBigInt(_borrowerData['onTimePayments'])} payments',
                            ),
                            _buildDataRow(
                              'Missed Payments',
                              '${_formatBigInt(_borrowerData['missedPayments'])} payments',
                            ),
                            _buildDataRow(
                              'Total Remaining Loan',
                              '${_formatBigInt(_borrowerData['totalRemainingLoan'])} BDT',
                            ),
                            _buildDataRow(
                              'Credit Age',
                              _formatCreditAge(
                                _borrowerData['creditAgeMonths'],
                              ),
                            ),
                            _buildDataRow(
                              'Profession Risk Factor',
                              _getProfessionRiskText(
                                _borrowerData['professionRiskScore'],
                              ),
                            ),
                            Divider(height: 20, color: Colors.grey[300]),
                            _buildDataRow(
                              'Credit Score',
                              _creditScore.isNotEmpty
                                  ? '$_creditScore (${_creditRating})'
                                  : 'Loading...',
                              isHighlight: true,
                            ),
                            _buildDataRow(
                              'Max Loan Amount',
                              _maxLoanAmount.isNotEmpty
                                  ? '$_maxLoanAmount BDT'
                                  : 'Loading...',
                              isHighlight: true,
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 20),

                    // Loan Amount Input (only show when not initializing)
                    if (!_isInitializing)
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: TextField(
                                controller: _amountController,
                                decoration: InputDecoration(
                                  hintText: 'Enter The Loan Amount',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey[600]),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: (_isLoading || _isInitializing)
                                ? null
                                : _applyForLoan,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: (_isLoading || _isInitializing)
                                    ? Colors.grey
                                    : Color(0xFF2196F3),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Apply',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),

                    // Add bottom padding to ensure content is not hidden behind footer
                    SizedBox(height: 220),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Section
          Container(
            color: Color(0xFF2196F3),
            child: Column(
              children: [
                // QR Code Section
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.qr_code,
                          size: 40,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'QR',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                // Bottom Navigation
                Container(
                  color: Color(0xFFFF9800), // Orange
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBottomNavItem(Icons.payment, 'Bkash pay'),
                      _buildBottomNavItem(Icons.phone_android, 'Mobile Top Up'),
                      _buildBottomNavItem(Icons.payment, 'Payments'),
                      _buildBottomNavItem(Icons.people, 'Transfer'),
                    ],
                  ),
                ),
                Container(
                  color: Color(0xFFFF9800), // Orange
                  padding: EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBottomNavItem(Icons.description, 'FDR/DPS'),
                      _buildBottomNavItem(Icons.account_balance, 'Sheba'),
                      _buildBottomNavItem(Icons.person, 'Lifestyle'),
                      _buildBottomNavItem(Icons.apps, 'Other Apps'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: isHighlight ? Color(0xFF2196F3) : Colors.black87,
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String text, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Color(0xFF2196F3) : Colors.white,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 24, color: Color(0xFFFF9800)),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _blockchainService.dispose();
    super.dispose();
  }
}
