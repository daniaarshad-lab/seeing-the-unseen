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



// ***WAHAJ WALA BACKUP***
//
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
//     _tts.stop();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Future<bool> _onWillPop() async {
//     await _tts.stop();
//     await Future.delayed(const Duration(milliseconds: 100));
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Center(child: Text('Noteify – Currency')),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               await _tts.stop();
//               await Future.delayed(const Duration(milliseconds: 100));
//               if (mounted) {
//                 Navigator.pop(context);
//               }
//             },
//           ),
//         ),
//         body: FutureBuilder<void>(
//           future: _initializeControllerFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               return CameraPreview(_controller);
//             } else {
//               return const Center(child: CircularProgressIndicator());
//             }
//           },
//         ),
//         floatingActionButton: FloatingActionButton.large(
//           onPressed: () async {
//             try {
//               await _initializeControllerFuture;
//               XFile picture = await _controller.takePicture();
//
//               if (!mounted) return;
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       CurrencyResultScreen(imagePath: picture.path),
//                 ),
//               );
//             } catch (e) {
//               print('Error taking picture: $e');
//             }
//           },
//           child: const Icon(Icons.camera_alt, size: 40),
//         ),
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
//     flutterTts.stop();
//     Tflite.close();
//     super.dispose();
//   }
//
//   Future<bool> _onWillPop() async {
//     await flutterTts.stop();
//     await Future.delayed(const Duration(milliseconds: 100));
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Detected Currency'),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               await flutterTts.stop();
//               await Future.delayed(const Duration(milliseconds: 100));
//               if (mounted) {
//                 Navigator.pop(context);
//               }
//             },
//           ),
//         ),
//         body: Center(
//           child: Image.file(File(widget.imagePath)),
//         ),
//       ),
//     );
//   }
// }

