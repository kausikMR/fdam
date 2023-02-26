import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdam/mail_verification_page.dart';
import 'package:fdam/models/bank_account.dart';
import 'package:fdam/utils/my_future_builder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'account_details_page.dart';
import 'enums.dart';

class FaceSignInPage extends StatefulWidget {
  const FaceSignInPage({super.key, required this.bank});

  final Bank bank;

  @override
  State<FaceSignInPage> createState() => _FaceSignInPageState();
}

class _FaceSignInPageState extends State<FaceSignInPage> {
  bool _faceDetected = false;

  late final CollectionReference<BankAccount> _bankReference;
  late final StreamSubscription<DatabaseEvent> _signalSubscription;

  @override
  void initState() {
    super.initState();
    _bankReference = FirebaseFirestore.instance
        .collection('/${widget.bank.name}')
        .withConverter<BankAccount>(
            fromFirestore: (snap, _) => BankAccount.fromMap(snap.data()!),
            toFirestore: (account, _) => account.toMap());

    /// <-- Signal listener
    _signalSubscription =
        FirebaseDatabase.instance.ref('face_detected').onValue.listen((event) {
      debugPrint("FACE_DETECTED: ${event.snapshot.value}");
      final faceDetected =
          event.snapshot.value == null ? false : event.snapshot.value as bool;
      if (faceDetected) {
        _onSignalDetected();
      }
    });
  }

  @override
  void dispose() {
    _signalSubscription.cancel();
    super.dispose();
  }

  void _onSignalDetected() async {
    final accounts = await _bankReference
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AccountDetailsPage(
          account: accounts.first,
        ),
      ),
    );
  }

  Future<BankAccount?> getBankAccountFromFace(Face face) async {
    final accounts = await FirebaseFirestore.instance
        .collection('/${widget.bank.name}')
        .withConverter<BankAccount>(
            fromFirestore: (snap, _) => BankAccount.fromMap(snap.data()!),
            toFirestore: (account, _) => account.toMap())
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => e.data(),
              )
              .toList(),
        );

    // for (final account in accounts) {
    //   final comparableFace = _mlService.getComparableFace(face);
    //   if (comparableFace.compare(account.face, 999, 1.5)) {
    //     return account;
    //   }
    // }
    debugPrint('No accounts matched');
    return null;
  }

  void _onFacesDetected(List<Face> faces) async {
    if (_faceDetected) return;
    _faceDetected = true;
    _showSnack('Face detected');
    // final accounts = await _bankReference
    //     .get()
    //     .then((value) => value.docs.map((e) => e.data()).toList());
    // if (!mounted) return;
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (_) => AccountDetailsPage(account: accounts.first)));

    // final account = await getBankAccountFromFace(faces.first);
    // if (account != null) {
    //   if (!mounted) return;
    //   _showSnack('Welcome ${account.holderName}');
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => AccountDetailsPage(
    //         account: account,
    //       ),
    //     ),
    //   );
    // } else {
    //   _showSnack('Bank account not found');
    // }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MailVerificationPage(bank: widget.bank),
                ),
              );
            },
            icon: const Icon(Icons.mail),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Text(
                widget.bank.toString().split('.').last.toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FaceDetectionCamera(onFacesDetected: _onFacesDetected),
          ],
        ),
      ),
    );
  }
}

class FaceDetectionCamera extends StatefulWidget {
  const FaceDetectionCamera({
    super.key,
    required this.onFacesDetected,
  });

  final void Function(List<Face> face) onFacesDetected;

  @override
  State<FaceDetectionCamera> createState() => _FaceDetectionCameraState();
}

class _FaceDetectionCameraState extends State<FaceDetectionCamera> {
  late final Future<List<CameraDescription>> _camerasFuture;
  CameraController? _cameraController;

  late final FaceDetector _faceDetector;

  InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future<void> detectFacesFromImage(CameraImage image) async {
    InputImageData firebaseImageMetadata = InputImageData(
      imageRotation: rotationIntToImageRotation(
        _cameraController!.description.sensorOrientation,
      ),
      inputImageFormat: InputImageFormat.bgra8888,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      planeData: image.planes.map(
        (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );

    InputImage firebaseVisionImage = InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      inputImageData: firebaseImageMetadata,
    );
    // final List<Face> faces =
    //     await _faceDetector.processImage(firebaseVisionImage);
    // if (faces.isNotEmpty) {
    //   widget.onFacesDetected.call(faces);
    // }
  }

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
    _camerasFuture = availableCameras();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MyFutureBuilder(
        future: _camerasFuture,
        onData: (context, cameras) {
          debugPrint("cameras = $cameras");
          if (cameras == null || cameras.isEmpty) {
            return const Center(
              child: Text('No camera found'),
            );
          }
          _cameraController ??= CameraController(
            cameras[1],
            ResolutionPreset.veryHigh,
          );
          final isInitialized = _cameraController!.value.isInitialized;
          if (!isInitialized) {
            return MyFutureBuilder(
              future: _cameraController!.initialize(),
              onData: (BuildContext context, void data) {
                // after initialization
                _cameraController!.startImageStream(detectFacesFromImage);
                return CameraPreview(_cameraController!);
              },
            );
          }
          return CameraPreview(_cameraController!);
        },
      ),
    );
  }
}
