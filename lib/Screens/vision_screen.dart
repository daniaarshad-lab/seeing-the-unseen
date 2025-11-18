// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:http/http.dart' as http;
//
// class VisionScreen extends StatefulWidget {
//   const VisionScreen({super.key});
//
//   @override
//   State<VisionScreen> createState() => _VisionScreenState();
// }
//
// class _VisionScreenState extends State<VisionScreen> {
//   CameraController? _cameraController;
//   List<CameraDescription>? _cameras;
//   bool _isLoading = false;
//   bool _isListening = false;
//   String _responseText = '';
//   final SpeechToText _speech = SpeechToText();
//   final FlutterTts _tts = FlutterTts();
//   String _userQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//   }
//
//   Future<void> _initCamera() async {
//     _cameras = await availableCameras();
//     if (_cameras != null && _cameras!.isNotEmpty) {
//       _cameraController = CameraController(
//         _cameras![0],
//         ResolutionPreset.medium,
//         enableAudio: false,
//       );
//       await _cameraController!.initialize();
//       setState(() {});
//     }
//   }
//
//   Future<void> _captureAndAsk() async {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) return;
//     setState(() => _isLoading = true);
//     try {
//       final image = await _cameraController!.takePicture();
//       final bytes = await image.readAsBytes();
//       final base64Image = base64Encode(bytes);
//
//       final res = await http.post(
//         // Uri.parse('http://192.168.1.6:8000/api/ask'),
//         Uri.parse('http://127.0.0.1:8000/api/ask'),
//         body: {
//           'prompt': _userQuery,
//           'image': base64Image,
//         },
//       );
//
//       final resp = json.decode(res.body);
//       setState(() => _responseText = resp['response'] ?? 'No response');
//       await _tts.speak(_responseText);
//     } catch (e) {
//       setState(() => _responseText = 'Error: $e');
//     }
//     setState(() => _isLoading = false);
//   }
//
//   Future<void> _toggleListening() async {
//     if (_isListening) {
//       // Stop listening and send query
//       await _speech.stop();
//       setState(() => _isListening = false);
//
//       if (_userQuery.isNotEmpty) {
//         await _captureAndAsk();
//       }
//     } else {
//       // Start listening
//       bool available = await _speech.initialize(
//         onError: (e) => setState(() => _responseText = 'Speech error: ${e.errorMsg}'),
//       );
//
//       if (available) {
//         setState(() {
//           _responseText = '';
//           _userQuery = '';
//           _isListening = true;
//         });
//
//         _speech.listen(
//           onResult: (result) {
//             setState(() => _userQuery = result.recognizedWords);
//           },
//         );
//       } else {
//         setState(() => _responseText = 'Speech recognition not available.');
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _speech.stop();
//     _tts.stop();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // 📷 Fullscreen camera
//           if (_cameraController != null && _cameraController!.value.isInitialized)
//             Positioned.fill(child: CameraPreview(_cameraController!)),
//
//           // 💬 Center text
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 _isLoading
//                     ? '⏳ Processing...'
//                     : _responseText.isNotEmpty
//                     ? _responseText
//                     : _userQuery.isNotEmpty
//                     ? 'You said: $_userQuery'
//                     : _isListening
//                     ? '🎤 Listening...'
//                     : 'Tap mic to start speaking',
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   shadows: [Shadow(blurRadius: 8, color: Colors.black)],
//                 ),
//               ),
//             ),
//           ),
//
//           // 🎙️ Mic button bottom center
//           Positioned(
//             bottom: 40,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: GestureDetector(
//                 onTap: _isLoading ? null : _toggleListening,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     color: _isListening
//                         ? Colors.red.withOpacity(0.5)
//                         : Colors.blue.withOpacity(0.4),
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 4),
//                   ),
//                   child: Icon(
//                     _isListening ? Icons.stop : Icons.mic,
//                     color: Colors.white,
//                     size: 60,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // 🔄 Loading indicator
//           if (_isLoading)
//             const Center(child: CircularProgressIndicator(color: Colors.white)),
//         ],
//       ),
//     );
//   }
// }




// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:http/http.dart' as http;
//
// class VisionScreen extends StatefulWidget {
//   const VisionScreen({super.key});
//
//   @override
//   State<VisionScreen> createState() => _VisionScreenState();
// }
//
// class _VisionScreenState extends State<VisionScreen> {
//   CameraController? _cameraController;
//   List<CameraDescription>? _cameras;
//   bool _isLoading = false;
//   bool _isListening = false;
//   String _responseText = '';
//   final SpeechToText _speech = SpeechToText();
//   final FlutterTts _tts = FlutterTts();
//   String _userQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//
//     // 🗣️ Added: Speak when the screen opens
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _tts.setLanguage("en-US");
//       await _tts.speak(
//           "You are now in the Vision screen. Tap the mic to ask about what you see.");
//     });
//   }
//
//   Future<void> _initCamera() async {
//     _cameras = await availableCameras();
//     if (_cameras != null && _cameras!.isNotEmpty) {
//       _cameraController = CameraController(
//         _cameras![0],
//         ResolutionPreset.medium,
//         enableAudio: false,
//       );
//       await _cameraController!.initialize();
//       setState(() {});
//     }
//   }
//
//   Future<void> _captureAndAsk() async {
//     if (_cameraController == null || !_cameraController!.value.isInitialized)
//       return;
//     setState(() => _isLoading = true);
//
//     try {
//       final image = await _cameraController!.takePicture();
//       final bytes = await image.readAsBytes();
//       final base64Image = base64Encode(bytes);
//
//       final res = await http.post(
//         // 👇 Use your own backend address if needed
//         Uri.parse('http://127.0.0.1:8000/api/ask'),
//         body: {
//           'prompt': _userQuery,
//           'image': base64Image,
//         },
//       );
//
//       final resp = json.decode(res.body);
//       setState(() => _responseText = resp['response'] ?? 'No response');
//       await _tts.speak(_responseText);
//     } catch (e) {
//       setState(() => _responseText = 'Error: $e');
//       await _tts.speak("Sorry, an error occurred while processing the image.");
//     }
//
//     setState(() => _isLoading = false);
//   }
//
//   Future<void> _toggleListening() async {
//     if (_isListening) {
//       // 🛑 Stop listening
//       await _speech.stop();
//       setState(() => _isListening = false);
//
//       if (_userQuery.isNotEmpty) {
//         await _captureAndAsk();
//       }
//     } else {
//       // 🎙️ Start listening
//       bool available = await _speech.initialize(
//         onError: (e) => setState(() => _responseText = 'Speech error: ${e.errorMsg}'),
//       );
//
//       if (available) {
//         setState(() {
//           _responseText = '';
//           _userQuery = '';
//           _isListening = true;
//         });
//
//         await _tts.speak("Listening... Please ask your question.");
//         _speech.listen(
//           onResult: (result) {
//             setState(() => _userQuery = result.recognizedWords);
//           },
//         );
//       } else {
//         setState(() => _responseText = 'Speech recognition not available.');
//         await _tts.speak("Speech recognition not available.");
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _speech.stop();
//     _tts.stop();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // 📷 Fullscreen camera
//           if (_cameraController != null && _cameraController!.value.isInitialized)
//             Positioned.fill(child: CameraPreview(_cameraController!)),
//
//           // 💬 Center text
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 _isLoading
//                     ? '⏳ Processing...'
//                     : _responseText.isNotEmpty
//                     ? _responseText
//                     : _userQuery.isNotEmpty
//                     ? 'You said: $_userQuery'
//                     : _isListening
//                     ? '🎤 Listening...'
//                     : 'Tap mic to start speaking',
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   shadows: [Shadow(blurRadius: 8, color: Colors.black)],
//                 ),
//               ),
//             ),
//           ),
//
//           // 🎙️ Mic button bottom center
//           Positioned(
//             bottom: 40,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: GestureDetector(
//                 onTap: _isLoading ? null : _toggleListening,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     color: _isListening
//                         ? Colors.red.withOpacity(0.5)
//                         : Colors.blue.withOpacity(0.4),
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 4),
//                   ),
//                   child: Icon(
//                     _isListening ? Icons.stop : Icons.mic,
//                     color: Colors.white,
//                     size: 60,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // 🔄 Loading indicator
//           if (_isLoading)
//             const Center(child: CircularProgressIndicator(color: Colors.white)),
//         ],
//       ),
//     );
//   }
// }




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