// ****BETTER****

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:tflite_v2/tflite_v2.dart';
//
// // import your HomeScreen widget
// import 'package:objectde/home_screen.dart'; // adjust path if needed
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
//   final FlutterTts _tts = FlutterTts();
//   bool isDetecting = false;
//   List? recognitions;
//
//   // Stability + debounce
//   final List<String> _recentLabels = [];
//   String? _stableLabel;
//   String? _lastSpokenLabel;
//   DateTime _lastSpeechTime = DateTime.fromMillisecondsSinceEpoch(0);
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.camera, ResolutionPreset.high);
//     _controller.initialize().then((_) {
//       if (!mounted) return;
//       setState(() {});
//       _startDetection();
//     });
//
//     _loadModel();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _tts.setLanguage("en-US");
//       await _tts.awaitSpeakCompletion(true);
//       await _tts.speak("Currency detection is active. Show a note to detect.");
//     });
//   }
//
//   Future<void> _loadModel() async {
//     await Tflite.loadModel(
//       model: "assets/new.tflite",
//       labels: "assets/newlabels.txt",
//     );
//   }
//
//   void _startDetection() {
//     _controller.startImageStream((CameraImage image) {
//       if (isDetecting) return;
//       isDetecting = true;
//
//       Tflite.runModelOnFrame(
//         bytesList: image.planes.map((plane) => plane.bytes).toList(),
//         imageHeight: image.height,
//         imageWidth: image.width,
//         imageMean: 127.5,
//         imageStd: 127.5,
//         rotation: 90,
//         numResults: 2,
//         threshold: 0.95, // very strict confidence
//       ).then((results) async {
//         setState(() {
//           recognitions = results ?? [];
//         });
//
//         if (results != null && results.isNotEmpty) {
//           final best = results.first;
//           final label = best["label"];
//           final confidence = best["confidence"];
//
//           if (confidence >= 0.95) {
//             // Add to sliding window
//             _recentLabels.add(label);
//             if (_recentLabels.length > 8) _recentLabels.removeAt(0);
//
//             // Count occurrences
//             int count = _recentLabels.where((l) => l == label).length;
//             bool stable = count >= 6;
//
//             if (stable && _stableLabel != label) {
//               _stableLabel = label;
//
//               // Debounce speech
//               final now = DateTime.now();
//               if (_lastSpokenLabel != label &&
//                   now.difference(_lastSpeechTime) > const Duration(seconds: 2)) {
//                 _lastSpokenLabel = label;
//                 _lastSpeechTime = now;
//                 await _tts.speak(label);
//               }
//             }
//           } else {
//             // Case 2: note detected but not properly placed
//             if (_lastSpokenLabel != "Place the note correctly") {
//               _lastSpokenLabel = "Place the note correctly";
//               await _tts.speak("Place the note correctly in front of camera");
//             }
//           }
//         } else {
//           // Case 1: no note at all
//           if (_lastSpokenLabel != "Put the camera towards note") {
//             _lastSpokenLabel = "Put the camera towards note";
//             await _tts.speak("Put the camera towards the note");
//           }
//         }
//
//         Future.delayed(const Duration(milliseconds: 300), () {
//           isDetecting = false;
//         });
//       }).catchError((_) {
//         isDetecting = false;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _tts.stop();
//     _controller.stopImageStream();
//     _controller.dispose();
//     Tflite.close();
//     super.dispose();
//   }
//
//   Future<bool> _onWillPop() async {
//     await _tts.stop();
//     await Future.delayed(const Duration(milliseconds: 100));
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const HomeScreen()),
//     );
//     return false; // prevent closing app
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Center(child: Text('Noteify – Currency')),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               await _tts.stop();
//               await Future.delayed(const Duration(milliseconds: 100));
//               if (mounted) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => const HomeScreen()),
//                 );
//               }
//             },
//           ),
//         ),
//         body: _controller.value.isInitialized
//             ? Stack(
//           children: [
//             CameraPreview(_controller),
//             Positioned(
//               bottom: 20,
//               left: 20,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: recognitions?.map((res) {
//                   return Text(
//                     "${res["label"]} - ${res["confidence"] != null ? (res["confidence"] * 100).toStringAsFixed(0) + "%" : ""}",
//                     style: const TextStyle(
//                       backgroundColor: Colors.black54,
//                       color: Colors.white,
//                       fontSize: 20,
//                     ),
//                   );
//                 }).toList() ??
//                     [],
//               ),
//             )
//           ],
//         )
//             : const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }
//
//


