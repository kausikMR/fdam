import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models/bank_account.dart';

class AccountDetailsPage extends StatefulWidget {
  const AccountDetailsPage({
    super.key,
    required this.account,
  });

  final BankAccount account;

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                widget.account.bank.toString().split('.').last.toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.account.holderName,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Account Number: ${widget.account.accountNo}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Balance: \$${widget.account.balance}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Pin',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text);
                final pin = int.tryParse(_pinController.text);

                if (amount == null || amount > widget.account.balance) {
                  _showSnack('Insufficient balance');
                  return;
                }
                if (pin == null || pin != widget.account.pin) {
                  _showSnack('Invalid pin');
                  return;
                }
                FirebaseFirestore.instance
                    .collection('/${widget.account.bank.name}')
                    .where('accountNo', isEqualTo: widget.account.accountNo)
                    .get()
                    .then((value) {
                  value.docs[0].reference.update({
                    'balance': widget.account.balance - amount,
                  }).then((value) {
                    _showSnack('Transaction successful');
                  }).onError((error, stackTrace) {
                    _showSnack('Transaction failed');
                    debugPrint('error: $error');
                    debugPrint('stackTrace: $stackTrace');
                  });
                }).then(
                  (value) {
                    _showSnack('Transaction successful');
                  },
                ).onError((error, stackTrace) {
                  _showSnack('Transaction failed');
                  debugPrint('error: $error');
                  debugPrint('stackTrace: $stackTrace');
                });
              },
              child: const Text('Transaction'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