class VisionScreen extends StatefulWidget {
  const VisionScreen({super.key});

  @override
  State<VisionScreen> createState() => _VisionScreenState();
}

class _VisionScreenState extends State<VisionScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isLoading = false;
  bool _isListening = false;
  String _responseText = '';
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  String _userQuery = '';

  bool _pageActive = true; // <-- IMPORTANT FIX

  @override
  void initState() {
    super.initState();
    _initCamera();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _tts.setLanguage("en-US");
      if (_pageActive) {
        await _tts.speak(
            "You are now in the Vision screen. Tap the mic to ask about what you see.");
      }
    });
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      if (mounted) setState(() {});
    }
  }

  Future<void> _captureAndAsk() async {
    if (!_pageActive) return;

    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    setState(() => _isLoading = true);

    try {
      final image = await _cameraController!.takePicture();
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final res = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/ask'),
        body: {
          'prompt': _userQuery,
          'image': base64Image,
        },
      );

      if (!_pageActive) return;

      final resp = json.decode(res.body);
      setState(() => _responseText = resp['response'] ?? 'No response');

      await _tts.speak(_responseText);
    } catch (e) {
      if (!_pageActive) return;

      setState(() => _responseText = 'Error: $e');
      await _tts.speak("Sorry, an error occurred while processing the image.");
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _toggleListening() async {
    if (!_pageActive) return;

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);

      if (_userQuery.isNotEmpty) {
        await _captureAndAsk();
      }
    } else {
      bool available = await _speech.initialize(
        onError: (e) {
          if (mounted) {
            setState(() => _responseText = 'Speech error: ${e.errorMsg}');
          }
        },
      );

      if (available) {
        if (!_pageActive) return;

        setState(() {
          _responseText = '';
          _userQuery = '';
          _isListening = true;
        });

        await _tts.speak("Listening... Please ask your question.");

        _speech.listen(
          onResult: (result) {
            if (!_pageActive) return;

            setState(() => _userQuery = result.recognizedWords);
          },
        );
      } else {
        if (!_pageActive) return;

        setState(() => _responseText = 'Speech recognition not available.');
        await _tts.speak("Speech recognition not available.");
      }
    }
  }

  @override
  void dispose() {
    _pageActive = false;
    _speech.stop();
    _tts.stop();
    _cameraController?.dispose();
    super.dispose();
  }

  // -------- FIXED BACK BUTTON -------- //
  Future<bool> _onBackPressed() async {
    _pageActive = false;

    // STOP EVERYTHING BEFORE NAVIGATING BACK
    await _speech.stop();
    await _tts.stop();
    await _cameraController?.dispose();

    return true;  // allow pop
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,  // <-- FIXED
      child: Scaffold(
        body: Stack(
          children: [
            if (_cameraController != null &&
                _cameraController!.value.isInitialized)
              Positioned.fill(child: CameraPreview(_cameraController!)),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _isLoading
                      ? '⏳ Processing...'
                      : _responseText.isNotEmpty
                      ? _responseText
                      : _userQuery.isNotEmpty
                      ? 'You said: $_userQuery'
                      : _isListening
                      ? '🎤 Listening...'
                      : 'Tap mic to start speaking',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _isLoading ? null : _toggleListening,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: _isListening
                          ? Colors.red.withOpacity(0.5)
                          : Colors.blue.withOpacity(0.4),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Icon(
                      _isListening ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
              ),
            ),

            if (_isLoading)
              const Center(child: CircularProgressIndicator(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
