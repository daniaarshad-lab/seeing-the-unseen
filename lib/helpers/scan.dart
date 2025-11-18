//
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
// import 'package:objectde/pages/ocr.dart';
//
// class ScanPage extends StatefulWidget {
//   @override
//   _ScanPageState createState() => _ScanPageState();
// }
//
// class _ScanPageState extends State<ScanPage> {
//   static int OCR_CAM = FlutterMobileVision.CAMERA_BACK;
//   static String word = "TEXT";
//
//   @override
//   void initState() {
//     super.initState();
//
//
//     FlutterMobileVision.start().then((x) {
//       _read();
//     });
//   }
//
//   Future<void> _read() async {
//     List<OcrText> texts = [];
//
//     try {
//       texts = await FlutterMobileVision.read(
//         multiple: true,
//         camera: OCR_CAM,
//         waitTap: false,
//         preview: FlutterMobileVision.PREVIEW,
//       );
//     } on Exception {
//       texts.add(OcrText('Failed to recognize text.'));
//     }
//
//     if (!mounted) return;
//
//
//     setState(() {});
//   }
//
//   void backpressed(BuildContext context) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => OCRPage()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         backpressed(context);
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           child: CircularProgressIndicator(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
//










// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
//
// class ScanPage extends StatefulWidget {
//   const ScanPage({Key? key}) : super(key: key);
//
//   @override
//   _ScanPageState createState() => _ScanPageState();
// }
//
// class _ScanPageState extends State<ScanPage> {
//   static const int OCR_CAM = FlutterMobileVision.CAMERA_BACK;
//
//   @override
//   void initState() {
//     super.initState();
//     FlutterMobileVision.start().then((_) {
//       _readText();
//     });
//   }
//
//   Future<void> _readText() async {
//     List<OcrText> texts = [];
//
//     try {
//       texts = await FlutterMobileVision.read(
//         multiple: true,
//         camera: OCR_CAM,
//         waitTap: false,
//         preview: FlutterMobileVision.PREVIEW,
//       );
//     } catch (e) {
//       texts.add(OcrText('Failed to recognize text.'));
//     }
//
//     if (!mounted) return;
//
//     // Combine all recognized text
//     String scannedText = texts.map((t) => t.value).join(' ');
//
//     // Filter out non-text symbols (emojis, unusual ASCII)
//     String filteredText =
//     scannedText.replaceAll(RegExp(r'[^\w\s.,;:!?()-]'), '');
//
//     // Return the filtered text to the previous page
//     Navigator.pop(context, filteredText);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: CircularProgressIndicator(color: Colors.white),
//       ),
//     );
//   }
// }


//
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
// import 'package:flutter_tts/flutter_tts.dart';
//
// class ScanPage extends StatefulWidget {
//   const ScanPage({Key? key}) : super(key: key);
//
//   @override
//   _ScanPageState createState() => _ScanPageState();
// }
//
// class _ScanPageState extends State<ScanPage> {
//   static const int OCR_CAM = FlutterMobileVision.CAMERA_BACK;
//   final FlutterTts _flutterTts = FlutterTts();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeTTS();
//     FlutterMobileVision.start().then((_) {
//       _readText();
//     });
//   }
//
//   Future<void> _initializeTTS() async {
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setPitch(1.0);
//     await _flutterTts.setSpeechRate(0.5); // slower for clarity
//   }
//
//   Future<void> _readText() async {
//     List<OcrText> texts = [];
//
//     try {
//       texts = await FlutterMobileVision.read(
//         multiple: true,
//         // camera: OCR_CAM,
//         waitTap: false,
//         preview: FlutterMobileVision.PREVIEW,
//       );
//     } catch (e) {
//       texts.add(OcrText('Failed to recognize text.'));
//     }
//
//     if (!mounted) return;
//
//     // Combine all recognized text
//     String scannedText = texts.map((t) => t.value).join(' ');
//
//     // Filter out non-text symbols (emojis, unusual ASCII)
//     String filteredText =
//     scannedText.replaceAll(RegExp(r'[^\w\s.,;:!?()-]'), '');
//
//     // 🔊 Speak the recognized text using TTS
//     if (filteredText.isNotEmpty) {
//       await _flutterTts.speak(filteredText);
//     } else {
//       await _flutterTts.speak("No readable text found");
//     }
//
//     // Also return text to previous page if needed
//     Navigator.pop(context, filteredText);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: CircularProgressIndicator(color: Colors.white),
//       ),
//     );
//   }
// }
//
//




//



// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ScanPage extends StatefulWidget {
//   const ScanPage({Key? key}) : super(key: key);
//
//   @override
//   State<ScanPage> createState() => _ScanPageState();
// }
//
// class _ScanPageState extends State<ScanPage> {
//   final textRecognizer = TextRecognizer();
//   final FlutterTts flutterTts = FlutterTts();
//
//   @override
//   void initState() {
//     super.initState();
//     _scanAndSpeak(); // 🔹 Automatically open camera on page load
//   }
//
//   Future<void> _scanAndSpeak() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.camera);
//     if (picked != null) {
//       final inputImage = InputImage.fromFilePath(picked.path);
//       final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
//
//       final text = recognizedText.text;
//       if (text.isNotEmpty) {
//         print("Scanned Text: $text");
//         await flutterTts.speak(text);
//       } else {
//         print("No text detected.");
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       // appBar: AppBar(title: Text("OCR Scan")),
//       body: Center(
//         child: Text("Camera opened automatically..."),
//       ),
//     );
//   }
// }




// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:camera/camera.dart';
//
// class ScanPage extends StatefulWidget {
//   const ScanPage({Key? key}) : super(key: key);
//
//   @override
//   State<ScanPage> createState() => _ScanPageState();
// }
//
// class _ScanPageState extends State<ScanPage> {
//   final textRecognizer = TextRecognizer(); // 🔹 same as before
//   final FlutterTts flutterTts = FlutterTts(); // 🔹 same as before
//
//   CameraController? _cameraController;
//   Timer? _timer;
//   bool _isProcessing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }
//
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final backCamera =
//     cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
//
//     _cameraController = CameraController(
//       backCamera,
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
//
//     await _cameraController!.initialize();
//     if (mounted) setState(() {});
//
//     // 🔹 Start continuous scanning every 3 seconds
//     _timer = Timer.periodic(const Duration(seconds: 3), (_) => _scanAndSpeak());
//   }
//
//   Future<void> _scanAndSpeak() async {
//     if (_isProcessing || _cameraController == null || !_cameraController!.value.isInitialized) {
//       return;
//     }
//
//     _isProcessing = true;
//
//     try {
//       // Capture current frame
//       final picture = await _cameraController!.takePicture();
//       final inputImage = InputImage.fromFilePath(picture.path);
//
//       // Recognize text
//       final recognizedText = await textRecognizer.processImage(inputImage);
//       final text = recognizedText.text;
//
//       if (text.isNotEmpty) {
//         print("Scanned Text: $text");
//         await flutterTts.speak(text);
//       } else {
//         print("No text detected.");
//       }
//     } catch (e) {
//       print("Error during scanning: $e");
//     } finally {
//       _isProcessing = false;
//     }
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _cameraController?.dispose();
//     textRecognizer.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       body: CameraPreview(_cameraController!),
//     );
//   }
// }
//


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:camera/camera.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final textRecognizer = TextRecognizer();
  final FlutterTts flutterTts = FlutterTts();

  CameraController? _cameraController;
  Timer? _timer;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    // 🔹 Speak "You are in the Scan Page" on page load
    Future.delayed(const Duration(milliseconds: 500), () async {
      await flutterTts.stop();
      await flutterTts.speak("You are in the Scan Page");
      try {
        await flutterTts.awaitSpeakCompletion(true);
      } catch (_) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    });
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final backCamera =
    cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (mounted) setState(() {});

    // 🔹 Start continuous scanning every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _scanAndSpeak());
  }

  Future<void> _scanAndSpeak() async {
    if (_isProcessing || _cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    _isProcessing = true;

    try {
      // Capture current frame
      final picture = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(picture.path);

      // Recognize text
      final recognizedText = await textRecognizer.processImage(inputImage);
      final text = recognizedText.text;

      if (text.isNotEmpty) {
        print("Scanned Text: $text");
        await flutterTts.speak(text);
      } else {
        print("No text detected.");
      }
    } catch (e) {
      print("Error during scanning: $e");
    } finally {
      _isProcessing = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    textRecognizer.close();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CameraPreview(_cameraController!),
    );
  }
}
