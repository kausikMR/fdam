import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'account_details_page.dart';
import 'enums.dart';
import 'models/bank_account.dart';

class MailVerificationPage extends StatefulWidget {
  const MailVerificationPage({super.key, required this.bank});

  final Bank bank;

  @override
  State<MailVerificationPage> createState() => _MailVerificationPageState();
}

class _MailVerificationPageState extends State<MailVerificationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mail Verification'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Please verify your email address',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('/${widget.bank.name}')
                  .get()
                  .then(
                (value) {
                  final account = BankAccount.fromMap(value.docs.first.data());
                  if (account.emailId == _emailController.text &&
                      account.password == _passwordController.text) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return AccountDetailsPage(account: account);
                        },
                      ),
                    );
                  } else {
                    _showSnack('Invalid email or password');
                  }
                },
              );
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
}
