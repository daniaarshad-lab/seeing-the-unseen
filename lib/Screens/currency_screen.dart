// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:tflite_v2/tflite_v2.dart';
//
// class CurrencyScreen extends StatefulWidget {
//   final CameraDescription camera;
//
//   const CurrencyScreen({super.key, required this.camera});
//
//   @override
//   State<CurrencyScreen> createState() => _CurrencyScreenState();
// }
//
// class _CurrencyScreenState extends State<CurrencyScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.camera, ResolutionPreset.high);
//     _initializeControllerFuture = _controller.initialize();
//
//   }
//
//
//
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Center(child: Text('Noteify – Currency'))),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return CameraPreview(_controller);
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton.large(
//         onPressed: () async {
//           try {
//             await _initializeControllerFuture;
//             XFile picture = await _controller.takePicture();
//
//             if (!mounted) return;
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     CurrencyResultScreen(imagePath: picture.path),
//               ),
//             );
//           } catch (e) {
//             print('Error taking picture: $e');
//           }
//         },
//         child: const Icon(Icons.camera_alt, size: 40),
//       ),
//     );
//   }
// }
//
// // ------------------------------------------------------------
// // Result Screen (same as DisplayPictureScreen previously)
// // ------------------------------------------------------------
// class CurrencyResultScreen extends StatefulWidget {
//   final String imagePath;
//
//   const CurrencyResultScreen({super.key, required this.imagePath});
//
//   @override
//   State<CurrencyResultScreen> createState() => _CurrencyResultScreenState();
// }
//
// class _CurrencyResultScreenState extends State<CurrencyResultScreen> {
//   final FlutterTts flutterTts = FlutterTts();
//   List? output;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadModelAndClassify();
//   }
//
//   Future<void> _loadModelAndClassify() async {
//     try {
//       await Tflite.loadModel(
//         model: "assets/new.tflite",
//         labels: "assets/newlabels.txt",
//       );
//
//       print("✅ Model Loaded Successfully");
//       await _classifyImage(widget.imagePath);
//     } catch (e) {
//       print("❌ Model Load Error: $e");
//     }
//   }
//
//   Future<void> _classifyImage(String imagePath) async {
//     output = await Tflite.runModelOnImage(
//       path: imagePath,
//       numResults: 7,
//       threshold: 0.2,
//       imageMean: 0,
//       imageStd: 255,
//       asynch: true,
//     );
//
//     print("Raw Output: $output");
//
//     if (output != null && output!.isNotEmpty) {
//       String rawLabel = output![0]["label"];
//
//       // Remove numeric prefix (e.g., "0 5000 rupees")
//       String cleanLabel = rawLabel.replaceFirst(RegExp(r'^\d+\s+'), '');
//
//       print("🎯 Clean Label: $cleanLabel");
//       await _speak(cleanLabel);
//     } else {
//       await _speak("No recognizable currency note found.");
//     }
//   }
//
//   Future<void> _speak(String text) async {
//     await flutterTts.setSpeechRate(0.85);
//     await flutterTts.setPitch(1.0);
//     await flutterTts.awaitSpeakCompletion(true);
//     await flutterTts.speak(text);
//   }
//
//   @override
//   void dispose() {
//     Tflite.close();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Detected Currency')),
//       body: Center(
//         child: Image.file(File(widget.imagePath)),
//       ),
//     );
//   }
// }



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:tflite_v2/tflite_v2.dart';
//
// class CurrencyScreen extends StatefulWidget {
//   final CameraDescription camera;
//
//   const CurrencyScreen({super.key, required this.camera});
//
//   @override
//   State<CurrencyScreen> createState() => _CurrencyScreenState();
// }
//
// class _CurrencyScreenState extends State<CurrencyScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   final FlutterTts _tts = FlutterTts();
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.camera, ResolutionPreset.high);
//     _initializeControllerFuture = _controller.initialize();
//
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _tts.setLanguage("en-US");
//       await _tts.awaitSpeakCompletion(true);
//       await _tts.speak(
//         "You are now in the Currency Detection screen. "
//             "Tap the camera button to capture a note.",
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _tts.stop();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Center(child: Text('Noteify – Currency'))),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return CameraPreview(_controller);
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton.large(
//         onPressed: () async {
//           try {
//             await _initializeControllerFuture;
//             XFile picture = await _controller.takePicture();
//
//             if (!mounted) return;
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     CurrencyResultScreen(imagePath: picture.path),
//               ),
//             );
//           } catch (e) {
//             print('Error taking picture: $e');
//           }
//         },
//         child: const Icon(Icons.camera_alt, size: 40),
//       ),
//     );
//   }
// }
//
// // ------------------------------------------------------------
// // Result Screen
// // ------------------------------------------------------------
// class CurrencyResultScreen extends StatefulWidget {
//   final String imagePath;
//
//   const CurrencyResultScreen({super.key, required this.imagePath});
//
//   @override
//   State<CurrencyResultScreen> createState() => _CurrencyResultScreenState();
// }
//
// class _CurrencyResultScreenState extends State<CurrencyResultScreen> {
//   final FlutterTts flutterTts = FlutterTts();
//   List? output;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadModelAndClassify();
//   }
//
//   Future<void> _loadModelAndClassify() async {
//     try {
//       await Tflite.loadModel(
//         model: "assets/new.tflite",
//         labels: "assets/newlabels.txt",
//       );
//
//       print("✅ Model Loaded Successfully");
//       await _classifyImage(widget.imagePath);
//     } catch (e) {
//       print("❌ Model Load Error: $e");
//       await flutterTts.speak("Model could not be loaded.");
//     }
//   }
//
//   Future<void> _classifyImage(String imagePath) async {
//     output = await Tflite.runModelOnImage(
//       path: imagePath,
//       numResults: 7,
//       threshold: 0.2,
//       imageMean: 0,
//       imageStd: 255,
//       asynch: true,
//     );
//
//     print("Raw Output: $output");
//
//     if (output != null && output!.isNotEmpty) {
//       String rawLabel = output![0]["label"];
//
//       // Remove numeric prefix: "0 500_front" → "500_front"
//       String cleanLabel = rawLabel.replaceFirst(RegExp(r'^\d+\s+'), '');
//
//       print("🎯 Clean Label: $cleanLabel");
//       await _speak(cleanLabel);
//     } else {
//       await _speak("No recognizable currency note found.");
//     }
//   }
//
//   Future<void> _speak(String text) async {
//     await flutterTts.setSpeechRate(0.85);
//     await flutterTts.setPitch(1.0);
//     await flutterTts.awaitSpeakCompletion(true);
//     await flutterTts.speak(text);
//   }
//
//   @override
//   void dispose() {
//     Tflite.close();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Detected Currency')),
//       body: Center(
//         child: Image.file(File(widget.imagePath)),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite_v2/tflite_v2.dart';

class CurrencyScreen extends StatefulWidget {
  final CameraDescription camera;

  const CurrencyScreen({super.key, required this.camera});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _tts.setLanguage("en-US");
      await _tts.awaitSpeakCompletion(true);
      await _tts.speak(
        "You are now in the Currency Detection screen. "
            "Tap the camera button to capture a note.",
      );
    });
  }

  @override
  void dispose() {
    _tts.stop();
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await _tts.stop();
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Noteify – Currency')),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await _tts.stop();
              await Future.delayed(const Duration(milliseconds: 100));
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              XFile picture = await _controller.takePicture();

              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CurrencyResultScreen(imagePath: picture.path),
                ),
              );
            } catch (e) {
              print('Error taking picture: $e');
            }
          },
          child: const Icon(Icons.camera_alt, size: 40),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Result Screen
