import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bank_selection_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final isAdmin = prefs.getBool('admin');
  runApp(MyApp(isAdmin: isAdmin, prefs: prefs));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isAdmin, required this.prefs});

  final SharedPreferences prefs;
  final bool? isAdmin;

  @override
  Widget build(BuildContext context) {
    isAdmin;
    return MaterialApp(
      title: 'Face Detection Atm Machine',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isAdmin == null
          ? AppTypeChooser(prefs: prefs)
          : isAdmin!
              ? const AdminConsole()
              : const BankSelectionPage(),
    );
  }
}

class AppTypeChooser extends StatelessWidget {
  const AppTypeChooser({super.key, required this.prefs});

  final SharedPreferences prefs;

  void _exitApp({bool isAdmin = false}) async {
    await prefs.setBool('admin', isAdmin);
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => _exitApp(isAdmin: true),
              child: const Text('Admin'),
            ),
            ElevatedButton(
              onPressed: _exitApp,
              child: const Text('User'),
            )
          ],
        ),
      ),
    );
  }
}

class AdminConsole extends StatefulWidget {
  const AdminConsole({super.key});

  @override
  State<AdminConsole> createState() => _AdminConsoleState();
}

class _AdminConsoleState extends State<AdminConsole> {
  final DatabaseReference _signalRef =
      FirebaseDatabase.instance.ref("face_detected");

  void _onChanged(bool value) {
    _signalRef.set(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Console'),
      ),
      body: Center(
        child: StreamBuilder<bool>(
          stream: _signalRef.onValue.map((event) => event.snapshot.value == null
              ? false
              : event.snapshot.value as bool),
          initialData: false,
          builder: (context, snap) {
            if (snap.hasError) {
              return const Text('Error da!');
            }
            return Switch(value: snap.data!, onChanged: _onChanged);
          },
        ),
      ),
    );
  }
}
