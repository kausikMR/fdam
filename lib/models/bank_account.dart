import 'package:fdam/enums.dart';
import 'package:flutter/material.dart';

@immutable
class BankAccount {
  const BankAccount({
    required this.bank,
    required this.accountNo,
    required this.phoneNo,
    required this.alternatePhoneNo,
    required this.emailId,
    required this.holderName,
    this.balance = 0.0,
    required this.password,
    required this.pin,
  });

  final Bank bank;
  final int accountNo;
  final int phoneNo;
  final int alternatePhoneNo;
  final String emailId;
  final String holderName;
  final double balance;
  final String password;
  final int pin;

  Map<String, dynamic> toMap() {
    return {
      'bank': bank.toString().split('.').last,
      'accountNo': accountNo,
      'phoneNo': phoneNo,
      'alternatePhoneNo': alternatePhoneNo,
      'emailId': emailId,
      'holderName': holderName,
      'balance': balance,
      'password': password,
      'pin': pin,
    };
  }

  factory BankAccount.fromMap(Map<String, dynamic> map) {
    return BankAccount(
      bank: Bank.values.firstWhere(
        (e) => e.toString().split('.').last == map['bank'],
      ),
      password: map['password'],
      accountNo: map['accountNo'],
      phoneNo: map['phoneNo'],
      alternatePhoneNo: map['alternatePhoneNo'],
      emailId: map['emailId'],
      holderName: map['holderName'],
      balance: double.tryParse(map['balance'].toString()) ?? 0.0,
      pin: map['pin'],
    );
  }
}
