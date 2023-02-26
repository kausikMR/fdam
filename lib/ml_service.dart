import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MLService {
  Interpreter? _interpreter;

  Future<void> initialize() async {
    late Delegate delegate;
    try {
      if (Platform.isAndroid) {
        delegate = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
            isPrecisionLossAllowed: false,
            inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
            inferencePriority1: TfLiteGpuInferencePriority.minLatency,
            inferencePriority2: TfLiteGpuInferencePriority.auto,
            inferencePriority3: TfLiteGpuInferencePriority.auto,
          ),
        );
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
          options: GpuDelegateOptions(
            allowPrecisionLoss: true,
            waitType: TFLGpuDelegateWaitType.active,
          ),
        );
      }
      var interpreterOptions = InterpreterOptions()..addDelegate(delegate);

      _interpreter = await Interpreter.fromAsset(
        'mobilefacenet.tflite',
        options: interpreterOptions,
      );
    } catch (e) {
      debugPrint('Failed to load model. $e');
    }
  }

// Future predictFace(CameraImage image, Face face) async {
//   if (_interpreter == null) throw Exception('Interpreter not initialized');
//   _interpreter!.run(input, output);
// }

// List _preProcess(CameraImage image, Face faceDetected) {
//   Image croppedImage = _cropFace(image, faceDetected);
//   Image img = imglib.copyResizeCropSquare(croppedImage, 112);
//
//   Float32List imageAsList = imageToByteListFloat32(img);
//   return imageAsList;
// }

// Float32List imageToByteListFloat32(Image image) {
//   var convertedBytes = Float32List(1 * 112 * 112 * 3);
//   var buffer = Float32List.view(convertedBytes.buffer);
//   int pixelIndex = 0;
//
//   for (var i = 0; i < 112; i++) {
//     for (var j = 0; j < 112; j++) {
//       var pixel = image.image(j, i);
//       buffer[pixelIndex++] = (image.color.red(pixel) - 128) / 128;
//       buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
//       buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
//     }
//   }
//   return convertedBytes.buffer.asFloat32List();
// }
}
