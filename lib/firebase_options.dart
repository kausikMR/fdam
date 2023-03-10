// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCPmkXE03KpMV0AxUDWLSzLLSlwdwlIkjA',
    appId: '1:454237222673:web:95b5519cda4ae312ec7eb0',
    messagingSenderId: '454237222673',
    projectId: 'fdam-e699b',
    authDomain: 'fdam-e699b.firebaseapp.com',
    databaseURL: 'https://fdam-e699b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fdam-e699b.appspot.com',
    measurementId: 'G-97KTNHH3XL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNXuUpMLmxIlsYRyMtnem5IixbFbgxeKU',
    appId: '1:454237222673:android:3d137b9547a3763bec7eb0',
    messagingSenderId: '454237222673',
    projectId: 'fdam-e699b',
    databaseURL: 'https://fdam-e699b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fdam-e699b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDkhT8OB5pv2vA80jXqb68XPInVyTf5IYs',
    appId: '1:454237222673:ios:f126befc9391d2a0ec7eb0',
    messagingSenderId: '454237222673',
    projectId: 'fdam-e699b',
    databaseURL: 'https://fdam-e699b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fdam-e699b.appspot.com',
    iosClientId: '454237222673-ag93ujno7bc8hr66tqr2fikn43764qsk.apps.googleusercontent.com',
    iosBundleId: 'com.example.fdam',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDkhT8OB5pv2vA80jXqb68XPInVyTf5IYs',
    appId: '1:454237222673:ios:f126befc9391d2a0ec7eb0',
    messagingSenderId: '454237222673',
    projectId: 'fdam-e699b',
    databaseURL: 'https://fdam-e699b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fdam-e699b.appspot.com',
    iosClientId: '454237222673-ag93ujno7bc8hr66tqr2fikn43764qsk.apps.googleusercontent.com',
    iosBundleId: 'com.example.fdam',
  );
}
