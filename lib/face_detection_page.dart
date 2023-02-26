import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdam/mail_verification_page.dart';
import 'package:fdam/models/bank_account.dart';
import 'package:fdam/utils/my_future_builder.dart';
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

  void _onFacesDetected(List<Face> faces) async {
    if (_faceDetected) return;
    _faceDetected = true;

    FirebaseFirestore.instance.collection('/${widget.bank.name}').get().then(
      (value) {
        final bankAccount = BankAccount.fromMap(value.docs[0].data());
        debugPrint("bankAccount: ${bankAccount.toMap()}");
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AccountDetailsPage(account: bankAccount),
          ),
        );
      },
    ).onError(
      (error, stackTrace) {
        _showSnack('No account found for this bank');
        debugPrint('error: $error');
        debugPrint('stackTrace: $stackTrace');
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
  List<Face> facesDetected = [];

  late final FaceDetector _faceDetector;

  void onImage(CameraImage image) {
    // _faceDetector.processImage(image);
  }

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
    // InputImageData firebaseImageMetadata = InputImageData(
    //   imageRotation: rotationIntToImageRotation(
    //     _cameraController!.description.sensorOrientation,
    //   ),
    //   inputImageFormat: InputImageFormat.bgra8888,
    //   size: Size(image.width.toDouble(), image.height.toDouble()),
    //   planeData: image.planes.map(
    //     (Plane plane) {
    //       return InputImagePlaneMetadata(
    //         bytesPerRow: plane.bytesPerRow,
    //         height: plane.height,
    //         width: plane.width,
    //       );
    //     },
    //   ).toList(),
    // );

    // InputImage firebaseVisionImage = InputImage.fromBytes(
    //   bytes: image.planes[0].bytes,
    //   inputImageData: firebaseImageMetadata,
    // );
    await Future.delayed(const Duration(seconds: 2));
    widget.onFacesDetected.call([]);
    // final List<Face> faces =
    //     // await _faceDetector.processImage(firebaseVisionImage);
    // if (faces.isNotEmpty) {
    //   widget.onFacesDetected.call(faces);
    //   facesDetected = faces;
    //   // faces detected
    //   final lastFace = facesDetected.last;
    //   lastFace;
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
            cameras.last,
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
