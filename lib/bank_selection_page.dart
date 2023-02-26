import 'package:fdam/create_bank_account.dart';
import 'package:fdam/face_detection_page.dart';
import 'package:flutter/material.dart';

import 'enums.dart';

class BankSelectionPage extends StatefulWidget {
  const BankSelectionPage({super.key});

  @override
  State<BankSelectionPage> createState() => _BankSelectionPageState();
}

class _BankSelectionPageState extends State<BankSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose your Bank'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          children: [
            for (var bank in Bank.values)
              Card(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FaceSignInPage(bank: bank),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      bank.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateBankAccountPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
