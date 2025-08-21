import 'package:flutter/material.dart';
import 'Pages/home.dart';
import 'Pages/loan_application.dart';
import 'Pages/account_page.dart';
import 'Pages/sepolia_test_page.dart';
import 'Pages/blockchain_test_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Loan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Homepage(),
      routes: {
        '/loan': (context) => LoanApplicationPage(),
        '/account': (context) => AccountPage(),
        '/sepolia-test': (context) => SepoliaTestPage(),
        '/blockchain-test': (context) => BlockchainTestWidget(),
      },
    );
  }
}
