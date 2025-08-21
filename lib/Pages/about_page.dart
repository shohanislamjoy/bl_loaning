import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        Text(
                          'EASY LOAN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.info_outline, color: Colors.white, size: 24),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // About Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'About Easy Loan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Main Content Area
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Info Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // App Icon
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Color(0xFF2196F3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.account_balance,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),

                          Text(
                            'Easy Loan',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                          SizedBox(height: 8),

                          Text(
                            'Blockchain-Powered Loan Application',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12),

                          Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Company Info Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.business,
                                color: Color(0xFF2196F3),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Company Information',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2196F3),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          SharedWidgets.buildDataRow(
                            'Company',
                            'Shohan Tech Solutions',
                          ),
                          SharedWidgets.buildDataRow(
                            'Developer',
                            'Shohan Islam Joy',
                          ),
                          SharedWidgets.buildDataRow(
                            'Email',
                            'shohanislamjoy@gmail.com',
                          ),
                          SharedWidgets.buildDataRow(
                            'Technology',
                            'Flutter & Blockchain',
                          ),
                          SharedWidgets.buildDataRow(
                            'Platform',
                            'Android & iOS',
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Features Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Color(0xFF2196F3),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Key Features',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2196F3),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          _buildFeatureItem(
                            '🔐',
                            'Blockchain Security',
                            'Secured by Ethereum blockchain technology',
                          ),
                          _buildFeatureItem(
                            '⚡',
                            'Instant Approval',
                            'Get loan approval in seconds',
                          ),
                          _buildFeatureItem(
                            '📊',
                            'Credit Scoring',
                            'Smart credit assessment system',
                          ),
                          _buildFeatureItem(
                            '💳',
                            'Digital Payments',
                            'Easy EMI management',
                          ),
                          _buildFeatureItem(
                            '📱',
                            'Mobile First',
                            'Designed for mobile banking',
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Copyright Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.copyright,
                            color: Color(0xFF2196F3),
                            size: 24,
                          ),
                          SizedBox(height: 12),

                          Text(
                            '© 2025 Shohan Islam Joy',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                          SizedBox(height: 8),

                          Text(
                            'All rights reserved.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 12),

                          Text(
                            'This application is protected by copyright law. Unauthorized reproduction or distribution of this software is strictly prohibited.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 80), // Space for bottom navigation
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
                SharedWidgets.buildQrSection(),

                // Bottom Navigation
                SharedWidgets.buildBottomNavigation(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 20)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