// ******SELECTED HAI YAA UNI WALA *****

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:tflite_v2/tflite_v2.dart';
//
// // import your HomeScreen widget
// import 'package:objectde/home_screen.dart'; // adjust path if needed
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
//   final FlutterTts _tts = FlutterTts();
//   bool isDetecting = false;
//   List? recognitions;
//   String? lastSpokenLabel;
//   DateTime _lastSpeechTime = DateTime.fromMillisecondsSinceEpoch(0);
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.camera, ResolutionPreset.high);
//     _controller.initialize().then((_) {
//       if (!mounted) return;
//       setState(() {});
//       _startDetection();
//     });
//
//     _loadModel();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _tts.setLanguage("en-US");
//       await _tts.awaitSpeakCompletion(true);
//       await _tts.speak("Currency detection is active. Show a note to detect.");
//     });
//   }
//
//   Future<void> _loadModel() async {
//     await Tflite.loadModel(
//       model: "assets/new.tflite",
//       labels: "assets/newlabels.txt",
//     );
//   }
//
//   void _startDetection() {
//     _controller.startImageStream((CameraImage image) {
//       if (isDetecting) return;
//       isDetecting = true;
//
//       Tflite.runModelOnFrame(
//         bytesList: image.planes.map((plane) => plane.bytes).toList(),
//         imageHeight: image.height,
//         imageWidth: image.width,
//         imageMean: 127.5,
//         imageStd: 127.5,
//         rotation: 90,
//         numResults: 2,
//         threshold: 0.85, // stricter confidence
//       ).then((results) async {
//         setState(() {
//           recognitions = results ?? [];
//         });
//
//         if (results != null && results.isNotEmpty) {
//           final best = results.first;
//           final label = best["label"];
//           final confidence = best["confidence"];
//
//           // ✅ Only speak if confidence is high enough
//           if (confidence > 0.85 && lastSpokenLabel != label) {
//             final now = DateTime.now();
//             if (now.difference(_lastSpeechTime) > const Duration(seconds: 2)) {
//               lastSpokenLabel = label;
//               _lastSpeechTime = now;
//               await _tts.speak(label);
//             }
//           }
//         } else {
//           // ❌ No note detected → stay silent, just clear recognitions
//           setState(() {
//             recognitions = [];
//           });
//         }
//
//         Future.delayed(const Duration(milliseconds: 300), () {
//           isDetecting = false;
//         });
//       }).catchError((_) {
//         isDetecting = false;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _tts.stop();
//     _controller.stopImageStream();
//     _controller.dispose();
//     Tflite.close();
//     super.dispose();
//   }
//
//   Future<bool> _onWillPop() async {
//     await _tts.stop();
//     await Future.delayed(const Duration(milliseconds: 100));
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const HomeScreen()),
//     );
//     return false; // prevent closing app
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Center(child: Text('Noteify – Currency')),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               await _tts.stop();
//               await Future.delayed(const Duration(milliseconds: 100));
//               if (mounted) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => const HomeScreen()),
//                 );
//               }
//             },
//           ),
//         ),
//         body: _controller.value.isInitialized
//             ? Stack(
//           children: [
//             CameraPreview(_controller),
//             Positioned(
//               bottom: 20,
//               left: 20,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: recognitions?.map((res) {
//                   return Text(
//                     "${res["label"]} - ${res["confidence"] != null ? (res["confidence"] * 100).toStringAsFixed(0) + "%" : ""}",
//                     style: const TextStyle(
//                       backgroundColor: Colors.black54,
//                       color: Colors.white,
//                       fontSize: 20,
//                     ),
//                   );
//                 }).toList() ??
//                     [],
//               ),
//             )
//           ],
//         )
//             : const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }

