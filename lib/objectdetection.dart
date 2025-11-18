// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:tflite_v2/tflite_v2.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'pages/home_page.dart';
// import 'pages/ocr.dart';
// import 'package:objectde/currency.dart';
//
//
// class ObjectDetectionScreen extends StatefulWidget {
//   const ObjectDetectionScreen({super.key});
//
//   @override
//   _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
// }
//
// class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
//   CameraController? _cameraController;
//   bool _isDetecting = false;
//   List<dynamic>? _recognitions;
//   final FlutterTts flutterTts = FlutterTts();
//
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions().then((granted) {
//       if (granted) {
//         _initializeCamera();
//         _loadModel();
//       } else {
//         // Handle the case where permissions are not granted
//         print("Permissions not granted");
//       }
//     });
//   }
//
//   Future<bool> requestPermissions() async {
//     var cameraStatus = await Permission.camera.status;
//     var microphoneStatus = await Permission.microphone.status;
//
//     if (!cameraStatus.isGranted) {
//       cameraStatus = await Permission.camera.request();
//     }
//
//     if (!microphoneStatus.isGranted) {
//       microphoneStatus = await Permission.microphone.request();
//     }
//
//     return cameraStatus.isGranted && microphoneStatus.isGranted;
//   }
//
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;
//
//     _cameraController = CameraController(
//       firstCamera,
//       ResolutionPreset.high,
//       enableAudio: false,
//     );
//
//     await _cameraController!.initialize();
//
//     _cameraController!.startImageStream((CameraImage image) {
//       if (!_isDetecting) {
//         _isDetecting = true;
//
//         _runModelOnFrame(image).then((recognitions) {
//           setState(() {
//             _recognitions = recognitions;
//           });
//
//           if (_recognitions != null && _recognitions!.isNotEmpty) {
//             String detectedObjects = _recognitions!
//                 .map((recognition) => recognition["detectedClass"])
//                 .join(", ");
//
//             speak(detectedObjects);
//           }
//
//           _isDetecting = false;
//         });
//       }
//     });
//   }
//
//   Future<void> _loadModel() async {
//     await Tflite.loadModel(
//       // model: "assets/ssd_mobilenet.tflite",
//       model: "assets/currency.tflite",
//       labels: "assets/currency.txt",
//       // labels: "assets/ssd_mobilenet.txt",
//       numThreads: 1,
//       isAsset: true,
//       useGpuDelegate: false,
//     );
//   }
//
//   Future<List<dynamic>?> _runModelOnFrame(CameraImage image) async {
//     final recognitions = await Tflite.detectObjectOnFrame(
//       bytesList: image.planes.map((plane) => plane.bytes).toList(),
//       imageHeight: image.height,
//       imageWidth: image.width,
//       imageMean: 127.5,
//       imageStd: 127.5,
//       rotation: 90,
//       numResultsPerClass: 2,
//       threshold: 0.1,
//       asynch: true,
//     );
//
//     return recognitions?.where((recognition) {
//       return recognition["confidenceInClass"] >= 0.7;
//     }).toList();
//   }
//
//   Future<void> speak(String text) async {
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setPitch(1.0);
//     await flutterTts.speak(text);
//   }
//
//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     Tflite.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Object Detection'),
//
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () async {
//             await _cameraController?.dispose(); // Safely dispose the camera
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const HomePage()),
//             );
//           },
//         ),
//
//       ),
//
//
//       body: GestureDetector(
//         onDoubleTap: () async {
//           await _cameraController?.dispose(); // Dispose camera before leaving
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const OCRPage()),
//             // MaterialPageRoute(builder: (context) => const MyHomePage()),
//           );
//         },
//         child: Stack(
//           children: [
//             _cameraController == null
//                 ? const Center(child: CircularProgressIndicator())
//                 : CameraPreview(_cameraController!),
//             _buildRecognitionWidgets(),
//           ],
//         ),
//       ),
//
//     );
//   }
//
//   Widget _buildRecognitionWidgets() {
//     if (_recognitions == null) return Container();
//
//     return Stack(
//       children: _recognitions!.map((recognition) {
//         return Positioned(
//           left: recognition["rect"]["x"] * MediaQuery.of(context).size.width,
//           top: recognition["rect"]["y"] * MediaQuery.of(context).size.height,
//           width: recognition["rect"]["w"] * MediaQuery.of(context).size.width,
//           height: recognition["rect"]["h"] * MediaQuery.of(context).size.height,
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.red,
//                 width: 2.0,
//               ),
//             ),
//             child: Text(
//               "${recognition["detectedClass"]} ${(recognition["confidenceInClass"] * 100).toStringAsFixed(0)}%",
//               style: const TextStyle(
//                 backgroundColor: Colors.red,
//                 color: Colors.white,
//                 fontSize: 14.0,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }


//













// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:tflite_v2/tflite_v2.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'pages/home_page.dart';
// import 'pages/ocr.dart';
//
// class ObjectDetectionScreen extends StatefulWidget {
//   const ObjectDetectionScreen({super.key});
//
//   @override
//   _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
// }
//
// class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
//   CameraController? _cameraController;
//   bool _isDetecting = false;
//   List<dynamic>? _recognitions;
//   final FlutterTts flutterTts = FlutterTts();
//   bool _isDisposed = false; // Track if disposed
//
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions().then((granted) {
//       if (granted) {
//         _initializeCamera();
//         _loadModel();
//       } else {
//         debugPrint("Permissions not granted");
//       }
//     });
//   }
//
//   Future<bool> requestPermissions() async {
//     var cameraStatus = await Permission.camera.status;
//     var microphoneStatus = await Permission.microphone.status;
//
//     if (!cameraStatus.isGranted) {
//       cameraStatus = await Permission.camera.request();
//     }
//
//     if (!microphoneStatus.isGranted) {
//       microphoneStatus = await Permission.microphone.request();
//     }
//
//     return cameraStatus.isGranted && microphoneStatus.isGranted;
//   }
//
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;
//
//     _cameraController = CameraController(
//       firstCamera,
//       ResolutionPreset.high,
//       enableAudio: false,
//     );
//
//     await _cameraController!.initialize();
//
//     if (!mounted || _isDisposed) return;
//
//     _cameraController!.startImageStream((CameraImage image) {
//       if (!_isDetecting && !_isDisposed) {
//         _isDetecting = true;
//
//         _runModelOnFrame(image).then((recognitions) {
//           if (mounted && !_isDisposed) {
//             setState(() {
//               _recognitions = recognitions;
//             });
//
//             if (_recognitions != null && _recognitions!.isNotEmpty) {
//               String detectedObjects = _recognitions!
//                   .map((recognition) => recognition["detectedClass"])
//                   .join(", ");
//               speak(detectedObjects);
//             }
//           }
//
//           _isDetecting = false;
//         });
//       }
//     });
//   }
//
//   Future<void> _loadModel() async {
//     await Tflite.loadModel(
//       model: "assets/ssd_mobilenet.tflite",
//       labels: "assets/ssd_mobilenet.txt",
//       numThreads: 1,
//       isAsset: true,
//       useGpuDelegate: false,
//     );
//   }
//
//   Future<List<dynamic>?> _runModelOnFrame(CameraImage image) async {
//     final recognitions = await Tflite.detectObjectOnFrame(
//       bytesList: image.planes.map((plane) => plane.bytes).toList(),
//       imageHeight: image.height,
//       imageWidth: image.width,
//       imageMean: 127.5,
//       imageStd: 127.5,
//       rotation: 90,
//       numResultsPerClass: 2,
//       threshold: 0.1,
//       asynch: true,
//     );
//
//     return recognitions?.where((recognition) {
//       return recognition["confidenceInClass"] >= 0.7;
//     }).toList();
//   }
//
//   Future<void> speak(String text) async {
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setPitch(1.0);
//     await flutterTts.speak(text);
//   }
//
//   Future<void> _disposeCamera() async {
//     if (_isDisposed) return;
//     _isDisposed = true;
//     try {
//       await _cameraController?.stopImageStream();
//     } catch (_) {}
//     await _cameraController?.dispose();
//   }
//
//   @override
//   void dispose() {
//     _disposeCamera();
//     Tflite.close();
//     super.dispose();
//   }
//
//   Future<bool> _onWillPop() async {
//     await _disposeCamera();
//     return true; // Allow navigation to proceed
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: const Text('Object Detection'),
//           backgroundColor: Colors.deepPurple,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               await _disposeCamera();
//               if (mounted) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const HomePage()),
//                 );
//               }
//             },
//           ),
//         ),
//         body: GestureDetector(
//           onDoubleTap: () async {
//             await _disposeCamera();
//             if (mounted) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const OCRPage()),
//               );
//             }
//           },
//           child: Stack(
//             children: [
//               _cameraController == null
//                   ? const Center(child: CircularProgressIndicator())
//                   : CameraPreview(_cameraController!),
//               _buildRecognitionWidgets(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRecognitionWidgets() {
//     if (_recognitions == null) return Container();
//
//     return Stack(
//       children: _recognitions!.map((recognition) {
//         return Positioned(
//           left: recognition["rect"]["x"] * MediaQuery.of(context).size.width,
//           top: recognition["rect"]["y"] * MediaQuery.of(context).size.height,
//           width: recognition["rect"]["w"] * MediaQuery.of(context).size.width,
//           height: recognition["rect"]["h"] * MediaQuery.of(context).size.height,
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.red, width: 2.0),
//             ),
//             child: Text(
//               "${recognition["detectedClass"]} ${(recognition["confidenceInClass"] * 100).toStringAsFixed(0)}%",
//               style: const TextStyle(
//                 backgroundColor: Colors.red,
//                 color: Colors.white,
//
//                 fontSize: 14.0,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'pages/home_page.dart';
import 'pages/ocr.dart';

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({super.key});

  @override
  _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  CameraController? _cameraController;
  bool _isDetecting = false;
  List<dynamic>? _recognitions;
  final FlutterTts flutterTts = FlutterTts();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _speakScreenEntry(); // ✅ Added: TTS when user enters Object Detection screen
    requestPermissions().then((granted) {
      if (granted) {
        _initializeCamera();
        _loadModel();
      } else {
        debugPrint("Permissions not granted");
      }
    });
  }

  // ✅ Added: TTS when this screen opens
  Future<void> _speakScreenEntry() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak("You are in the Object Detection screen");
  }

  Future<bool> requestPermissions() async {
    var cameraStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;

    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
    }

    if (!microphoneStatus.isGranted) {
      microphoneStatus = await Permission.microphone.request();
    }

    return cameraStatus.isGranted && microphoneStatus.isGranted;
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    if (!mounted || _isDisposed) return;

    _cameraController!.startImageStream((CameraImage image) {
      if (!_isDetecting && !_isDisposed) {
        _isDetecting = true;

        _runModelOnFrame(image).then((recognitions) {
          if (mounted && !_isDisposed) {
            setState(() {
              _recognitions = recognitions;
            });

            if (_recognitions != null && _recognitions!.isNotEmpty) {
              String detectedObjects = _recognitions!
                  .map((recognition) => recognition["detectedClass"])
                  .join(", ");
              speak(detectedObjects);
            }
          }

          _isDetecting = false;
        });
      }
    });
  }

  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/ssd_mobilenet.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  Future<List<dynamic>?> _runModelOnFrame(CameraImage image) async {
    final recognitions = await Tflite.detectObjectOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResultsPerClass: 2,
      threshold: 0.1,
      asynch: true,
    );

    return recognitions?.where((recognition) {
      return recognition["confidenceInClass"] >= 0.7;
    }).toList();
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  Future<void> _disposeCamera() async {
    if (_isDisposed) return;
    _isDisposed = true;
    try {
      await _cameraController?.stopImageStream();
    } catch (_) {}
    await _cameraController?.dispose();
  }

  @override
  void dispose() {
    _disposeCamera();
    Tflite.close();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await _disposeCamera();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Object Detection'),
          backgroundColor: Colors.deepPurple,
          // ✅ FIXED: Back arrow now acts like the phone back button (Navigator.pop instead of pushReplacement)
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await _disposeCamera();
              if (mounted) {
                Navigator.pop(context); // ✅ Changed from pushReplacement to pop()
              }
            },
          ),
        ),
        body: GestureDetector(
          onDoubleTap: () async {
            await _disposeCamera();
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const OCRPage()),
              );
            }
          },
          child: Stack(
            children: [
              _cameraController == null
                  ? const Center(child: CircularProgressIndicator())
                  : CameraPreview(_cameraController!),
              _buildRecognitionWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecognitionWidgets() {
    if (_recognitions == null) return Container();

    return Stack(
      children: _recognitions!.map((recognition) {
        return Positioned(
          left: recognition["rect"]["x"] * MediaQuery.of(context).size.width,
          top: recognition["rect"]["y"] * MediaQuery.of(context).size.height,
          width: recognition["rect"]["w"] * MediaQuery.of(context).size.width,
          height: recognition["rect"]["h"] * MediaQuery.of(context).size.height,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2.0),
            ),
            child: Text(
              "${recognition["detectedClass"]} ${(recognition["confidenceInClass"] * 100).toStringAsFixed(0)}%",
              style: const TextStyle(
                backgroundColor: Colors.red,
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

