import 'package:flutter/material.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});
  static const String id = 'transaction-screen';

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          const Text(
            'Transactions',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