// ****YA WALA BHI SAHI HAI YAR****

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:tflite_v2/tflite_v2.dart';
//
// // import your HomeScreen widget
// import 'package:objectde/home_screen.dart'; // adjust path if needed
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
//   final FlutterTts _tts = FlutterTts();
//   bool isDetecting = false;
//   List? recognitions;
//
//   // Stability + debounce
//   final List<String> _recentLabels = [];
//   String? _stableLabel;
//   String? _lastSpokenLabel;
//   DateTime _lastSpeechTime = DateTime.fromMillisecondsSinceEpoch(0);
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.camera, ResolutionPreset.high);
//     _controller.initialize().then((_) {
//       if (!mounted) return;
//       setState(() {});
//       _startDetection();
//     });
//
//     _loadModel();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _tts.setLanguage("en-US");
//       await _tts.awaitSpeakCompletion(true);
//       await _tts.speak("Currency detection is active. Show a note to detect.");
//     });
//   }
//
//   Future<void> _loadModel() async {
//     await Tflite.loadModel(
//       model: "assets/new.tflite",
//       labels: "assets/newlabels.txt",
//     );
//   }
//
//   void _startDetection() {
//     _controller.startImageStream((CameraImage image) {
//       if (isDetecting) return;
//       isDetecting = true;
//
//       Tflite.runModelOnFrame(
//         bytesList: image.planes.map((plane) => plane.bytes).toList(),
//         imageHeight: image.height,
//         imageWidth: image.width,
//         imageMean: 127.5,
//         imageStd: 127.5,
//         rotation: 90,
//         numResults: 2,
//         threshold: 0.95, // very strict confidence
//       ).then((results) async {
//         setState(() {
//           recognitions = results ?? [];
//         });
//
//         if (results != null && results.isNotEmpty) {
//           final best = results.first;
//           final label = best["label"];
//           final confidence = best["confidence"];
//
//           if (confidence >= 0.95) {
//             // Add to sliding window
//             _recentLabels.add(label);
//             if (_recentLabels.length > 8) _recentLabels.removeAt(0);
//
//             // Count occurrences
//             int count = _recentLabels.where((l) => l == label).length;
//             bool stable = count >= 6;
//
//             if (stable && _stableLabel != label) {
//               _stableLabel = label;
//
//               // Debounce speech
//               final now = DateTime.now();
//               if (_lastSpokenLabel != label &&
//                   now.difference(_lastSpeechTime) > const Duration(seconds: 2)) {
//                 _lastSpokenLabel = label;
//                 _lastSpeechTime = now;
//                 await _tts.speak(label);
//               }
//             }
//           }
//         } else {
//           // No results → clear recognitions, stay silent
//           setState(() {
//             recognitions = [];
//           });
//         }
//
//         Future.delayed(const Duration(milliseconds: 300), () {
//           isDetecting = false;
//         });
//       }).catchError((_) {
//         isDetecting = false;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _tts.stop();
//     _controller.stopImageStream();
//     _controller.dispose();
//     Tflite.close();
//     super.dispose();
//   }
//
//   Future<bool> _onWillPop() async {
//     await _tts.stop();
//     await Future.delayed(const Duration(milliseconds: 100));
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const HomeScreen()),
//     );
//     return false; // prevent closing app
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Center(child: Text('Noteify – Currency')),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               await _tts.stop();
//               await Future.delayed(const Duration(milliseconds: 100));
//               if (mounted) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => const HomeScreen()),
//                 );
//               }
//             },
//           ),
//         ),
//         body: _controller.value.isInitialized
//             ? Stack(
//           children: [
//             CameraPreview(_controller),
//             Positioned(
//               bottom: 20,
//               left: 20,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: recognitions?.map((res) {
//                   return Text(
//                     "${res["label"]} - ${res["confidence"] != null ? (res["confidence"] * 100).toStringAsFixed(0) + "%" : ""}",
//                     style: const TextStyle(
//                       backgroundColor: Colors.black54,
//                       color: Colors.white,
//                       fontSize: 20,
//                     ),
//                   );
//                 }).toList() ??
//                     [],
//               ),
//             )
//           ],
//         )
//             : const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }


//********camera wala***

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:tflite_v2/tflite_v2.dart';
// import 'package:flutter/services.dart';
//
// // Replace this with your actual main menu route
// const String mainMenuRoute = '/main_menu';
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
//   bool hasSpoken = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.camera, ResolutionPreset.high);
//     _initializeControllerFuture = _controller.initialize();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _tts.setLanguage("en-US");
//       await _tts.awaitSpeakCompletion(true);
//       await _speakOnce(
//         "You are now in the Currency Detection screen. Tap the camera icon to capture a note.",
//       );
//     });
//   }
//
//   Future<void> _speakOnce(String text) async {
//     if (!hasSpoken) {
//       await _tts.speak(text);
//       hasSpoken = true;
//     }
//   }
//
//   @override
//   void dispose() {
//     _tts.stop();
//     _controller.dispose();
//     Tflite.close();
//     super.dispose();
//   }
//
//   Future<bool> _onWillPop() async {
//     await _tts.stop();
//     // Navigate back to main menu
//     if (mounted) {
//       Navigator.of(context)
//           .pushNamedAndRemoveUntil(mainMenuRoute, (route) => false);
//     }
//     return true;
//   }
//
//   Future<void> _captureImage() async {
//     try {
//       await _initializeControllerFuture;
//       XFile picture = await _controller.takePicture();
//       if (!mounted) return;
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CurrencyResultScreen(imagePath: picture.path),
//         ),
//       );
//     } catch (e) {
//       print('Error taking picture: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: GestureDetector(
//         onTap: _captureImage, // Capture image on tap anywhere
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Noteify – Currency'),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: _onWillPop,
//             ),
//           ),
//           body: FutureBuilder<void>(
//             future: _initializeControllerFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return CameraPreview(_controller);
//               } else {
//                 return const Center(child: CircularProgressIndicator());
//               }
//             },
//           ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: _captureImage,
//             child: const Icon(Icons.camera_alt, size: 40),
//           ),
//           floatingActionButtonLocation:
//           FloatingActionButtonLocation.centerFloat,
//         ),
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
//   bool hasSpoken = false;
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
//       String cleanLabel = rawLabel.replaceFirst(RegExp(r'^\d+\s+'), '');
//       print("🎯 Clean Label: $cleanLabel");
//       await _speakOnce(cleanLabel);
//     } else {
//       await _speakOnce("No recognizable currency note found.");
//     }
//   }
//
//   Future<void> _speakOnce(String text) async {
//     if (!hasSpoken) {
//       await flutterTts.setSpeechRate(0.85);
//       await flutterTts.setPitch(1.0);
//       await flutterTts.awaitSpeakCompletion(true);
//       await flutterTts.speak(text);
//       hasSpoken = true;
//     }
//   }
//
//   @override
//   void dispose() {
//     flutterTts.stop();
//     Tflite.close();
//     super.dispose();
//   }
//
//   Future<bool> _onWillPop() async {
//     await flutterTts.stop();
//     if (mounted) {
//       Navigator.of(context)
//           .pushNamedAndRemoveUntil(mainMenuRoute, (route) => false);
//     }
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Detected Currency'),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: _onWillPop,
//           ),
//         ),
//         body: Center(
//           child: Image.file(File(widget.imagePath)),
//         ),
//       ),
//     );
//   }
// }


// ****SELETECTED ONE FINAL ****
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:tflite_v2/tflite_v2.dart';
// import 'package:flutter/services.dart';
//
// // Replace this with your actual main menu route
// const String mainMenuRoute = '/main_menu';
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
//   bool hasSpoken = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.camera, ResolutionPreset.high);
//     _initializeControllerFuture = _controller.initialize();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _tts.setLanguage("en-US");
//       await _tts.awaitSpeakCompletion(true);
//       await _speakOnce(
//         "You are now in the Currency Detection screen. Tap the camera icon to capture a note.",
//       );
//     });
//   }
//
//   Future<void> _speakOnce(String text) async {
//     if (!hasSpoken) {
//       await _tts.speak(text);
//       hasSpoken = true;
//     }
//   }
//
//   @override
//   void dispose() {
//     _tts.stop();
//     _controller.dispose();
//     Tflite.close();
//     super.dispose();
//   }
//
//   Future<bool> _onWillPop() async {
//     await _tts.stop();
//     if (mounted) {
//       // Simply pop back to the previous screen (your actual main menu)
//       Navigator.pop(context);
//     }
//     return false; // prevent closing the app
//   }
//
//   Future<void> _captureImage() async {
//     try {
//       await _initializeControllerFuture;
//       XFile picture = await _controller.takePicture();
//       if (!mounted) return;
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CurrencyResultScreen(imagePath: picture.path),
//         ),
//       );
//     } catch (e) {
//       print('Error taking picture: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: GestureDetector(
//         onTap: _captureImage, // Capture image on tap anywhere
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Currency Detection'),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () async {
//                 await _tts.stop();
//                 if (mounted) {
//                   Navigator.pop(context); // go back to actual main menu
//                 }
//               },
//             ),
//           ),
//           body: FutureBuilder<void>(
//             future: _initializeControllerFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return CameraPreview(_controller);
//               } else {
//                 return const Center(child: CircularProgressIndicator());
//               }
//             },
//           ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: _captureImage,
//             child: const Icon(Icons.camera_alt, size: 40),
//           ),
//           floatingActionButtonLocation:
//           FloatingActionButtonLocation.centerFloat,
//         ),
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
//   bool hasSpoken = false;
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
//       String cleanLabel = rawLabel.replaceFirst(RegExp(r'^\d+\s+'), '');
//       print("🎯 Clean Label: $cleanLabel");
//       await _speakOnce(cleanLabel);
//     } else {
//       await _speakOnce("No recognizable currency note found.");
//     }
//   }
//
//   Future<void> _speakOnce(String text) async {
//     if (!hasSpoken) {
//       await flutterTts.setSpeechRate(0.85);
//       await flutterTts.setPitch(1.0);
//       await flutterTts.awaitSpeakCompletion(true);
//       await flutterTts.speak(text);
//       hasSpoken = true;
//     }
//   }
//
//   @override
//   void dispose() {
//     flutterTts.stop();
//     Tflite.close();
//     super.dispose();
//   }
//
//   Future<bool> _onWillPop() async {
//     await flutterTts.stop();
//     if (mounted) {
//       Navigator.pop(context); // go back to actual main menu
//     }
//     return false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Detected Currency'),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               await flutterTts.stop();
//               if (mounted) {
//                 Navigator.pop(context); // go back to actual main menu
//               }
//             },
//           ),
//         ),
//         body: Center(
//           child: Image.file(File(widget.imagePath)),
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:flutter/services.dart';

