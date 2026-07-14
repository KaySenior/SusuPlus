import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  bool transactions =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transactions'),),
      body: Column(
        children: [
          if (transactions = false)...[
            Center(
              child: Text('You have no transactions yet'),
            )
          ]
        ],
      ),
    );
  }
}