import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';
import '../config/blockchain_config.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _activeTab = 'Loans'; // Default to Loans tab for home page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Header Section with interactive tabs
          SharedWidgets.buildInteractiveHeaderSection(
            context,
            'Welcome',
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
              child: _buildTabContent(),
            ),
          ),

          // Bottom Section with standardized navigation
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

  Widget _buildTabContent() {
    switch (_activeTab) {
      case 'Accounts':
        return _buildAccountsPreview();
      case 'FDR/DPS':
        return _buildFDRDPSPreview();
      case 'Credit card':
        return _buildCreditCardPreview();
      case 'Loans':
        return _buildLoansContent();
      default:
        return _buildLoansContent();
    }
  }

  Widget _buildLoansContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Apply For Easy Loan Button
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/loan');
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Apply For Easy Loan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Color(0xFF2196F3), size: 20),
              ],
            ),
          ),
        ),

        SizedBox(height: 20),

        // Quick loan info
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF2196F3), size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Loan Information',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              SharedWidgets.buildDataRow('Max Loan Amount', '1,500,000 BDT'),
              SharedWidgets.buildDataRow('Interest Rate', '12.5% per annum'),
              SharedWidgets.buildDataRow('Processing Time', 'Instant approval'),
              SharedWidgets.buildDataRow('Repayment Period', 'Up to 12 months'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountsPreview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 48,
                color: Color(0xFF2196F3),
              ),
              SizedBox(height: 16),
              Text(
                'Account Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              SharedWidgets.buildDataRow('Account Holder', UserData.name),
              SharedWidgets.buildDataRow(
                'Account Balance',
                '${SharedWidgets.formatBigInt(UserData.accountBalance)} BDT',
              ),
              SharedWidgets.buildDataRow('NID', UserData.nid),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/account');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2196F3),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'View Full Details',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFDRDPSPreview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.savings, size: 48, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'FDR/DPS Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Fixed Deposit and DPS services will be available soon',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreditCardPreview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.credit_card, size: 48, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'Credit Card Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Credit card services will be available soon',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
