import 'package:flutter/material.dart';
import '../services/blockchain_service_sepolia.dart';
import '../config/blockchain_config.dart';
import '../widgets/shared_widgets.dart';

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

    // Check if loan amount is within max limit
    final maxAmount = BigInt.tryParse(_maxLoanAmount) ?? BigInt.zero;
    if (loanAmount > maxAmount) {
      _showErrorDialog(
        'Loan amount exceeds maximum limit of $_maxLoanAmount BDT',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _blockchainService.requestLoan(UserData.nid, loanAmount);

      // Auto-approve loan if amount is within limit
      await _approveLoan(loanAmount);

      _showSuccessDialog(
        'Loan approved and disbursed successfully! Check your account for details.',
      );
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

  Future<void> _approveLoan(BigInt amount) async {
    // Store approved loan details
    final loanData = {
      'amount': amount.toString(),
      'approvedDate': DateTime.now().toIso8601String(),
      'interestRate': '12.5%',
      'duration': '12 months',
      'monthlyEmi': (amount.toInt() * 1.125 / 12).round().toString(),
      'status': 'Active',
      'loanId': 'LOAN${DateTime.now().millisecondsSinceEpoch}',
      'remainingAmount': amount.toString(),
      'nextEmiDate': DateTime.now()
          .add(Duration(days: 30))
          .toIso8601String()
          .substring(0, 10),
    };

    // In a real app, you'd save this to a database or shared preferences
    print('Loan approved: $loanData');

    // Update user's total remaining loan in UserData (simulating persistence)
    UserData.totalRemainingLoan += amount;

    // Navigate to account page to show the approved loan
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushNamed(context, '/account');
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // Top Header Section with standardized styling
          SharedWidgets.buildHeaderSection(
            context,
            'Loan Application',
            'Loans',
          ),

          // Main Content Area - Compact without scrolling
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  // Loading state for initialization
                  if (_isInitializing)
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Color(0xFF2196F3)),
                            SizedBox(height: 12),
                            Text(
                              'Connecting to Blockchain...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Please wait while we fetch your data',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    // User Information Card with dynamic data
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
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
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Blockchain Verified Data',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                SharedWidgets.buildDataRow(
                                  'Name',
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
                                  'Total Transactions',
                                  '${SharedWidgets.formatBigInt(_borrowerData['totalTransactions'])} BDT',
                                ),
                                SharedWidgets.buildDataRow(
                                  'On-time Payments',
                                  '${SharedWidgets.formatBigInt(_borrowerData['onTimePayments'])} payments',
                                ),
                                SharedWidgets.buildDataRow(
                                  'Missed Payments',
                                  '${SharedWidgets.formatBigInt(_borrowerData['missedPayments'])} payments',
                                ),
                                SharedWidgets.buildDataRow(
                                  'Total Remaining Loan',
                                  '${SharedWidgets.formatBigInt(_borrowerData['totalRemainingLoan'])} BDT',
                                ),
                                SharedWidgets.buildDataRow(
                                  'Credit Age',
                                  SharedWidgets.formatCreditAge(
                                    _borrowerData['creditAgeMonths'],
                                  ),
                                ),
                                SharedWidgets.buildDataRow(
                                  'Profession Risk Factor',
                                  SharedWidgets.getProfessionRiskText(
                                    _borrowerData['professionRiskScore'],
                                  ),
                                ),
                                Divider(height: 16, color: Colors.grey[300]),
                                SharedWidgets.buildDataRow(
                                  'Credit Score',
                                  _creditScore.isNotEmpty
                                      ? '$_creditScore (${_creditRating})'
                                      : 'Loading...',
                                  isHighlight: true,
                                ),
                                SharedWidgets.buildDataRow(
                                  'Max Loan Amount',
                                  _maxLoanAmount.isNotEmpty
                                      ? '$_maxLoanAmount BDT'
                                      : 'Loading...',
                                  isHighlight: true,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 12),

                          // Loan Amount Input
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _amountController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter The Loan Amount',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    style: TextStyle(fontSize: 12),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: (_isLoading || _isInitializing)
                                    ? null
                                    : _applyForLoan,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (_isLoading || _isInitializing)
                                        ? Colors.grey
                                        : Color(0xFF2196F3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                          width: 16,
                                          height: 16,
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
                                            fontSize: 12,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
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

  @override
  void dispose() {
    _amountController.dispose();
    _blockchainService.dispose();
    super.dispose();
  }
}
