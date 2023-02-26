import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdam/enums.dart';
import 'package:fdam/utils/extensions.dart';
import 'package:flutter/material.dart';

import 'models/bank_account.dart';

class CreateBankAccountPage extends StatefulWidget {
  const CreateBankAccountPage({super.key});

  @override
  State<CreateBankAccountPage> createState() => _CreateBankAccountPageState();
}

class _CreateBankAccountPageState extends State<CreateBankAccountPage> {
  final ValueNotifier<Bank?> _selectedBankNotifier = ValueNotifier(null);
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _alternatePhoneNoController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  Future<void> _createBankAccount() async {
    final holderName = _holderNameController.text;
    final phoneNo = int.tryParse(_phoneNoController.text);
    final alternatePhoneNo = int.tryParse(_alternatePhoneNoController.text);
    final email = _emailController.text;
    final password = _passwordController.text;
    final pin = int.tryParse(_pinController.text);
    final bank = _selectedBankNotifier.value;

    if (bank == null) {
      _showSnack('Please select bank');
      return;
    }

    if (holderName.isEmpty) {
      _showSnack('Please enter holder name');
      return;
    }

    if (phoneNo == null || phoneNo.toString().length != 10) {
      _showSnack('Please enter valid phone number');
      return;
    }

    if (alternatePhoneNo == null ||
        alternatePhoneNo == phoneNo ||
        alternatePhoneNo.toString().length != 10) {
      _showSnack('Please enter valid alternate phone number');
      return;
    }

    if (email.isEmpty || !email.contains('')) {
      _showSnack('Please enter email');
      return;
    }

    if (password.isEmpty || password.length < 6) {
      _showSnack('Please enter password');
      return;
    }

    if (pin == null || pin.toString().length != 4) {
      _showSnack('Please enter valid pin');
      return;
    }

    final numberOfAccounts = await FirebaseFirestore.instance
        .collection('/${bank.name}')
        .get()
        .then((value) => value.docs.length);
    final newAccountNo = numberOfAccounts + 1;

    final newBankAccount = BankAccount(
      bank: bank,
      accountNo: newAccountNo,
      phoneNo: phoneNo,
      alternatePhoneNo: alternatePhoneNo,
      emailId: email,
      holderName: holderName,
      password: password,
      pin: pin,
    );

    FirebaseFirestore.instance
        .collection('/${bank.name}')
        .add(newBankAccount.toMap())
        .then(
      (value) {
        _showSnack('Account created successfully');
        if (!mounted) return;
        Navigator.of(context).pop();
      },
    ).onError(
      (error, stackTrace) {
        _showSnack('Error creating account');
      },
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _holderNameController.dispose();
    _phoneNoController.dispose();
    _alternatePhoneNoController.dispose();
    _emailController.dispose();
    _selectedBankNotifier.dispose();
    _passwordController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Bank Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            ValueListenableBuilder<Bank?>(
              valueListenable: _selectedBankNotifier,
              builder: (context, selectedBank, _) {
                return DropdownButton(
                  hint: const Text('Select Bank'),
                  value: selectedBank,
                  items: Bank.values
                      .map(
                        (e) => DropdownMenuItem<Bank>(
                          value: e,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    _selectedBankNotifier.value = value;
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _holderNameController,
              label: 'Holder Name',
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _phoneNoController,
              label: 'Phone Number',
              keyboardType: TextInputType.phone,
              isPhone: true,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _alternatePhoneNoController,
              label: 'Alternate Phone Number',
              keyboardType: TextInputType.phone,
              isPhone: true,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _pinController,
              label: 'Pin',
              keyboardType: TextInputType.number,
              isPin: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createBankAccount,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Create',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextField _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    bool isPin = false,
    bool isPhone = false,
  }) {
    return TextField(
      maxLength: isPhone
          ? 10
          : isPin
              ? 4
              : null,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      keyboardType: keyboardType,
    );
  }
}