// ------------------------------------------------------------
class CurrencyResultScreen extends StatefulWidget {
  final String imagePath;

  const CurrencyResultScreen({super.key, required this.imagePath});

  @override
  State<CurrencyResultScreen> createState() => _CurrencyResultScreenState();
}

class _CurrencyResultScreenState extends State<CurrencyResultScreen> {
  final FlutterTts flutterTts = FlutterTts();
  List? output;

  @override
  void initState() {
    super.initState();
    _loadModelAndClassify();
  }

  Future<void> _loadModelAndClassify() async {
    try {
      await Tflite.loadModel(
        model: "assets/new.tflite",
        labels: "assets/newlabels.txt",
      );

      print("✅ Model Loaded Successfully");
      await _classifyImage(widget.imagePath);
    } catch (e) {
      print("❌ Model Load Error: $e");
      await flutterTts.speak("Model could not be loaded.");
    }
  }

  Future<void> _classifyImage(String imagePath) async {
    output = await Tflite.runModelOnImage(
      path: imagePath,
      numResults: 7,
      threshold: 0.2,
      imageMean: 0,
      imageStd: 255,
      asynch: true,
    );

    print("Raw Output: $output");

    if (output != null && output!.isNotEmpty) {
      String rawLabel = output![0]["label"];

      // Remove numeric prefix: "0 500_front" → "500_front"
      String cleanLabel = rawLabel.replaceFirst(RegExp(r'^\d+\s+'), '');

      print("🎯 Clean Label: $cleanLabel");
      await _speak(cleanLabel);
    } else {
      await _speak("No recognizable currency note found.");
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.setSpeechRate(0.85);
    await flutterTts.setPitch(1.0);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    Tflite.close();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await flutterTts.stop();
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detected Currency'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await flutterTts.stop();
              await Future.delayed(const Duration(milliseconds: 100));
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Center(
          child: Image.file(File(widget.imagePath)),
        ),
      ),
    );
  }
}
