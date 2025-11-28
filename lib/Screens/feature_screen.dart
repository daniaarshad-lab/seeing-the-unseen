// import 'package:flutter/material.dart';
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
//
//
// class FeatureScreen extends StatelessWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('EchoNav Features'),
//         // backgroundColor: Colors.blueAccent,
//           backgroundColor: Colors.deepPurple,
//
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const VisionScreen()),
//                   );
//                 },
//                 child: const Text('Vision'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const TaskScreen()),
//                   );
//                 },
//                 child: const Text('Task Management & Reminder'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const OCRPage()),
//                   );
//                 },
//                 child: const Text('OCR'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const HomeScreen()),
//                   );
//                 },
//                 child: const Text('Person Detection'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const ObjectDetectionScreen()),
//                   );
//                 },
//                 child: const Text('Object Detection'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// // Your screens
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//   }
//
//   @override
//   void dispose() {
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initAll() async {
//     print("🚀 Initializing TTS, STT, and mic permissions...");
//
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     // ✅ Request microphone permission
//     var status = await Permission.microphone.request();
//     if (status.isGranted) {
//       print("🎤 Microphone permission granted.");
//       await _speakOptions();
//     } else {
//       print("❌ Microphone permission denied.");
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   Future<void> _speakOptions() async {
//     print("🗣 Speaking menu options...");
//     const optionsText =
//         "Welcome to EchoNav. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?";
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.setVolume(1.0);
//
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     print("🔔 Speaking done, now playing beep...");
//     await _playBeepSound();
//
//     print("🎙 Starting voice capture after beep...");
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//       print("✅ Beep sound played.");
//     } catch (e) {
//       print("⚠️ Error playing beep: $e");
//     }
//   }
//
//   /// 🎧 Continuously listen until valid command detected
//   Future<void> captureVoice() async {
//     print("🎙 Initializing speech recognition...");
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         print("🧠 STT Status: $status");
//         if (status == 'notListening' && !_hasNavigated) {
//           print("🔁 Auto-restarting listener...");
//           await Future.delayed(const Duration(seconds: 1));
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//       onError: (error) async {
//         print("❌ STT Error: $error");
//         if (!_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       print("✅ Speech recognition started. Listening...");
//
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           setState(() => text = result.recognizedWords);
//           print("🗣 You said: ${result.recognizedWords}");
//
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       print("❌ Speech recognition not available.");
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _navigateToFeature(String command) async {
//     print("🔍 Checking recognized command: $command");
//
//     if (_hasNavigated) {
//       print("⚠️ Already navigating, ignoring duplicate trigger.");
//       return;
//     }
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       selectedPage = const OCRPage();
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       selectedPage = const HomeScreen();
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//       _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         // ✅ Wait until user comes back
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         // 🗣 After return → Speak again
//         print("⬅️ User returned from $featureName page");
//         _hasNavigated = false;
//         await _speakOptions();
//       }
//     } else {
//       print("🤔 Command not recognized. Retrying...");
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Vision, OCR, Object Detection, Task Management, or Person Detection.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await captureVoice();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("🎤 EchoNav Voice Navigation"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 isListening ? Icons.mic : Icons.mic_off,
//                 color: isListening ? Colors.red : Colors.grey,
//                 size: 90,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 isListening ? "Listening..." : "Not Listening",
//                 style: const TextStyle(fontSize: 18),
//               ),
//               const SizedBox(height: 40),
//               Text(
//                 text.isEmpty ? "Say something..." : text,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 20),
//               ),
//               const SizedBox(height: 40),
//               const Divider(thickness: 1),
//               const SizedBox(height: 20),
//               const Text(
//                 "Or choose manually:",
//                 style: TextStyle(fontSize: 18),
//               ),
//               const SizedBox(height: 20),
//               _buildButton("Vision", const VisionScreen()),
//               _buildButton("Task Management & Reminder", const TaskScreen()),
//               _buildButton("OCR", const OCRPage()),
//               _buildButton("Person Detection", const HomeScreen()),
//               _buildButton("Object Detection", const ObjectDetectionScreen()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           minimumSize: const Size(double.infinity, 50),
//           backgroundColor: Colors.deepPurple,
//         ),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//           await _speakOptions(); // Restart voice when returning
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// // Your screens
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//   }
//
//   @override
//   void dispose() {
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initAll() async {
//     print("🚀 Initializing TTS, STT, and mic permissions...");
//
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     // ✅ Request microphone permission
//     var status = await Permission.microphone.request();
//     if (status.isGranted) {
//       print("🎤 Microphone permission granted.");
//       await _speakOptions();
//     } else {
//       print("❌ Microphone permission denied.");
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   Future<void> _speakOptions() async {
//     print("🗣 Speaking menu options...");
//     const optionsText =
//         "Welcome to EchoNav. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?";
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.setVolume(1.0);
//
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     print("🔔 Speaking done, now playing beep...");
//     await _playBeepSound();
//
//     print("🎙 Starting voice capture after beep...");
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//       print("✅ Beep sound played.");
//     } catch (e) {
//       print("⚠️ Error playing beep: $e");
//     }
//   }
//
//   /// 🎧 Continuously listen until valid command detected
//   Future<void> captureVoice() async {
//     print("🎙 Initializing speech recognition...");
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         print("🧠 STT Status: $status");
//         if (status == 'notListening' && !_hasNavigated) {
//           print("🔁 Auto-restarting listener...");
//           await Future.delayed(const Duration(seconds: 1));
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//       onError: (error) async {
//         print("❌ STT Error: $error");
//         if (!_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       print("✅ Speech recognition started. Listening...");
//
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           setState(() => text = result.recognizedWords);
//           print("🗣 You said: ${result.recognizedWords}");
//
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       print("❌ Speech recognition not available.");
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _navigateToFeature(String command) async {
//     print("🔍 Checking recognized command: $command");
//
//     if (_hasNavigated) {
//       print("⚠️ Already navigating, ignoring duplicate trigger.");
//       return;
//     }
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       selectedPage = const OCRPage();
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       selectedPage = const HomeScreen();
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//       _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         // ✅ Wait until user comes back
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         // 🗣 After return → Speak again
//         print("⬅️ User returned from $featureName page");
//         _hasNavigated = false;
//         await _speakOptions();
//       }
//     } else {
//       print("🤔 Command not recognized. Retrying...");
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Vision, OCR, Object Detection, Task Management, or Person Detection.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await captureVoice();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("🎤 EchoNav Voice Navigation"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView( // ✅ FIX for overflow
//           padding: const EdgeInsets.all(24.0),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   isListening ? Icons.mic : Icons.mic_off,
//                   color: isListening ? Colors.red : Colors.grey,
//                   size: 90,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   isListening ? "Listening..." : "Not Listening",
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 40),
//                 Text(
//                   text.isEmpty ? "Say something..." : text,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(height: 40),
//                 const Divider(thickness: 1),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Or choose manually:",
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildButton("Vision", const VisionScreen()),
//                 _buildButton("Task Management & Reminder", const TaskScreen()),
//                 _buildButton("OCR", const OCRPage()),
//                 _buildButton("Person Detection", const HomeScreen()),
//                 _buildButton("Object Detection", const ObjectDetectionScreen()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           minimumSize: const Size(double.infinity, 50),
//           backgroundColor: Colors.deepPurple,
//         ),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//           await _speakOptions(); // Restart voice when returning
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }





//
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// // Your screens
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> with WidgetsBindingObserver {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool _voiceEnabled = true; // 🎚️ toggle state
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initAll();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   // 🧭 When coming back from another page or app resumes
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && _voiceEnabled) {
//       _resetAndSpeakOptions();
//     }
//   }
//
//   Future<void> _initAll() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted) {
//       if (_voiceEnabled) await _speakOptions();
//     } else {
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   Future<void> _resetAndSpeakOptions() async {
//     _hasNavigated = false;
//     if (_voiceEnabled) await _speakOptions();
//   }
//
//   Future<void> _speakOptions() async {
//     if (!_voiceEnabled) return;
//
//     const optionsText =
//         "Welcome to EchoNav. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?";
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.setVolume(1.0);
//
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     await _playBeepSound();
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Error playing beep: $e");
//     }
//   }
//
//   /// 🎧 Voice recognition (restarts until valid command)
//   Future<void> captureVoice() async {
//     if (!_voiceEnabled) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (status == 'notListening' && !_hasNavigated && _voiceEnabled) {
//           await Future.delayed(const Duration(seconds: 1));
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//       onError: (error) async {
//         if (!_hasNavigated && _voiceEnabled) {
//           await Future.delayed(const Duration(seconds: 1));
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _navigateToFeature(String command) async {
//     if (!_voiceEnabled) return;
//
//     if (_hasNavigated) return;
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       selectedPage = const OCRPage();
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       selectedPage = const HomeScreen();
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//       _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//         _hasNavigated = false;
//
//         if (_voiceEnabled) {
//           await _resetAndSpeakOptions();
//         }
//       }
//     } else {
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Vision, OCR, Object Detection, Task Management, or Person Detection.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await captureVoice();
//     }
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           minimumSize: const Size(double.infinity, 50),
//           backgroundColor: Colors.deepPurple,
//         ),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//           if (_voiceEnabled) await _resetAndSpeakOptions();
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("🎤 EchoNav Voice Navigation"),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           Row(
//             children: [
//               const Text("Voice Mode", style: TextStyle(fontSize: 14)),
//               Switch(
//                 value: _voiceEnabled,
//                 activeColor: Colors.white,
//                 onChanged: (val) {
//                   setState(() {
//                     _voiceEnabled = val;
//                     if (_voiceEnabled) {
//                       _resetAndSpeakOptions();
//                     } else {
//                       _speechToText.stop();
//                       _flutterTts.stop();
//                       isListening = false;
//                     }
//                   });
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   isListening ? Icons.mic : Icons.mic_off,
//                   color: isListening ? Colors.red : Colors.grey,
//                   size: 90,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   isListening ? "Listening..." : "Not Listening",
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 40),
//                 Text(
//                   text.isEmpty ? "Say something..." : text,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(height: 40),
//                 const Divider(thickness: 1),
//                 const SizedBox(height: 20),
//                 if (!_voiceEnabled) ...[
//                   const Text(
//                     "Manual selection:",
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   const SizedBox(height: 20),
//                   _buildButton("Vision", const VisionScreen()),
//                   _buildButton("Task Management & Reminder", const TaskScreen()),
//                   _buildButton("OCR", const OCRPage()),
//                   _buildButton("Person Detection", const HomeScreen()),
//                   _buildButton("Object Detection", const ObjectDetectionScreen()),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }












// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// // Your screens
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool isVoiceModeOn = true; // 🔘 toggle control
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//   }
//
//   @override
//   void dispose() {
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initAll() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && isVoiceModeOn) {
//       await _speakOptions();
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   Future<void> _speakOptions() async {
//     if (!isVoiceModeOn) return;
//
//     const optionsText =
//         "Welcome to EchoNav. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?";
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     await _playBeepSound();
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   Future<void> captureVoice() async {
//     if (!isVoiceModeOn) {
//       print("🎙 Voice mode OFF — not starting capture");
//       return;
//     }
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         print("🧠 STT Status: $status");
//         if (!isVoiceModeOn) return; // ⛔ stop restarts
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (isVoiceModeOn) {
//             await _playBeepSound();
//             await captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         print("❌ STT Error: $error");
//         if (!isVoiceModeOn) return; // ⛔ stop restarts
//         await Future.delayed(const Duration(seconds: 1));
//         if (isVoiceModeOn) {
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!isVoiceModeOn) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _navigateToFeature(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       // selectedPage = const OCRPage();
//       selectedPage = OCRPage(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       selectedPage = const HomeScreen();
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         _hasNavigated = false;
//         if (isVoiceModeOn) await _speakOptions();
//       }
//     } else {
//       if (!isVoiceModeOn) return;
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Vision, OCR, Object Detection, Task Management, or Person Detection.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await captureVoice();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("🎤 EchoNav Voice Navigation"),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           Row(
//             children: [
//               const Text("Voice", style: TextStyle(color: Colors.white)),
//               Switch(
//                 value: isVoiceModeOn,
//                 activeColor: Colors.white,
//                 onChanged: (value) async {
//                   setState(() => isVoiceModeOn = value);
//                   if (value) {
//                     await _speakOptions();
//                   } else {
//                     await _speechToText.stop();
//                     setState(() => isListening = false);
//                     await _flutterTts.speak("Voice mode turned off.");
//                   }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Center(
//             child: Column(
//               children: [
//                 Icon(
//                   isListening ? Icons.mic : Icons.mic_off,
//                   color: isListening ? Colors.red : Colors.grey,
//                   size: 90,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   isVoiceModeOn
//                       ? (isListening ? "Listening..." : "Waiting for command...")
//                       : "Voice Mode Off",
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 30),
//                 Text(
//                   text.isEmpty ? "Say something..." : text,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(height: 40),
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 const Text("Or choose manually:",
//                     style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 20),
//                 _buildButton("Vision", const VisionScreen()),
//                 _buildButton("Task Management & Reminder", const TaskScreen()),
//                 _buildButton("OCR", const OCRPage()),
//                 _buildButton("Person Detection", const HomeScreen()),
//                 _buildButton("Object Detection", const ObjectDetectionScreen()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         onPressed: () async {
//           await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
//           if (isVoiceModeOn) await _speakOptions();
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }







// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// // Your screens
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool isVoiceModeOn = true; // 🔘 toggle control
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//   }
//
//   @override
//   void dispose() {
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initAll() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && isVoiceModeOn) {
//       await _speakOptions();
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   Future<void> _speakOptions() async {
//     if (!isVoiceModeOn) return;
//
//     const optionsText =
//         "Welcome to EchoNav. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?";
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     await _playBeepSound();
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   Future<void> captureVoice() async {
//     if (!isVoiceModeOn) {
//       print("🎙 Voice mode OFF — not starting capture");
//       return;
//     }
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         print("🧠 STT Status: $status");
//         if (!isVoiceModeOn) return; // ⛔ stop restarts
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (isVoiceModeOn) {
//             await _playBeepSound();
//             await captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         print("❌ STT Error: $error");
//         if (!isVoiceModeOn) return; // ⛔ stop restarts
//         await Future.delayed(const Duration(seconds: 1));
//         if (isVoiceModeOn) {
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!isVoiceModeOn) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _navigateToFeature(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       // ✅ Pass voice navigation toggle when opening OCR
//       selectedPage = OCRPage(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       selectedPage = const HomeScreen();
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         // ✅ Wait for page to pop, then resume voice navigation
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         _hasNavigated = false;
//         if (isVoiceModeOn) await _speakOptions(); // 🔹 resume voice
//       }
//     } else {
//       if (!isVoiceModeOn) return;
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Vision, OCR, Object Detection, Task Management, or Person Detection.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await captureVoice();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("🎤 EchoNav Voice Navigation"),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           Row(
//             children: [
//               const Text("Voice", style: TextStyle(color: Colors.white)),
//               Switch(
//                 value: isVoiceModeOn,
//                 activeColor: Colors.white,
//                 onChanged: (value) async {
//                   setState(() => isVoiceModeOn = value);
//                   if (value) {
//                     await _speakOptions();
//                   } else {
//                     await _speechToText.stop();
//                     setState(() => isListening = false);
//                     await _flutterTts.speak("Voice mode turned off.");
//                   }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Center(
//             child: Column(
//               children: [
//                 Icon(
//                   isListening ? Icons.mic : Icons.mic_off,
//                   color: isListening ? Colors.red : Colors.grey,
//                   size: 90,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   isVoiceModeOn
//                       ? (isListening ? "Listening..." : "Waiting for command...")
//                       : "Voice Mode Off",
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 30),
//                 Text(
//                   text.isEmpty ? "Say something..." : text,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(height: 40),
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 const Text("Or choose manually:",
//                     style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 20),
//                 _buildButton("Vision", const VisionScreen()),
//                 _buildButton("Task Management & Reminder", const TaskScreen()),
//                 // ✅ Pass voiceNavigationEnabled when opening OCR manually
//                 _buildButton("OCR", OCRPage(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Person Detection", const HomeScreen()),
//                 _buildButton("Object Detection", const ObjectDetectionScreen()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ✅ Updated to handle voiceNavigation toggle when opening internal pages
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) {
//                 // 🔹 Pass voice navigation toggle to OCR page
//                 if (page is OCRPage) {
//                   return OCRPage(voiceNavigationEnabled: isVoiceModeOn);
//                 }
//                 return page;
//               },
//             ),
//           );
//
//           // 🔹 Resume FeatureScreen voice navigation after returning
//           if (isVoiceModeOn) await _speakOptions();
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }
//
//
//
//
//

















// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// // Import your screens
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool isVoiceModeOn = true; // 🔘 toggle control
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//   }
//
//   @override
//   void dispose() {
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     _flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> _initAll() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && isVoiceModeOn) {
//       await _speakOptions();
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   // Speak FeatureScreen welcome options
//   Future<void> _speakOptions() async {
//     if (!isVoiceModeOn) return;
//
//     const optionsText =
//         "Welcome to EchoNav. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?";
//
//     await _flutterTts.stop(); // ✅ stop any ongoing speech
//     await _speechToText.stop(); // stop listening while speaking
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     await _playBeepSound();
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   Future<void> captureVoice() async {
//     if (!isVoiceModeOn) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         print("🧠 STT Status: $status");
//         if (!isVoiceModeOn) return;
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (isVoiceModeOn) {
//             await _playBeepSound();
//             await captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         print("❌ STT Error: $error");
//         if (!isVoiceModeOn) return;
//         await Future.delayed(const Duration(seconds: 1));
//         if (isVoiceModeOn) {
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!isVoiceModeOn) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   // Navigate to any feature screen
//   Future<void> _navigateToFeature(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       // selectedPage = VisionScreen(voiceNavigationEnabled: isVoiceModeOn);
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       // selectedPage = TaskScreen(voiceNavigationEnabled: isVoiceModeOn);
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       selectedPage = OCRPage(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       // selectedPage = HomeScreen(voiceNavigationEnabled: isVoiceModeOn);
//       selectedPage = const HomeScreen();
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       // selectedPage = ObjectDetectionScreen(voiceNavigationEnabled: isVoiceModeOn);
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         _hasNavigated = false;
//         if (isVoiceModeOn) await _speakOptions(); // resume after returning
//       }
//     } else {
//       if (!isVoiceModeOn) return;
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Vision, OCR, Object Detection, Task Management, or Person Detection.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await captureVoice();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("🎤 EchoNav Voice Navigation"),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           Row(
//             children: [
//               const Text("Voice", style: TextStyle(color: Colors.white)),
//               Switch(
//                 value: isVoiceModeOn,
//                 activeColor: Colors.white,
//                 onChanged: (value) async {
//                   setState(() => isVoiceModeOn = value);
//                   if (value) {
//                     await _speakOptions();
//                   } else {
//                     await _flutterTts.stop();
//                     await _speechToText.stop();
//                     setState(() => isListening = false);
//                     await _flutterTts.speak("Voice mode turned off.");
//                   }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Center(
//             child: Column(
//               children: [
//                 Icon(
//                   isListening ? Icons.mic : Icons.mic_off,
//                   color: isListening ? Colors.red : Colors.grey,
//                   size: 90,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   isVoiceModeOn
//                       ? (isListening ? "Listening..." : "Waiting for command...")
//                       : "Voice Mode Off",
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 30),
//                 Text(
//                   text.isEmpty ? "Say something..." : text,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(height: 40),
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 const Text("Or choose manually:",
//                     style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 20),
//                 // _buildButton("Vision", VisionScreen(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Vision", VisionScreen()),
//                 // _buildButton("Task Management & Reminder", TaskScreen(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Task Management & Reminder", TaskScreen()),
//                 _buildButton("OCR", OCRPage(voiceNavigationEnabled: isVoiceModeOn)),
//                 // _buildButton("Person Detection", HomeScreen(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Person Detection", HomeScreen()),
//                 // _buildButton("Object Detection", ObjectDetectionScreen(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Object Detection", ObjectDetectionScreen()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         onPressed: () async {
//           await _flutterTts.stop(); // ✅ stop ongoing TTS
//           await _speechToText.stop(); // ✅ stop listening
//           setState(() => isListening = false);
//
//           await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => page,
//             ),
//           );
//
//           // 🔹 Resume FeatureScreen voice navigation after returning
//           if (isVoiceModeOn) await _speakOptions();
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }
//




// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// // Import your screens
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool isVoiceModeOn = true; // 🔘 toggle control
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//   }
//
//   @override
//   void dispose() {
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     _flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> _initAll() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && isVoiceModeOn) {
//       await _speakOptions();
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   // Speak FeatureScreen welcome options
//   Future<void> _speakOptions() async {
//     if (!isVoiceModeOn) return;
//
//     const optionsText =
//         "Welcome to EchoNav. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?";
//
//     await _flutterTts.stop(); // ✅ stop any ongoing speech
//     await _speechToText.stop(); // stop listening while speaking
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     await _playBeepSound();
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   Future<void> captureVoice() async {
//     if (!isVoiceModeOn) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         print("🧠 STT Status: $status");
//         if (!isVoiceModeOn) return;
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (isVoiceModeOn) {
//             await _playBeepSound();
//             await captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         print("❌ STT Error: $error");
//         if (!isVoiceModeOn) return;
//         await Future.delayed(const Duration(seconds: 1));
//         if (isVoiceModeOn) {
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!isVoiceModeOn) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   // Navigate to any feature screen
//   Future<void> _navigateToFeature(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       selectedPage = OCRPage(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       selectedPage = const HomeScreen();
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//
//       // ✅ Stop TTS/STT before navigating
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         _hasNavigated = false;
//         if (isVoiceModeOn) await _speakOptions(); // resume after returning
//       }
//     } else {
//       if (!isVoiceModeOn) return;
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Vision, OCR, Object Detection, Task Management, or Person Detection.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await captureVoice();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("🎤 EchoNav Voice Navigation"),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           Row(
//             children: [
//               const Text("Voice", style: TextStyle(color: Colors.white)),
//               Switch(
//                 value: isVoiceModeOn,
//                 activeColor: Colors.white,
//                 onChanged: (value) async {
//                   setState(() => isVoiceModeOn = value);
//                   if (value) {
//                     await _speakOptions();
//                   } else {
//                     await _flutterTts.stop();
//                     await _speechToText.stop();
//                     setState(() => isListening = false);
//                     await _flutterTts.speak("Voice mode turned off.");
//                   }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Center(
//             child: Column(
//               children: [
//                 Icon(
//                   isListening ? Icons.mic : Icons.mic_off,
//                   color: isListening ? Colors.red : Colors.grey,
//                   size: 90,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   isVoiceModeOn
//                       ? (isListening ? "Listening..." : "Waiting for command...")
//                       : "Voice Mode Off",
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 30),
//                 Text(
//                   text.isEmpty ? "Say something..." : text,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(height: 40),
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 const Text("Or choose manually:",
//                     style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 20),
//                 _buildButton("Vision", const VisionScreen()),
//                 _buildButton("Task Management & Reminder", const TaskScreen()),
//                 _buildButton("OCR", OCRPage(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Person Detection", const HomeScreen()),
//                 _buildButton("Object Detection", const ObjectDetectionScreen()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         onPressed: () async {
//           // ✅ Stop TTS/STT before navigating manually
//           await _flutterTts.stop();
//           await _speechToText.stop();
//           setState(() => isListening = false);
//
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//
//           // 🔹 Resume FeatureScreen voice navigation after returning
//           if (isVoiceModeOn) await _speakOptions();
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// // Import your screens
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool isVoiceModeOn = true; // 🔘 toggle control
//   bool _isActive = true; // ✅ Track if screen is active for listening
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false; // Stop any background listening
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     _flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> _initAll() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && isVoiceModeOn) {
//       await _speakOptions();
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   // Speak FeatureScreen welcome options
//   Future<void> _speakOptions() async {
//     if (!isVoiceModeOn || !_isActive) return;
//
//     const optionsText =
//         "Welcome to EchoNav. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?";
//
//     await _flutterTts.stop(); // ✅ stop any ongoing speech
//     await _speechToText.stop(); // stop listening while speaking
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     await _playBeepSound();
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   Future<void> captureVoice() async {
//     if (!isVoiceModeOn || !_isActive) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (!_isActive) return;
//         print("🧠 STT Status: $status");
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && isVoiceModeOn) {
//             await _playBeepSound();
//             await captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         if (!_isActive) return;
//         print("❌ STT Error: $error");
//         await Future.delayed(const Duration(seconds: 1));
//         if (_isActive && isVoiceModeOn) {
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive || !isVoiceModeOn) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   // Navigate to any feature screen
//   Future<void> _navigateToFeature(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       selectedPage = OCRPage(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       selectedPage = const HomeScreen(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//
//       // ✅ Stop FeatureScreen TTS/STT before navigating
//       _isActive = false;
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         // Reactivate FeatureScreen after return
//         _hasNavigated = false;
//         _isActive = true;
//         if (isVoiceModeOn) await _speakOptions();
//       }
//     } else {
//       if (!_isActive || !isVoiceModeOn) return;
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Vision, OCR, Object Detection, Task Management, or Person Detection.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await captureVoice();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("🎤 EchoNav Voice Navigation"),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           Row(
//             children: [
//               const Text("Voice", style: TextStyle(color: Colors.white)),
//               Switch(
//                 value: isVoiceModeOn,
//                 activeColor: Colors.white,
//                 onChanged: (value) async {
//                   setState(() => isVoiceModeOn = value);
//                   if (value) {
//                     _isActive = true;
//                     await _speakOptions();
//                   } else {
//                     _isActive = false;
//                     await _flutterTts.stop();
//                     await _speechToText.stop();
//                     setState(() => isListening = false);
//                     await _flutterTts.speak("Voice mode turned off.");
//                   }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Center(
//             child: Column(
//               children: [
//                 Icon(
//                   isListening ? Icons.mic : Icons.mic_off,
//                   color: isListening ? Colors.red : Colors.grey,
//                   size: 90,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   isVoiceModeOn
//                       ? (isListening ? "Listening..." : "Waiting for command...")
//                       : "Voice Mode Off",
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 30),
//                 Text(
//                   text.isEmpty ? "Say something..." : text,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(height: 40),
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 const Text("Or choose manually:",
//                     style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 20),
//                 _buildButton("Vision", const VisionScreen()),
//                 _buildButton(
//                     "Task Management & Reminder", const TaskScreen()),
//                 _buildButton(
//                     "OCR", OCRPage(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Person Detection", const HomeScreen()),
//                 _buildButton(
//                     "Object Detection", const ObjectDetectionScreen()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         onPressed: () async {
//           // ✅ Stop TTS/STT before navigating manually
//           _isActive = false;
//           await _flutterTts.stop();
//           await _speechToText.stop();
//           setState(() => isListening = false);
//
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//
//           // 🔹 Resume FeatureScreen voice navigation after returning
//           _isActive = true;
//           if (isVoiceModeOn) await _speakOptions();
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// // Import your screens
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool isVoiceModeOn = true; // 🔘 toggle control
//   bool _isActive = true; // ✅ Track if screen is active for listening
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false; // Stop any background listening
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     _flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> _initAll() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && isVoiceModeOn) {
//       await _speakOptions();
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   // Speak FeatureScreen welcome options
//   Future<void> _speakOptions() async {
//     if (!isVoiceModeOn || !_isActive) return;
//
//     const optionsText =
//         "Welcome to EchoNav. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?";
//
//     await _flutterTts.stop(); // ✅ stop any ongoing speech
//     await _speechToText.stop(); // stop listening while speaking
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     await _playBeepSound();
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   Future<void> captureVoice() async {
//     if (!isVoiceModeOn || !_isActive) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (!_isActive) return;
//         print("🧠 STT Status: $status");
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && isVoiceModeOn) {
//             await _playBeepSound();
//             await captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         if (!_isActive) return;
//         print("❌ STT Error: $error");
//         await Future.delayed(const Duration(seconds: 1));
//         if (_isActive && isVoiceModeOn) {
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive || !isVoiceModeOn) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   // Navigate to any feature screen
//   Future<void> _navigateToFeature(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       selectedPage = OCRPage(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       // ✅ UPDATED: Pass flag to HomeScreen (Person Detection)
//       selectedPage = HomeScreen(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//
//       // ✅ Stop FeatureScreen TTS/STT before navigating
//       _isActive = false;
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         // Reactivate FeatureScreen after return
//         _hasNavigated = false;
//         _isActive = true;
//         if (isVoiceModeOn) await _speakOptions();
//       }
//     } else {
//       if (!_isActive || !isVoiceModeOn) return;
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Vision, OCR, Object Detection, Task Management, or Person Detection.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await captureVoice();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("🎤 EchoNav Voice Navigation"),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           Row(
//             children: [
//               const Text("Voice", style: TextStyle(color: Colors.white)),
//               Switch(
//                 value: isVoiceModeOn,
//                 activeColor: Colors.white,
//                 onChanged: (value) async {
//                   setState(() => isVoiceModeOn = value);
//                   if (value) {
//                     _isActive = true;
//                     await _speakOptions();
//                   } else {
//                     _isActive = false;
//                     await _flutterTts.stop();
//                     await _speechToText.stop();
//                     setState(() => isListening = false);
//                     await _flutterTts.speak("Voice mode turned off.");
//                   }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Center(
//             child: Column(
//               children: [
//                 Icon(
//                   isListening ? Icons.mic : Icons.mic_off,
//                   color: isListening ? Colors.red : Colors.grey,
//                   size: 90,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   isVoiceModeOn
//                       ? (isListening ? "Listening..." : "Waiting for command...")
//                       : "Voice Mode Off",
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 30),
//                 Text(
//                   text.isEmpty ? "Say something..." : text,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(height: 40),
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 const Text("Or choose manually:",
//                     style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 20),
//
//                 // ✅ Updated all buttons to pass voice flag where needed
//                 _buildButton("Vision", const VisionScreen()),
//                 _buildButton("Task Management & Reminder", const TaskScreen()),
//                 _buildButton("OCR", OCRPage(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Person Detection", HomeScreen(voiceNavigationEnabled: isVoiceModeOn)), // ✅ FIXED
//                 _buildButton("Object Detection", const ObjectDetectionScreen()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         onPressed: () async {
//           // ✅ Stop TTS/STT before navigating manually
//           _isActive = false;
//           await _flutterTts.stop();
//           await _speechToText.stop();
//           setState(() => isListening = false);
//
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//
//           // 🔹 Resume FeatureScreen voice navigation after returning
//           _isActive = true;
//           if (isVoiceModeOn) await _speakOptions();
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// // Import your screens
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool isVoiceModeOn = true;
//   bool _isActive = true;
//   bool _isFirstLaunch = true; // ✅ New flag to differentiate first time
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     _flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> _initAll() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && isVoiceModeOn) {
//       await _speakOptions(firstTime: true); // ✅ first time welcome
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   /// ✅ Unified speech method with firstTime flag
//   Future<void> _speakOptions({bool firstTime = false}) async {
//     if (!isVoiceModeOn || !_isActive) return;
//
//     final optionsText = firstTime
//         ? "Welcome to EchoNav. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?"
//         : "You are in the main page. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?";
//
//     await _flutterTts.stop();
//     await _speechToText.stop();
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     await _playBeepSound();
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   Future<void> captureVoice() async {
//     if (!isVoiceModeOn || !_isActive) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (!_isActive) return;
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && isVoiceModeOn) {
//             await _playBeepSound();
//             await captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         if (!_isActive) return;
//         await Future.delayed(const Duration(seconds: 1));
//         if (_isActive && isVoiceModeOn) {
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive || !isVoiceModeOn) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _navigateToFeature(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       selectedPage = OCRPage(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       selectedPage = HomeScreen(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//       _isActive = false;
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         // ✅ After returning — say “You are in main page”
//         _hasNavigated = false;
//         _isActive = true;
//         _isFirstLaunch = false; // ✅ not first time anymore
//         if (isVoiceModeOn) await _speakOptions(firstTime: false);
//       }
//     } else {
//       if (!_isActive || !isVoiceModeOn) return;
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Vision, OCR, Object Detection, Task Management, or Person Detection.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await captureVoice();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("🎤 EchoNav Voice Navigation"),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           Row(
//             children: [
//               const Text("Voice", style: TextStyle(color: Colors.white)),
//               Switch(
//                 value: isVoiceModeOn,
//                 activeColor: Colors.white,
//                 onChanged: (value) async {
//                   setState(() => isVoiceModeOn = value);
//                   if (value) {
//                     _isActive = true;
//                     await _speakOptions(firstTime: !_isFirstLaunch);
//                   } else {
//                     _isActive = false;
//                     await _flutterTts.stop();
//                     await _speechToText.stop();
//                     setState(() => isListening = false);
//                     await _flutterTts.speak("Voice mode turned off.");
//                   }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Center(
//             child: Column(
//               children: [
//                 Icon(
//                   isListening ? Icons.mic : Icons.mic_off,
//                   color: isListening ? Colors.red : Colors.grey,
//                   size: 90,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   isVoiceModeOn
//                       ? (isListening ? "Listening..." : "Waiting for command...")
//                       : "Voice Mode Off",
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 30),
//                 Text(
//                   text.isEmpty ? "Say something..." : text,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(height: 40),
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 const Text("Or choose manually:",
//                     style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 20),
//                 _buildButton("Vision", const VisionScreen()),
//                 _buildButton("Task Management & Reminder", const TaskScreen()),
//                 _buildButton(
//                     "OCR", OCRPage(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Person Detection",
//                     HomeScreen(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Object Detection", const ObjectDetectionScreen()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         onPressed: () async {
//           _isActive = false;
//           await _flutterTts.stop();
//           await _speechToText.stop();
//           setState(() => isListening = false);
//
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//
//           // ✅ After returning, not first launch anymore
//           _isActive = true;
//           _isFirstLaunch = false;
//           if (isVoiceModeOn) await _speakOptions(firstTime: false);
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }




//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// // Import your other modules
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool isVoiceModeOn = true;
//   bool _isActive = true;
//   bool _isFirstLaunch = true;
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     _flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> _initAll() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && isVoiceModeOn) {
//       await _speakOptions(firstTime: true);
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   Future<void> _speakOptions({bool firstTime = false}) async {
//     if (!isVoiceModeOn || !_isActive) return;
//
//     final optionsText = firstTime
//         ? "Welcome to EchoNav. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?"
//         : "You are in the main page. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?";
//
//     await _flutterTts.stop();
//     await _speechToText.stop();
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     await _playBeepSound();
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   Future<void> captureVoice() async {
//     if (!isVoiceModeOn || !_isActive) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (!_isActive) return;
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && isVoiceModeOn) {
//             await _playBeepSound();
//             await captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         if (!_isActive) return;
//         await Future.delayed(const Duration(seconds: 1));
//         if (_isActive && isVoiceModeOn) {
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive || !isVoiceModeOn) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak("Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _navigateToFeature(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       selectedPage = OCRPage(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       selectedPage = HomeScreen(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//       _isActive = false;
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         final result = await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         // ✅ When returning from any screen:
//         _hasNavigated = false;
//         _isActive = true;
//         _isFirstLaunch = false;
//
//         if (result == "back" && isVoiceModeOn) {
//           await _speakOptions(firstTime: false);
//         }
//       }
//     } else {
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Vision, OCR, Object Detection, Task Management, or Person Detection.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await captureVoice();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("🎤 EchoNav Voice Navigation"),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           Row(
//             children: [
//               const Text("Voice", style: TextStyle(color: Colors.white)),
//               Switch(
//                 value: isVoiceModeOn,
//                 activeColor: Colors.white,
//                 onChanged: (value) async {
//                   setState(() => isVoiceModeOn = value);
//                   if (value) {
//                     _isActive = true;
//                     await _speakOptions(firstTime: !_isFirstLaunch);
//                   } else {
//                     _isActive = false;
//                     await _flutterTts.stop();
//                     await _speechToText.stop();
//                     setState(() => isListening = false);
//                     await _flutterTts.speak("Voice mode turned off.");
//                   }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Center(
//             child: Column(
//               children: [
//                 Icon(
//                   isListening ? Icons.mic : Icons.mic_off,
//                   color: isListening ? Colors.red : Colors.grey,
//                   size: 90,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   isVoiceModeOn
//                       ? (isListening ? "Listening..." : "Waiting for command...")
//                       : "Voice Mode Off",
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 30),
//                 Text(
//                   text.isEmpty ? "Say something..." : text,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(height: 40),
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 const Text("Or choose manually:", style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 20),
//                 _buildButton("Vision", const VisionScreen()),
//                 _buildButton("Task Management", const TaskScreen()),
//                 _buildButton("OCR", OCRPage(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Person Detection", HomeScreen(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Object Detection", const ObjectDetectionScreen()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         onPressed: () async {
//           _isActive = false;
//           await _flutterTts.stop();
//           await _speechToText.stop();
//           setState(() => isListening = false);
//
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//
//           _isActive = true;
//           _isFirstLaunch = false;
//
//           if (result == "back" && isVoiceModeOn) {
//             await _speakOptions(firstTime: false);
//           }
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }




//
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// // Import your other modules
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool isVoiceModeOn = true;
//   bool _isActive = true;
//   bool _isFirstLaunch = true;
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     _flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> _initAll() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && isVoiceModeOn) {
//       await _speakOptions(firstTime: true);
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   Future<void> _speakOptions({bool firstTime = false}) async {
//     if (!isVoiceModeOn) return;
//
//     final optionsText = firstTime
//         ? "Welcome to EchoNav. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?"
//         : "You are in the main page. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection. Which one would you like to open?";
//
//     // 🟣 Stop any previous speech cleanly before starting
//     try {
//       await _flutterTts.stop();
//     } catch (_) {}
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     if (!_isActive || !isVoiceModeOn) return;
//
//     await _playBeepSound();
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   Future<void> captureVoice() async {
//     if (!isVoiceModeOn || !_isActive) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (!_isActive) return;
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && isVoiceModeOn) {
//             await _playBeepSound();
//             await captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         if (!_isActive) return;
//         await Future.delayed(const Duration(seconds: 1));
//         if (_isActive && isVoiceModeOn) {
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive || !isVoiceModeOn) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak("Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _navigateToFeature(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       selectedPage = OCRPage(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       selectedPage = HomeScreen(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//       _isActive = false;
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         final result = await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         // 🟢 FIX: Always reset flags and replay welcome even if interrupted
//         _hasNavigated = false;
//         _isActive = true;
//         _isFirstLaunch = false;
//
//         if (mounted && isVoiceModeOn) {
//           await Future.delayed(const Duration(milliseconds: 300));
//           await _speakOptions(firstTime: false);
//         }
//       }
//     } else {
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Vision, OCR, Object Detection, Task Management, or Person Detection.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await captureVoice();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("🎤 EchoNav Voice Navigation"),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           Row(
//             children: [
//               const Text("Voice", style: TextStyle(color: Colors.white)),
//               Switch(
//                 value: isVoiceModeOn,
//                 activeColor: Colors.white,
//                 onChanged: (value) async {
//                   setState(() => isVoiceModeOn = value);
//                   if (value) {
//                     _isActive = true;
//                     await _speakOptions(firstTime: !_isFirstLaunch);
//                   } else {
//                     _isActive = false;
//                     await _flutterTts.stop();
//                     await _speechToText.stop();
//                     setState(() => isListening = false);
//                     await _flutterTts.speak("Voice mode turned off.");
//                   }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Center(
//             child: Column(
//               children: [
//                 Icon(
//                   isListening ? Icons.mic : Icons.mic_off,
//                   color: isListening ? Colors.red : Colors.grey,
//                   size: 90,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   isVoiceModeOn
//                       ? (isListening ? "Listening..." : "Waiting for command...")
//                       : "Voice Mode Off",
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 30),
//                 Text(
//                   text.isEmpty ? "Say something..." : text,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(height: 40),
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 const Text("Or choose manually:", style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 20),
//                 _buildButton("Vision", const VisionScreen()),
//                 _buildButton("Task Management", const TaskScreen()),
//                 _buildButton("OCR", OCRPage(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Person Detection", HomeScreen(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Object Detection", const ObjectDetectionScreen()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         onPressed: () async {
//           _isActive = false;
//           await _flutterTts.stop();
//           await _speechToText.stop();
//           setState(() => isListening = false);
//
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//
//           _isActive = true;
//           _isFirstLaunch = false;
//
//           // 🟢 FIXED: Always speak again when returning from any screen
//           if (mounted && isVoiceModeOn) {
//             await Future.delayed(const Duration(milliseconds: 300));
//             await _speakOptions(firstTime: false);
//           }
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }











// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:camera/camera.dart';
//
// // Screens
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
// import 'package:objectde/Screens/currency_screen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool isVoiceModeOn = true;
//   bool _isActive = true;
//   bool _isFirstLaunch = true;
//   String text = '';
//
//   // ✅ ADD CAMERA VARIABLE HERE
//   List<CameraDescription> _cameras = [];
//   bool _cameraReady = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//     _initCamera(); // ✅ initialize camera here
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     _flutterTts.stop();
//     super.dispose();
//   }
//
//   // ✅ CAMERA INITIALIZATION
//   Future<void> _initCamera() async {
//     try {
//       _cameras = await availableCameras();
//       setState(() => _cameraReady = true);
//     } catch (e) {
//       print("⚠ Camera load failed: $e");
//     }
//   }
//
//   Future<void> _initAll() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && isVoiceModeOn) {
//       await _speakOptions(firstTime: true);
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   Future<void> _speakOptions({bool firstTime = false}) async {
//     if (!isVoiceModeOn) return;
//
//     final optionsText = firstTime
//         ? "Welcome to EchoNav. Say Vision, OCR, Currency, Task Management, or Person Detection."
//         : "You are in the main page. Say Vision, OCR, Currency, Task Management, or Person Detection.";
//
//     try {
//       await _flutterTts.stop();
//     } catch (_) {}
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     if (!_isActive || !isVoiceModeOn) return;
//
//     await _playBeepSound();
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   Future<void> captureVoice() async {
//     if (!isVoiceModeOn || !_isActive) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (!_isActive) return;
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && isVoiceModeOn) {
//             await _playBeepSound();
//             await captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         if (!_isActive) return;
//         await Future.delayed(const Duration(seconds: 1));
//         if (_isActive && isVoiceModeOn) {
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive || !isVoiceModeOn) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak("Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _navigateToFeature(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//
//     } else if (command.contains('ocr')) {
//       selectedPage = OCRPage(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "OCR";
//
//     } else if (command.contains('person')) {
//       selectedPage = HomeScreen(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "Person Detection";
//
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//
//     } else if (command.contains('currency')) {
//       if (_cameraReady) {
//         selectedPage = CurrencyScreen(camera: _cameras[0]);
//         featureName = "Currency Detection";
//       } else {
//         await _flutterTts.speak("Camera is still loading. Please wait.");
//         return;
//       }
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//       _isActive = false;
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         _hasNavigated = false;
//         _isActive = true;
//         _isFirstLaunch = false;
//
//         if (mounted && isVoiceModeOn) {
//           await Future.delayed(const Duration(milliseconds: 300));
//           await _speakOptions(firstTime: false);
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("🎤 EchoNav Voice Navigation"),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           Row(
//             children: [
//               const Text("Voice", style: TextStyle(color: Colors.white)),
//               Switch(
//                 value: isVoiceModeOn,
//                 activeColor: Colors.white,
//                 onChanged: (value) async {
//                   setState(() => isVoiceModeOn = value);
//                   if (value) {
//                     _isActive = true;
//                     await _speakOptions(firstTime: !_isFirstLaunch);
//                   } else {
//                     _isActive = false;
//                     await _flutterTts.stop();
//                     await _speechToText.stop();
//                     setState(() => isListening = false);
//                     await _flutterTts.speak("Voice mode turned off.");
//                   }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Center(
//             child: Column(
//               children: [
//                 Icon(
//                   isListening ? Icons.mic : Icons.mic_off,
//                   color: isListening ? Colors.red : Colors.grey,
//                   size: 90,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   isVoiceModeOn
//                       ? (isListening ? "Listening..." : "Waiting for command...")
//                       : "Voice Mode Off",
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 30),
//                 Text(
//                   text.isEmpty ? "Say something..." : text,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(height: 40),
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 const Text("Or choose manually:", style: TextStyle(fontSize: 18)),
//                 const SizedBox(height: 20),
//
//                 _buildButton("Vision", const VisionScreen()),
//                 _buildButton("Task Management", const TaskScreen()),
//                 _buildButton("OCR", OCRPage(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Person Detection", HomeScreen(voiceNavigationEnabled: isVoiceModeOn)),
//                 _buildButton("Object Detection", const ObjectDetectionScreen()),
//
//                 // ⭐ UPDATED Currency Button
//                 _buildButton(
//                     "Currency Detection",
//                     _cameraReady
//                         ? CurrencyScreen(camera: _cameras[0])
//                         : const Center(child: CircularProgressIndicator())),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         onPressed: () async {
//           if (label == "Currency Detection" && !_cameraReady) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Camera is still loading. Please wait...")),
//             );
//             return;
//           }
//
//           _isActive = false;
//           await _flutterTts.stop();
//           await _speechToText.stop();
//           setState(() => isListening = false);
//
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//
//           _isActive = true;
//           _isFirstLaunch = false;
//
//           if (mounted && isVoiceModeOn) {
//             await Future.delayed(const Duration(milliseconds: 300));
//             await _speakOptions(firstTime: false);
//           }
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:camera/camera.dart';
//
// // Screens
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
// import 'package:objectde/Screens/currency_screen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool isVoiceModeOn = true;
//   bool _isActive = true;
//   bool _isFirstLaunch = true;
//   String text = '';
//
//   List<CameraDescription> _cameras = [];
//   bool _cameraReady = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//     _initCamera();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     _flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> _initCamera() async {
//     try {
//       _cameras = await availableCameras();
//       setState(() => _cameraReady = true);
//     } catch (e) {
//       print("⚠ Camera load failed: $e");
//     }
//   }
//
//   Future<void> _initAll() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && isVoiceModeOn) {
//       await _speakOptions(firstTime: true);
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   Future<void> _speakOptions({bool firstTime = false}) async {
//     if (!isVoiceModeOn) return;
//
//     final optionsText = firstTime
//         ? "Welcome to EchoNav. Say Vision, OCR, Currency, Task Management, or Person Detection."
//         : "You are in the main page. Say Vision, OCR, Currency, Task Management, or Person Detection.";
//
//     try {
//       await _flutterTts.stop();
//     } catch (_) {}
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     if (!_isActive || !isVoiceModeOn) return;
//
//     await _playBeepSound();
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   Future<void> captureVoice() async {
//     if (!isVoiceModeOn || !_isActive) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (!_isActive) return;
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && isVoiceModeOn) {
//             await _playBeepSound();
//             await captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         if (!_isActive) return;
//         await Future.delayed(const Duration(seconds: 1));
//         if (_isActive && isVoiceModeOn) {
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive || !isVoiceModeOn) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak("Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _navigateToFeature(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       selectedPage = OCRPage(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       selectedPage = HomeScreen(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     } else if (command.contains('currency')) {
//       if (_cameraReady) {
//         selectedPage = CurrencyScreen(camera: _cameras[0]);
//         featureName = "Currency Detection";
//       } else {
//         await _flutterTts.speak("Camera is still loading. Please wait.");
//         return;
//       }
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//       _isActive = false;
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         _hasNavigated = false;
//         _isActive = true;
//         _isFirstLaunch = false;
//
//         if (mounted) {
//           await Future.delayed(const Duration(milliseconds: 300));
//           // ✅ Speak correct line depending on voice mode
//           if (isVoiceModeOn) {
//             await _speakOptions(firstTime: false);
//           } else {
//             await _flutterTts.speak("You are in the main page."); // Voice OFF
//           }
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       // ✅ Handle physical back button
//       onWillPop: () async {
//         if (!isVoiceModeOn) {
//           await _flutterTts.speak("You are in the main page.");
//         }
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.deepPurple.shade50,
//         appBar: AppBar(
//           title: const Text("🎤 EchoNav Voice Navigation"),
//           backgroundColor: Colors.deepPurple,
//           actions: [
//             Row(
//               children: [
//                 const Text("Voice", style: TextStyle(color: Colors.white)),
//                 Switch(
//                   value: isVoiceModeOn,
//                   activeColor: Colors.white,
//                   onChanged: (value) async {
//                     setState(() => isVoiceModeOn = value);
//                     if (value) {
//                       _isActive = true;
//                       await _speakOptions(firstTime: !_isFirstLaunch);
//                     } else {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _speechToText.stop();
//                       setState(() => isListening = false);
//                       await _flutterTts.speak("Voice mode turned off.");
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: Center(
//               child: Column(
//                 children: [
//                   Icon(
//                     isListening ? Icons.mic : Icons.mic_off,
//                     color: isListening ? Colors.red : Colors.grey,
//                     size: 90,
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     isVoiceModeOn
//                         ? (isListening ? "Listening..." : "Waiting for command...")
//                         : "Voice Mode Off",
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                   const SizedBox(height: 30),
//                   Text(
//                     text.isEmpty ? "Say something..." : text,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 20),
//                   ),
//                   const SizedBox(height: 40),
//                   const Divider(),
//                   const SizedBox(height: 20),
//                   const Text("Or choose manually:", style: TextStyle(fontSize: 18)),
//                   const SizedBox(height: 20),
//                   _buildButton("Vision", const VisionScreen()),
//                   _buildButton("Task Management", const TaskScreen()),
//                   _buildButton("OCR", OCRPage(voiceNavigationEnabled: isVoiceModeOn)),
//                   _buildButton("Person Detection", HomeScreen(voiceNavigationEnabled: isVoiceModeOn)),
//                   _buildButton("Object Detection", const ObjectDetectionScreen()),
//                   _buildButton(
//                     "Currency Detection",
//                     _cameraReady
//                         ? CurrencyScreen(camera: _cameras[0])
//                         : const Center(child: CircularProgressIndicator()),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         onPressed: () async {
//           if (label == "Currency Detection" && !_cameraReady) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Camera is still loading. Please wait...")),
//             );
//             return;
//           }
//
//           _isActive = false;
//           await _flutterTts.stop();
//           await _speechToText.stop();
//           setState(() => isListening = false);
//
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//
//           _isActive = true;
//           _isFirstLaunch = false;
//
//           if (mounted) {
//             await Future.delayed(const Duration(milliseconds: 300));
//             // ✅ Speak after returning from button navigation
//             if (isVoiceModeOn) {
//               await _speakOptions(firstTime: false);
//             } else {
//               await _flutterTts.speak("You are in the main page.");
//             }
//           }
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }




// FULL UPDATED CODE – ONLY NECESSARY FIX ADDED

// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:camera/camera.dart';
//
// // Screens
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
// import 'package:objectde/Screens/currency_screen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool isVoiceModeOn = true;
//   bool _isActive = true;
//   bool _isFirstLaunch = true;
//   String text = '';
//
//   List<CameraDescription> _cameras = [];
//   bool _cameraReady = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//     _initCamera();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _speechToText.stop();
//     _audioPlayer.dispose();
//     _flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> _initCamera() async {
//     try {
//       _cameras = await availableCameras();
//       setState(() => _cameraReady = true);
//     } catch (e) {
//       print("⚠ Camera load failed: $e");
//     }
//   }
//
//   Future<void> _initAll() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && isVoiceModeOn) {
//       await _speakOptions(firstTime: true);
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   Future<void> _speakOptions({bool firstTime = false}) async {
//     if (!isVoiceModeOn) return;
//
//     final optionsText = firstTime
//         ? "Welcome to EchoNav. Say Vision, OCR, Currency, Task Management, or Person Detection."
//         : "You are in the main page. Say Vision, OCR, Currency, Task Management, or Person Detection.";
//
//     try {
//       await _flutterTts.stop();
//     } catch (_) {}
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     if (!_isActive || !isVoiceModeOn) return;
//
//     await _playBeepSound();
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   Future<void> captureVoice() async {
//     if (!isVoiceModeOn || !_isActive) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (!_isActive) return;
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && isVoiceModeOn) {
//             await _playBeepSound();
//             await captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         if (!_isActive) return;
//         await Future.delayed(const Duration(seconds: 1));
//         if (_isActive && isVoiceModeOn) {
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive || !isVoiceModeOn) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak("Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _navigateToFeature(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       selectedPage = OCRPage(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       selectedPage = HomeScreen(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     } else if (command.contains('currency')) {
//       if (_cameraReady) {
//         selectedPage = CurrencyScreen(camera: _cameras[0]);
//         featureName = "Currency Detection";
//       } else {
//         await _flutterTts.speak("Camera is still loading. Please wait.");
//         return;
//       }
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//       _isActive = false;
//
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         _hasNavigated = false;
//         _isActive = true;
//         _isFirstLaunch = false;
//
//         if (mounted) {
//           await Future.delayed(const Duration(milliseconds: 300));
//
//           // ✅ FIX ADDED: Every screen now speaks this on return
//           await _flutterTts.speak("You are in the main page.");
//
//           if (isVoiceModeOn) {
//             await _speakOptions(firstTime: false);
//           }
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         await _flutterTts.speak("You are in the main page.");
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.deepPurple.shade50,
//         appBar: AppBar(
//           title: const Text("🎤 EchoNav Voice Navigation"),
//           backgroundColor: Colors.deepPurple,
//           actions: [
//             Row(
//               children: [
//                 const Text("Voice", style: TextStyle(color: Colors.white)),
//                 Switch(
//                   value: isVoiceModeOn,
//                   activeColor: Colors.white,
//                   onChanged: (value) async {
//                     setState(() => isVoiceModeOn = value);
//                     if (value) {
//                       _isActive = true;
//                       await _speakOptions(firstTime: !_isFirstLaunch);
//                     } else {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _speechToText.stop();
//                       setState(() => isListening = false);
//                       await _flutterTts.speak("Voice mode turned off.");
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: Center(
//               child: Column(
//                 children: [
//                   Icon(
//                     isListening ? Icons.mic : Icons.mic_off,
//                     color: isListening ? Colors.red : Colors.grey,
//                     size: 90,
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     isVoiceModeOn
//                         ? (isListening ? "Listening..." : "Waiting for command...")
//                         : "Voice Mode Off",
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                   const SizedBox(height: 30),
//                   Text(
//                     text.isEmpty ? "Say something..." : text,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 20),
//                   ),
//                   const SizedBox(height: 40),
//                   const Divider(),
//                   const SizedBox(height: 20),
//                   const Text("Or choose manually:", style: TextStyle(fontSize: 18)),
//                   const SizedBox(height: 20),
//                   _buildButton("Vision", const VisionScreen()),
//                   _buildButton("Task Management", const TaskScreen()),
//                   _buildButton("OCR", OCRPage(voiceNavigationEnabled: isVoiceModeOn)),
//                   _buildButton("Person Detection", HomeScreen(voiceNavigationEnabled: isVoiceModeOn)),
//                   _buildButton("Object Detection", const ObjectDetectionScreen()),
//                   _buildButton(
//                     "Currency Detection",
//                     _cameraReady
//                         ? CurrencyScreen(camera: _cameras[0])
//                         : const Center(child: CircularProgressIndicator()),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         onPressed: () async {
//           if (label == "Currency Detection" && !_cameraReady) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                   content: Text("Camera is still loading. Please wait...")),
//             );
//             return;
//           }
//
//           _isActive = false;
//
//           await _flutterTts.stop();
//           await _speechToText.stop();
//           setState(() => isListening = false);
//
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//
//           _isActive = true;
//           _isFirstLaunch = false;
//
//           await Future.delayed(const Duration(milliseconds: 300));
//
//           // ✅ FIX ADDED FOR MANUAL NAVIGATION ALSO
//           await _flutterTts.speak("You are in the main page.");
//
//           if (isVoiceModeOn) {
//             await _speakOptions(firstTime: false);
//           }
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }


//***wahaj wala***
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:camera/camera.dart';
//
// // Screens
// import 'package:objectde/Screens/vision_screen.dart';
// import 'package:objectde/Screens/task_screen.dart';
// import 'package:objectde/pages/ocr.dart';
// import '../objectdetection.dart';
// import 'package:objectde/Screens/HomeScreen.dart';
// import 'package:objectde/Screens/currency_screen.dart';
//
// class FeatureScreen extends StatefulWidget {
//   const FeatureScreen({super.key});
//
//   @override
//   State<FeatureScreen> createState() => _FeatureScreenState();
// }
//
// class _FeatureScreenState extends State<FeatureScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool isVoiceModeOn = true;
//   bool _isActive = true;
//   bool _isFirstLaunch = true;
//   String text = '';
//
//   List<CameraDescription> _cameras = [];
//   bool _cameraReady = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initAll();
//     _initCamera();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     // best-effort stop/cancel STT (dispose cannot be async)
//     try {
//       _speechToText.stop();
//       _speechToText.cancel();
//     } catch (_) {}
//     _audioPlayer.dispose();
//     _flutterTts.stop();
//     super.dispose();
//   }
//
//   /// Stop and cancel the speech_to_text listener and update UI state.
//   Future<void> _stopSpeechToText() async {
//     try {
//       await _speechToText.stop();
//     } catch (_) {}
//     try {
//       await _speechToText.cancel();
//     } catch (_) {}
//     if (mounted) setState(() => isListening = false);
//     // give the platform a short moment to release the mic
//     await Future.delayed(const Duration(milliseconds: 120));
//   }
//
//   Future<void> _initCamera() async {
//     try {
//       _cameras = await availableCameras();
//       setState(() => _cameraReady = true);
//     } catch (e) {
//       print("⚠ Camera load failed: $e");
//     }
//   }
//
//   Future<void> _initAll() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && isVoiceModeOn) {
//       await _speakOptions(firstTime: true);
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please allow microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   Future<void> _speakOptions({bool firstTime = false}) async {
//     if (!isVoiceModeOn) return;
//
//     final optionsText = firstTime
//         ? "What you want to do,  Say Vision, Task Management, OCR, Person Detection, Object  Detection , or Currency Detection."
//         : "You are in the main page. Say Vision, Task Management, OCR, Person Detection, Object  Detection , or Currency Detection";
//
//     try {
//       await _flutterTts.stop();
//     } catch (_) {}
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//
//     await _flutterTts.speak(optionsText);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     if (!_isActive || !isVoiceModeOn) return;
//
//     await _playBeepSound();
//     await captureVoice();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   Future<void> captureVoice() async {
//     if (!isVoiceModeOn || !_isActive) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (!_isActive) return;
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && isVoiceModeOn) {
//             await _playBeepSound();
//             await captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         if (!_isActive) return;
//         await Future.delayed(const Duration(seconds: 1));
//         if (_isActive && isVoiceModeOn) {
//           await _playBeepSound();
//           await captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive || !isVoiceModeOn) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _navigateToFeature(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak("Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _speakOnReturn() async {
//     if (!_isActive) return;
//
//     await Future.delayed(const Duration(milliseconds: 300));
//
//     if (isVoiceModeOn) {
//       // Voice mode is ON - speak options with voice commands
//       await _speakOptions(firstTime: false);
//     } else {
//       // Voice mode is OFF - ensure STT is stopped/cancelled and only speak the simple message
//       await _stopSpeechToText();
//       await _flutterTts.speak("You are in the main page.");
//     }
//   }
//
//   Future<void> _navigateToFeature(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? selectedPage;
//     String? featureName;
//
//     if (command.contains('vision')) {
//       selectedPage = const VisionScreen();
//       featureName = "Vision";
//     } else if (command.contains('task')) {
//       selectedPage = const TaskScreen();
//       featureName = "Task Management";
//     } else if (command.contains('ocr')) {
//       selectedPage = OCRPage(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "OCR";
//     } else if (command.contains('person')) {
//       selectedPage = HomeScreenPageWrapper(voiceNavigationEnabled: isVoiceModeOn);
//       featureName = "Person Detection";
//     } else if (command.contains('object')) {
//       selectedPage = const ObjectDetectionScreen();
//       featureName = "Object Detection";
//     } else if (command.contains('currency')) {
//       if (_cameraReady) {
//         selectedPage = CurrencyScreen(camera: _cameras[0]);
//         featureName = "Currency Detection";
//       } else {
//         await _flutterTts.speak("Camera is still loading. Please wait.");
//         return;
//       }
//     }
//
//     if (selectedPage != null) {
//       _hasNavigated = true;
//       _isActive = false;
//
//       await _flutterTts.stop();
//       await _stopSpeechToText();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => selectedPage!),
//         );
//
//         // RETURNING BACK
//         _hasNavigated = false;
//         _isActive = true;
//         _isFirstLaunch = false;
//
//         await _speakOnReturn();
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         await _flutterTts.speak("You are in the main page.");
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.deepPurple.shade50,
//         appBar: AppBar(
//           title: const Text("Voice Navigation"),
//           backgroundColor: Colors.deepPurple,
//           actions: [
//             Row(
//               children: [
//                 const Text("Voice", style: TextStyle(color: Colors.white)),
//                 Switch(
//                   value: isVoiceModeOn,
//                   activeColor: Colors.white,
//                   onChanged: (value) async {
//                     setState(() => isVoiceModeOn = value);
//                     if (value) {
//                       _isActive = true;
//                       await _speakOptions(firstTime: !_isFirstLaunch);
//                     } else {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _stopSpeechToText();
//                       setState(() => isListening = false);
//                       await _flutterTts.speak("Voice mode turned off.");
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: Center(
//               child: Column(
//                 children: [
//                   Icon(
//                     isListening ? Icons.mic : Icons.mic_off,
//                     color: isListening ? Colors.red : Colors.grey,
//                     size: 90,
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     isVoiceModeOn
//                         ? (isListening ? "Listening..." : "Waiting for command...")
//                         : "Voice Mode Off",
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                   const SizedBox(height: 30),
//                   Text(
//                     text.isEmpty ? "Say something..." : text,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 20),
//                   ),
//                   const SizedBox(height: 40),
//                   const Divider(),
//                   const SizedBox(height: 20),
//                   const Text("Or choose manually:", style: TextStyle(fontSize: 18)),
//                   const SizedBox(height: 20),
//                   _buildButton("Vision", const VisionScreen()),
//                   _buildButton("Task Management", const TaskScreen()),
//                   _buildButton("OCR", OCRPage(voiceNavigationEnabled: isVoiceModeOn)),
//                   _buildButton(
//                       "Person Detection",
//                       HomeScreenPageWrapper(
//                           voiceNavigationEnabled: isVoiceModeOn)),
//                   _buildButton("Object Detection", const ObjectDetectionScreen()),
//                   _buildButton(
//                     "Currency Detection",
//                     _cameraReady
//                         ? CurrencyScreen(camera: _cameras[0])
//                         : const Center(child: CircularProgressIndicator()),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String label, Widget page) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         onPressed: () async {
//           if (label == "Currency Detection" && !_cameraReady) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                   content: Text("Camera is still loading. Please wait...")),
//             );
//             return;
//           }
//
//           _isActive = false;
//           await _flutterTts.stop();
//           await _stopSpeechToText();
//           setState(() => isListening = false);
//
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => page),
//           );
//
//           // RETURNING BACK
//           _isActive = true;
//           _isFirstLaunch = false;
//
//           await _speakOnReturn();
//         },
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }
//
// /// Wrapper for HomeScreen to isolate TTS like OCRPage
// class HomeScreenPageWrapper extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//   const HomeScreenPageWrapper({Key? key, this.voiceNavigationEnabled = false})
//       : super(key: key);
//
//   @override
//   State<HomeScreenPageWrapper> createState() => _HomeScreenPageWrapperState();
// }
//
// class _HomeScreenPageWrapperState extends State<HomeScreenPageWrapper> {
//   late FlutterTts _flutterTts;
//
//   @override
//   void initState() {
//     super.initState();
//     _flutterTts = FlutterTts();
//
//     if (widget.voiceNavigationEnabled) {
//       Future.delayed(const Duration(milliseconds: 500), () async {
//         await _flutterTts.speak("You are in Person Detection module.");
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _flutterTts.stop();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return HomeScreen(voiceNavigationEnabled: widget.voiceNavigationEnabled);
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

// Screens
import 'package:objectde/Screens/vision_screen.dart';
import 'package:objectde/Screens/task_screen.dart';
import 'package:objectde/pages/ocr.dart';
import '../objectdetection.dart';
import 'package:objectde/Screens/HomeScreen.dart';
import 'package:objectde/Screens/currency_screen.dart';

class FeatureScreen extends StatefulWidget {
  const FeatureScreen({super.key});

  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  late FlutterTts _flutterTts;
  late stt.SpeechToText _speechToText;
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isListening = false;
  bool _hasNavigated = false;
  bool isVoiceModeOn = true;
  bool _isActive = true;
  bool _isFirstLaunch = true;
  String text = '';

  List<CameraDescription> _cameras = [];
  bool _cameraReady = false;

  @override
  void initState() {
    super.initState();
    _initAll();
    _initCamera();
  }

  @override
  void dispose() {
    _isActive = false;
    // best-effort stop/cancel STT (dispose cannot be async)
    try {
      _speechToText.stop();
      _speechToText.cancel();
    } catch (_) {}
    _audioPlayer.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  /// Stop and cancel the speech_to_text listener and update UI state.
  Future<void> _stopSpeechToText() async {
    try {
      await _speechToText.stop();
    } catch (_) {}
    try {
      await _speechToText.cancel();
    } catch (_) {}
    if (mounted) setState(() => isListening = false);
    // give the platform a short moment to release the mic
    await Future.delayed(const Duration(milliseconds: 120));
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      setState(() => _cameraReady = true);
    } catch (e) {
      print("⚠ Camera load failed: $e");
    }
  }

  Future<void> _initAll() async {
    _flutterTts = FlutterTts();
    _speechToText = stt.SpeechToText();

    var status = await Permission.microphone.request();
    if (status.isGranted && isVoiceModeOn) {
      await _speakOptions(firstTime: true);
    } else if (!status.isGranted) {
      await _flutterTts.speak(
          "Please allow microphone permission in settings to use voice navigation.");
    }
  }

  Future<void> _speakOptions({bool firstTime = false}) async {
    if (!isVoiceModeOn) return;

    final optionsText = firstTime
        ? "What you want to do,  Say Vision, Task Management, OCR, Person Detection, Object  Detection , or Currency Detection."
        : "You are in the main page. Say Vision, Task Management, OCR, Person Detection, Object  Detection , or Currency Detection";

    try {
      await _flutterTts.stop();
    } catch (_) {}

    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);

    await _flutterTts.speak(optionsText);
    await _flutterTts.awaitSpeakCompletion(true);

    if (!_isActive || !isVoiceModeOn) return;

    await _playBeepSound();
    await captureVoice();
  }

  Future<void> _playBeepSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
    } catch (e) {
      print("⚠️ Beep missing or invalid: $e");
    }
  }

  Future<void> captureVoice() async {
    if (!isVoiceModeOn || !_isActive) return;

    bool available = await _speechToText.initialize(
      onStatus: (status) async {
        if (!_isActive) return;
        if (status == 'notListening' && !_hasNavigated) {
          await Future.delayed(const Duration(seconds: 1));
          if (_isActive && isVoiceModeOn) {
            await _playBeepSound();
            await captureVoice();
          }
        }
      },
      onError: (error) async {
        if (!_isActive) return;
        await Future.delayed(const Duration(seconds: 1));
        if (_isActive && isVoiceModeOn) {
          await _playBeepSound();
          await captureVoice();
        }
      },
    );

    if (available) {
      setState(() => isListening = true);
      await _speechToText.listen(
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
        pauseFor: const Duration(seconds: 5),
        listenFor: const Duration(minutes: 5),
        onResult: (result) {
          if (!_isActive || !isVoiceModeOn) return;
          setState(() => text = result.recognizedWords);
          if (result.finalResult && text.isNotEmpty) {
            _navigateToFeature(text.toLowerCase());
          }
        },
      );
    } else {
      await _flutterTts.speak("Speech recognition is not available on this device.");
    }
  }

  Future<void> _speakOnReturn() async {
    if (!_isActive) return;

    await Future.delayed(const Duration(milliseconds: 300));

    if (isVoiceModeOn) {
      // Voice mode is ON - speak options with voice commands
      await _speakOptions(firstTime: false);
    } else {
      // Voice mode is OFF - ensure STT is stopped/cancelled and only speak the simple message
      await _stopSpeechToText();
      await _flutterTts.speak("You are in the main page.");
    }
  }

  Future<void> _navigateToFeature(String command) async {
    if (_hasNavigated) return;

    Widget? selectedPage;
    String? featureName;

    if (command.contains('vision')) {
      selectedPage = const VisionScreen();
      featureName = "Vision";
    } else if (command.contains('task')) {
      selectedPage = const TaskScreen();
      featureName = "Task Management";
    } else if (command.contains('ocr')) {
      selectedPage = OCRPage(voiceNavigationEnabled: isVoiceModeOn);
      featureName = "OCR";
    } else if (command.contains('person')) {
      selectedPage = HomeScreenPageWrapper(voiceNavigationEnabled: isVoiceModeOn);
      featureName = "Person Detection";
    } else if (command.contains('object')) {
      selectedPage = const ObjectDetectionScreen();
      featureName = "Object Detection";
    } else if (command.contains('currency')) {
      if (_cameraReady) {
        selectedPage = CurrencyScreen(camera: _cameras[0]);
        featureName = "Currency Detection";
      } else {
        await _flutterTts.speak("Camera is still loading. Please wait.");
        return;
      }
    }

    if (selectedPage != null) {
      _hasNavigated = true;
      _isActive = false;

      await _flutterTts.stop();
      await _stopSpeechToText();
      setState(() => isListening = false);

      await _flutterTts.speak("Opening $featureName module");
      await _flutterTts.awaitSpeakCompletion(true);

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => selectedPage!),
        );

        // RETURNING BACK
        _hasNavigated = false;
        _isActive = true;
        _isFirstLaunch = false;

        await _speakOnReturn();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _flutterTts.speak("You are in the main page.");
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.deepPurple.shade50,
        appBar: AppBar(
          title: const Text("Voice Navigation"),
          backgroundColor: Colors.deepPurple,
          actions: [
            Row(
              children: [
                const Text("Voice", style: TextStyle(color: Colors.white)),
                Switch(
                  value: isVoiceModeOn,
                  activeColor: Colors.white,
                  onChanged: (value) async {
                    setState(() => isVoiceModeOn = value);
                    if (value) {
                      _isActive = true;
                      await _speakOptions(firstTime: !_isFirstLaunch);
                    } else {
                      _isActive = false;
                      await _flutterTts.stop();
                      await _stopSpeechToText();
                      setState(() => isListening = false);
                      await _flutterTts.speak("Voice mode turned off.");
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    isListening ? Icons.mic : Icons.mic_off,
                    color: isListening ? Colors.red : Colors.grey,
                    size: 90,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isVoiceModeOn
                        ? (isListening ? "Listening..." : "Waiting for command...")
                        : "Voice Mode Off",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    text.isEmpty ? "Say something..." : text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 40),
                  const Divider(),
                  const SizedBox(height: 20),
                  const Text("Or choose manually:", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  _buildButton("Vision", const VisionScreen()),
                  _buildButton("Task Management", const TaskScreen()),
                  _buildButton("OCR", OCRPage(voiceNavigationEnabled: isVoiceModeOn)),
                  _buildButton(
                      "Person Detection",
                      HomeScreenPageWrapper(
                          voiceNavigationEnabled: isVoiceModeOn)),
                  _buildButton("Object Detection", const ObjectDetectionScreen()),
                  _buildButton(
                    "Currency Detection",
                    _cameraReady
                        ? CurrencyScreen(camera: _cameras[0])
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, Widget page) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SizedBox(
        width: double.infinity,   // all buttons same width
        height: 55,               // fixed height for consistency
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,   // same original color
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0, // flat modern look, no shadow
          ),
          onPressed: () async {
            if (label == "Currency Detection" && !_cameraReady) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Camera is still loading. Please wait...")),
              );
              return;
            }

            _isActive = false;
            await _flutterTts.stop();
            await _stopSpeechToText();
            setState(() => isListening = false);

            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => page),
            );

            // RETURNING BACK
            _isActive = true;
            _isFirstLaunch = false;

            await _speakOnReturn();
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              label,
              key: ValueKey(label),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Wrapper for HomeScreen to isolate TTS like OCRPage
class HomeScreenPageWrapper extends StatefulWidget {
  final bool voiceNavigationEnabled;
  const HomeScreenPageWrapper({Key? key, this.voiceNavigationEnabled = false})
      : super(key: key);

  @override
  State<HomeScreenPageWrapper> createState() => _HomeScreenPageWrapperState();
}

class _HomeScreenPageWrapperState extends State<HomeScreenPageWrapper> {
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();

    if (widget.voiceNavigationEnabled) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        await _flutterTts.speak("You are in Person Detection module.");
      });
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(voiceNavigationEnabled: widget.voiceNavigationEnabled);
  }
}