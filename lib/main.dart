// main.dart
import 'package:flutter/material.dart';
import 'ui/invoice_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.pink,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFFFFB6C1),
        foregroundColor: Colors.brown[900],
        elevation: 0,
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown[800]),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: 14, color: Colors.brown[800]),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink[800]),
      ),
    ),
    home: InvoicePage(),
  ));
}