// Replace this with your actual main menu route
const String mainMenuRoute = '/main_menu';

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
  bool hasSpoken = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _tts.setLanguage("en-US");
      await _tts.setSpeechRate(0.55); // slower, clearer
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      await _tts.awaitSpeakCompletion(true);
      await _speakOnce(
        "You are now in the Currency Detection screen. Tap the camera icon or anywhere on the screen to capture a note.",
      );
    });
  }

  Future<void> _speakOnce(String text) async {
    if (!hasSpoken) {
      await _tts.stop(); // stop any ongoing speech
      await _tts.speak(text);
      hasSpoken = true;
    }
  }

  @override
  void dispose() {
    _tts.stop();
    _controller.dispose();
    Tflite.close();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await _tts.stop();
    if (mounted) {
      Navigator.pop(context); // go back to actual main menu
    }
    return false;
  }

  Future<void> _captureImage() async {
    try {
      await _initializeControllerFuture;
      XFile picture = await _controller.takePicture();
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CurrencyResultScreen(imagePath: picture.path),
        ),
      );
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: _captureImage,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Currency Detection'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                await _tts.stop();
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
          floatingActionButton: FloatingActionButton(
            onPressed: _captureImage,
            child: const Icon(Icons.camera_alt, size: 40),
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
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
  bool hasSpoken = false;

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
      double confidence = (output![0]["confidence"] ?? 0.0) as double;

      String cleanLabel = rawLabel.replaceFirst(RegExp(r'^\d+\s+'), '');
      print("🎯 Clean Label: $cleanLabel (conf: $confidence)");

      // NEW BEHAVIOR: if confidence is too low or label looks invalid
      if (confidence < 0.7 || cleanLabel.toLowerCase().contains("unknown")) {
        await _speakOnce("Place the note in front of camera and click again.");
      } else {
        await _speakOnce(cleanLabel);
      }
    } else {
      // No results at all
      await _speakOnce("Place the note in front of camera and click again.");
    }
  }

  Future<void> _speakOnce(String text) async {
    if (!hasSpoken) {
      await flutterTts.stop();
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.55); // slower, clearer
      await flutterTts.setPitch(1.0);
      await flutterTts.setVolume(1.0);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(text);
      hasSpoken = true;
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    Tflite.close();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await flutterTts.stop();
    if (mounted) {
      Navigator.pop(context);
    }
    return false;
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
