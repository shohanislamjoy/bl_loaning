import 'package:flutter/material.dart';
import '../config/blockchain_config.dart';

/// A collection of shared widgets for consistent UI across the application
class SharedWidgets {
  /// Builds the standard QR code section with consistent styling
  static Widget buildQrSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.qr_code, size: 40, color: Color(0xFF2196F3)),
          ),
          SizedBox(height: 2),
          Text('QR', style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  /// Builds the standard bottom navigation with consistent styling
  static Widget buildBottomNavigation(BuildContext context) {
    return Column(
      children: [
        // First row of navigation items
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
        // Second row of navigation items
        Container(
          color: Color(0xFFFF9800), // Orange
          padding: EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomNavItem(Icons.description, 'FDR/DPS'),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/account'),
                child: _buildBottomNavItem(Icons.account_balance, 'Account'),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/'),
                child: _buildBottomNavItem(Icons.home, 'Home'),
              ),
              _buildBottomNavItem(Icons.apps, 'Other Apps'),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a standard bottom navigation item with consistent styling
  static Widget _buildBottomNavItem(IconData icon, String label) {
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

  /// Builds a standard tab item with consistent styling
  static Widget buildTabItem(
    String text,
    bool isSelected, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  /// Builds the standard header section with bank name and navigation tabs
  static Widget buildHeaderSection(
    BuildContext context,
    String title,
    String activeTab,
  ) {
    return Container(
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
                    onTap: () => Navigator.canPop(context)
                        ? Navigator.pop(context)
                        : null,
                    child: Icon(
                      Navigator.canPop(context) ? Icons.arrow_back : Icons.menu,
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
                  Icon(Icons.account_circle, color: Colors.white, size: 24),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Page Title and Welcome
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (title == 'Welcome')
                      Text(
                        '${UserData.name}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
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
                  buildTabItem('Accounts', activeTab == 'Accounts'),
                  buildTabItem('FDR/DPS', activeTab == 'FDR/DPS'),
                  buildTabItem('Credit card', activeTab == 'Credit card'),
                  buildTabItem('Loans', activeTab == 'Loans'),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Builds an interactive header section with functional tab buttons
  static Widget buildInteractiveHeaderSection(
    BuildContext context,
    String title,
    String activeTab,
    Function(String) onTabChanged,
  ) {
    return Container(
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
                    onTap: () => Navigator.canPop(context)
                        ? Navigator.pop(context)
                        : null,
                    child: Icon(
                      Navigator.canPop(context) ? Icons.arrow_back : Icons.menu,
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
                  Icon(Icons.account_circle, color: Colors.white, size: 24),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Page Title and Welcome
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (title == 'Welcome')
                      Text(
                        '${UserData.name}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Interactive Navigation Tabs
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildTabItem(
                    'Accounts',
                    activeTab == 'Accounts',
                    onTap: () => onTabChanged('Accounts'),
                  ),
                  buildTabItem(
                    'FDR/DPS',
                    activeTab == 'FDR/DPS',
                    onTap: () => onTabChanged('FDR/DPS'),
                  ),
                  buildTabItem(
                    'Credit card',
                    activeTab == 'Credit card',
                    onTap: () => onTabChanged('Credit card'),
                  ),
                  buildTabItem(
                    'Loans',
                    activeTab == 'Loans',
                    onTap: () => onTabChanged('Loans'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Builds a standard data row for account and loan information
  static Widget buildDataRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 11,
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
                fontSize: 11,
                color: isHighlight ? Color(0xFF2196F3) : Colors.black87,
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Formats BigInt values for display
  static String formatBigInt(dynamic value) {
    if (value == null) return '0';
    if (value is BigInt) {
      return value.toString();
    }
    return value.toString();
  }

  /// Formats credit age from months to years and months
  static String formatCreditAge(dynamic months) {
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

  /// Gets text description for profession risk score
  static String getProfessionRiskText(dynamic riskScore) {
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
}
