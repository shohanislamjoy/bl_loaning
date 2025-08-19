import 'package:flutter/material.dart';
import 'Pages/home.dart';
import 'Pages/loan_application.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BL Banking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Homepage(),
      routes: {'/loan': (context) => LoanApplicationPage()},
    );
  }
}
