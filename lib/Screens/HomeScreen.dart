// import 'package:flutter/material.dart';
// import 'RecognitionScreen.dart';
// import 'RegisteredFacesScreen.dart';
// import 'RegistrationScreen.dart';
// import 'package:camera/camera.dart';
//
// class HomeScreen extends StatelessWidget {
//
//
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6FA),
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 24),
//
//             // Header Text
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.tag_faces, size: 30, color: Colors.deepPurple),
//                   SizedBox(width: 10),
//                   Text(
//                     "Face Recognition",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // Logo
//             Center(
//               child: Container(
//                 width: screenWidth * 0.55,
//                 height: screenWidth * 0.55,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.deepPurple.withAlpha(80),
//                       spreadRadius: 5,
//                       blurRadius: 15,
//                       offset: const Offset(0, 10),
//                     ),
//                   ],
//                   image: const DecorationImage(
//                     // image: AssetImage("images/logo.png"),
//                     image: AssetImage("assets/images/scan.png"),
//                     fit: BoxFit.fitWidth,
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 40),
//
//             // Buttons as Cards
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//                 child: Column(
//                   children: [
//                     _actionCard(
//                       context,
//                       icon: Icons.person_add,
//                       title: "Register New Face",
//                       subtitle: "Capture and store a new user face",
//                       onTap: () => Navigator.push(
//                         context,
//                         // MaterialPageRoute(builder: (_) => const RegistrationScreen()),
//                         MaterialPageRoute(
//                           builder: (_) => RegistrationScreen(),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     _actionCard(
//                       context,
//                       icon: Icons.search,
//                       title: "Recognize Face",
//                       subtitle: "Identify registered faces in real-time",
//                       onTap: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const RecognitionScreen()),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     _actionCard(
//                       context,
//                       icon: Icons.list,
//                       title: "Registered Faces",
//                       subtitle: "View all stored face data",
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => const RegisteredFacesScreen()),
//                         );
//                       }
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _actionCard(BuildContext context,
//       {required IconData icon,
//         required String title,
//         required String subtitle,
//         required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 28,
//                 backgroundColor: Colors.deepPurple.shade50,
//                 child: Icon(icon, size: 30, color: Colors.deepPurple),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 4),
//                     Text(subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         )),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: Colors.deepPurple, size: 18),
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
// import 'RecognitionScreen.dart';
// import 'RegisteredFacesScreen.dart';
// import 'RegistrationScreen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final bool voiceNavigationEnabled; // ✅ receives flag from FeatureScreen
//
//   const HomeScreen({super.key, required this.voiceNavigationEnabled});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool _isActive = true;
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initVoiceSystem();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _speechToText.stop();
//     _flutterTts.stop();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initVoiceSystem() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && widget.voiceNavigationEnabled) {
//       await _speakOptions();
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please enable microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   // 🗣️ Speak available options
//   Future<void> _speakOptions() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     const message =
//         "You are in the Face Recognition module. You can say: Register a new face, Recognize face, or Manage faces. Which one would you like to open?";
//
//     await _flutterTts.stop();
//     await _speechToText.stop();
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.speak(message);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     await _playBeepSound();
//     await _captureVoice();
//   }
//
//   // 🔊 Play beep before listening
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       print("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   // 🎙️ Capture user voice
//   Future<void> _captureVoice() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (!_isActive) return;
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && widget.voiceNavigationEnabled) {
//             await _playBeepSound();
//             await _captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         if (!_isActive) return;
//         await Future.delayed(const Duration(seconds: 1));
//         if (_isActive && widget.voiceNavigationEnabled) {
//           await _playBeepSound();
//           await _captureVoice();
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
//           if (!_isActive || !widget.voiceNavigationEnabled) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _handleVoiceCommand(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   // 🧠 Handle recognized voice commands
//   Future<void> _handleVoiceCommand(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? targetScreen;
//     String? featureName;
//
//     if (command.contains("register")) {
//       targetScreen = RegistrationScreen();
//       featureName = "Register a new face";
//     } else if (command.contains("recognize") ||
//         command.contains("recognition") ||
//         command.contains("detect")) {
//       targetScreen = const RecognitionScreen();
//       featureName = "Recognize face";
//     } else if (command.contains("manage") ||
//         command.contains("registered") ||
//         command.contains("faces")) {
//       targetScreen = const RegisteredFacesScreen();
//       featureName = "Manage faces";
//     }
//
//     if (targetScreen != null) {
//       _hasNavigated = true;
//       _isActive = false;
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module.");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => targetScreen!),
//         );
//
//         // Reactivate when user returns
//         _hasNavigated = false;
//         _isActive = true;
//         if (widget.voiceNavigationEnabled) await _speakOptions();
//       }
//     } else {
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Register face, Recognize face, or Manage faces.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await _captureVoice();
//     }
//   }
//
//   // 🧱 UI
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6FA),
//       appBar: AppBar(
//         backgroundColor: Colors.deepPurple,
//         title: const Text("Face Recognition"),
//         actions: [
//           // 🎚️ Visual indicator for voice mode
//           Row(
//             children: [
//               const Text("Voice", style: TextStyle(color: Colors.white)),
//               Icon(
//                 widget.voiceNavigationEnabled ? Icons.mic : Icons.mic_off,
//                 color: Colors.white,
//               ),
//               const SizedBox(width: 16),
//             ],
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 24),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.tag_faces, size: 30, color: Colors.deepPurple),
//                   SizedBox(width: 10),
//                   Text(
//                     "Face Recognition",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             Center(
//               child: Container(
//                 width: screenWidth * 0.55,
//                 height: screenWidth * 0.55,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.deepPurple.withAlpha(80),
//                       spreadRadius: 5,
//                       blurRadius: 15,
//                       offset: const Offset(0, 10),
//                     ),
//                   ],
//                   image: const DecorationImage(
//                     image: AssetImage("assets/images/scan.png"),
//                     fit: BoxFit.fitWidth,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//
//             // 📋 Action Buttons
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//                 child: Column(
//                   children: [
//                     _actionCard(
//                       context,
//                       icon: Icons.person_add,
//                       title: "Register New Face",
//                       subtitle: "Capture and store a new user face",
//                       onTap: () async {
//                         _isActive = false;
//                         await _flutterTts.stop();
//                         await _speechToText.stop();
//                         await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => RegistrationScreen(),
//                           ),
//                         );
//                         _isActive = true;
//                         if (widget.voiceNavigationEnabled) await _speakOptions();
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     _actionCard(
//                       context,
//                       icon: Icons.search,
//                       title: "Recognize Face",
//                       subtitle: "Identify registered faces in real-time",
//                       onTap: () async {
//                         _isActive = false;
//                         await _flutterTts.stop();
//                         await _speechToText.stop();
//                         await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (_) => const RecognitionScreen()),
//                         );
//                         _isActive = true;
//                         if (widget.voiceNavigationEnabled) await _speakOptions();
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     _actionCard(
//                       context,
//                       icon: Icons.list,
//                       title: "Registered Faces",
//                       subtitle: "View all stored face data",
//                       onTap: () async {
//                         _isActive = false;
//                         await _flutterTts.stop();
//                         await _speechToText.stop();
//                         await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (_) => const RegisteredFacesScreen()),
//                         );
//                         _isActive = true;
//                         if (widget.voiceNavigationEnabled) await _speakOptions();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // 🧱 Helper widget for button cards
//   Widget _actionCard(
//       BuildContext context, {
//         required IconData icon,
//         required String title,
//         required String subtitle,
//         required VoidCallback onTap,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 28,
//                 backgroundColor: Colors.deepPurple.shade50,
//                 child: Icon(icon, size: 30, color: Colors.deepPurple),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 4),
//                     Text(subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         )),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: Colors.deepPurple, size: 18),
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
// import 'RecognitionScreen.dart';
// import 'RegisteredFacesScreen.dart';
// import 'RegistrationScreen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const HomeScreen({super.key, required this.voiceNavigationEnabled});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool _isActive = true;
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initVoiceSystem();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _speechToText.stop();
//     _flutterTts.stop();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initVoiceSystem() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && widget.voiceNavigationEnabled) {
//       await _speakOptions();
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please enable microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   Future<void> _speakOptions() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     const message =
//         "You are in the Face Recognition module. You can say: Register a new face, Recognize face, or Manage faces. Which one would you like to open?";
//
//     await _flutterTts.stop();
//     await _speechToText.stop();
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.speak(message);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     await _playBeepSound();
//     await _captureVoice();
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
//   Future<void> _captureVoice() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (!_isActive) return;
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && widget.voiceNavigationEnabled) {
//             await _playBeepSound();
//             await _captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         if (!_isActive) return;
//         await Future.delayed(const Duration(seconds: 1));
//         if (_isActive && widget.voiceNavigationEnabled) {
//           await _playBeepSound();
//           await _captureVoice();
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
//           if (!_isActive || !widget.voiceNavigationEnabled) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _handleVoiceCommand(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _handleVoiceCommand(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? targetScreen;
//     String? featureName;
//
//     if (command.contains("register")) {
//       targetScreen = RegistrationScreen();
//       featureName = "Register a new face";
//     } else if (command.contains("recognize") ||
//         command.contains("recognition") ||
//         command.contains("detect")) {
//       targetScreen = const RecognitionScreen();
//       featureName = "Recognize face";
//     } else if (command.contains("manage") ||
//         command.contains("registered") ||
//         command.contains("faces")) {
//       targetScreen = const RegisteredFacesScreen();
//       featureName = "Manage faces";
//     }
//
//     if (targetScreen != null) {
//       _hasNavigated = true;
//       _isActive = false;
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module.");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => targetScreen!),
//         );
//
//         // Re-enable after returning
//         _hasNavigated = false;
//         _isActive = true;
//         if (widget.voiceNavigationEnabled) await _speakOptions();
//       }
//     } else {
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Register face, Recognize face, or Manage faces.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await _captureVoice();
//     }
//   }
//
//   // ✅ Handle back button (hardware or top arrow)
//   Future<bool> _onWillPop() async {
//     _isActive = false;
//     await _speechToText.stop();
//     await _flutterTts.stop();
//
//     // Say goodbye like OCR
//     // await _flutterTts.speak("Welcome to Echonav main menu.");
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     return true; // allow popping
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5F6FA),
//         appBar: AppBar(
//           backgroundColor: Colors.deepPurple,
//           title: const Text("Face Recognition"),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               bool shouldPop = await _onWillPop();
//               if (shouldPop && mounted) Navigator.pop(context);
//             },
//           ),
//           actions: [
//             Row(
//               children: [
//                 const Text("Voice", style: TextStyle(color: Colors.white)),
//                 Icon(
//                   widget.voiceNavigationEnabled ? Icons.mic : Icons.mic_off,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(width: 16),
//               ],
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.tag_faces,
//                           size: 30, color: Colors.deepPurple),
//                       SizedBox(width: 10),
//                       Text(
//                         "Face Recognition",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   Center(
//                     child: Container(
//                       width: screenWidth * 0.55,
//                       height: screenWidth * 0.55,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.deepPurple.withAlpha(80),
//                             spreadRadius: 5,
//                             blurRadius: 15,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                         image: const DecorationImage(
//                           image: AssetImage("assets/images/scan.png"),
//                           fit: BoxFit.fitWidth,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   _actionCard(
//                     context,
//                     icon: Icons.person_add,
//                     title: "Register New Face",
//                     subtitle: "Capture and store a new user face",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _speechToText.stop();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => RegistrationScreen(),
//                         ),
//                       );
//                       _isActive = true;
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   _actionCard(
//                     context,
//                     icon: Icons.search,
//                     title: "Recognize Face",
//                     subtitle: "Identify registered faces in real-time",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _speechToText.stop();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RecognitionScreen()),
//                       );
//                       _isActive = true;
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   _actionCard(
//                     context,
//                     icon: Icons.list,
//                     title: "Registered Faces",
//                     subtitle: "View all stored face data",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _speechToText.stop();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RegisteredFacesScreen()),
//                       );
//                       _isActive = true;
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _actionCard(
//       BuildContext context, {
//         required IconData icon,
//         required String title,
//         required String subtitle,
//         required VoidCallback onTap,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 28,
//                 backgroundColor: Colors.deepPurple.shade50,
//                 child: Icon(icon, size: 30, color: Colors.deepPurple),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 4),
//                     Text(subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         )),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: Colors.deepPurple, size: 18),
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
// import 'RecognitionScreen.dart';
// import 'RegisteredFacesScreen.dart';
// import 'RegistrationScreen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const HomeScreen({super.key, required this.voiceNavigationEnabled});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool _isActive = true;
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initVoiceSystem();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _speechToText.stop();
//     _flutterTts.stop();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initVoiceSystem() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && widget.voiceNavigationEnabled) {
//       await _speakOptions();
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please enable microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   Future<void> _speakOptions() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     const message =
//         "You are in the Face Recognition module. You can say: Register a new face, Recognize face, or Manage faces. Which one would you like to open?";
//
//     await _flutterTts.stop();
//     await _speechToText.stop();
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.speak(message);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     await _playBeepSound();
//     await _captureVoice();
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
//   Future<void> _captureVoice() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (!_isActive) return;
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && widget.voiceNavigationEnabled) {
//             await _playBeepSound();
//             await _captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         if (!_isActive) return;
//         await Future.delayed(const Duration(seconds: 1));
//         if (_isActive && widget.voiceNavigationEnabled) {
//           await _playBeepSound();
//           await _captureVoice();
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
//           if (!_isActive || !widget.voiceNavigationEnabled) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _handleVoiceCommand(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _handleVoiceCommand(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? targetScreen;
//     String? featureName;
//
//     if (command.contains("register")) {
//       targetScreen = RegistrationScreen();
//       featureName = "Register a new face";
//     } else if (command.contains("recognize") ||
//         command.contains("recognition") ||
//         command.contains("detect")) {
//       targetScreen = const RecognitionScreen();
//       featureName = "Recognize face";
//     } else if (command.contains("manage") ||
//         command.contains("registered") ||
//         command.contains("faces")) {
//       targetScreen = const RegisteredFacesScreen();
//       featureName = "Manage faces";
//     }
//
//     if (targetScreen != null) {
//       _hasNavigated = true;
//       _isActive = false;
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module.");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => targetScreen!),
//         );
//
//         // ✅ Re-enable voice after returning
//         _hasNavigated = false;
//         _isActive = true;
//         if (widget.voiceNavigationEnabled) await _speakOptions();
//       }
//     } else {
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Register face, Recognize face, or Manage faces.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await _captureVoice();
//     }
//   }
//
//   // ✅ FIXED: Cleanly stop voice systems on back press, without TTS message
//   Future<bool> _onWillPop() async {
//     _isActive = false;
//     await _speechToText.stop();
//     await _flutterTts.stop();
//     return true; // allow navigation back
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5F6FA),
//         appBar: AppBar(
//           backgroundColor: Colors.deepPurple,
//           title: const Text("Face Recognition"),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               bool shouldPop = await _onWillPop();
//               if (shouldPop && mounted) Navigator.pop(context);
//             },
//           ),
//           actions: [
//             Row(
//               children: [
//                 const Text("Voice", style: TextStyle(color: Colors.white)),
//                 Icon(
//                   widget.voiceNavigationEnabled ? Icons.mic : Icons.mic_off,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(width: 16),
//               ],
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.tag_faces,
//                           size: 30, color: Colors.deepPurple),
//                       SizedBox(width: 10),
//                       Text(
//                         "Face Recognition",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   Center(
//                     child: Container(
//                       width: screenWidth * 0.55,
//                       height: screenWidth * 0.55,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.deepPurple.withAlpha(80),
//                             spreadRadius: 5,
//                             blurRadius: 15,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                         image: const DecorationImage(
//                           image: AssetImage("assets/images/scan.png"),
//                           fit: BoxFit.fitWidth,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   _actionCard(
//                     context,
//                     icon: Icons.person_add,
//                     title: "Register New Face",
//                     subtitle: "Capture and store a new user face",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _speechToText.stop();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => RegistrationScreen(),
//                         ),
//                       );
//                       _isActive = true;
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   _actionCard(
//                     context,
//                     icon: Icons.search,
//                     title: "Recognize Face",
//                     subtitle: "Identify registered faces in real-time",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _speechToText.stop();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RecognitionScreen()),
//                       );
//                       _isActive = true;
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   _actionCard(
//                     context,
//                     icon: Icons.list,
//                     title: "Registered Faces",
//                     subtitle: "View all stored face data",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _speechToText.stop();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RegisteredFacesScreen()),
//                       );
//                       _isActive = true;
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _actionCard(
//       BuildContext context, {
//         required IconData icon,
//         required String title,
//         required String subtitle,
//         required VoidCallback onTap,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 28,
//                 backgroundColor: Colors.deepPurple.shade50,
//                 child: Icon(icon, size: 30, color: Colors.deepPurple),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 4),
//                     Text(subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         )),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: Colors.deepPurple, size: 18),
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
// import 'RecognitionScreen.dart';
// import 'RegisteredFacesScreen.dart';
// import 'RegistrationScreen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const HomeScreen({super.key, required this.voiceNavigationEnabled});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool _isActive = true;
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initVoiceSystem();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _speechToText.stop();
//     _flutterTts.stop();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   // ✅ Initialize voice systems
//   Future<void> _initVoiceSystem() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     var status = await Permission.microphone.request();
//     if (status.isGranted && widget.voiceNavigationEnabled) {
//       await _speakOptions();
//     } else if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please enable microphone permission in settings to use voice navigation.");
//     }
//   }
//
//   // ✅ Speak available commands
//   Future<void> _speakOptions() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     const message =
//         "You are in the Face Recognition module. You can say: Register face, Detect face, or Manage faces. Which one would you like to open?";
//
//     await _flutterTts.stop();
//     await _speechToText.stop();
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.5);
//     await _flutterTts.speak(message);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     await _playBeepSound();
//     await _captureVoice();
//   }
//
//   // ✅ Beep before listening
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       debugPrint("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   // ✅ Start speech recognition loop
//   Future<void> _captureVoice() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (!_isActive) return;
//         if (status == 'notListening' && !_hasNavigated) {
//           // 🔁 Restart listening if nothing recognized
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && widget.voiceNavigationEnabled) {
//             await _playBeepSound();
//             await _captureVoice();
//           }
//         }
//       },
//       onError: (error) async {
//         if (!_isActive) return;
//         debugPrint("🎙 Speech error: ${error.errorMsg}");
//         await Future.delayed(const Duration(seconds: 1));
//         if (_isActive && widget.voiceNavigationEnabled) {
//           await _playBeepSound();
//           await _captureVoice();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 4),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive || !widget.voiceNavigationEnabled) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _handleVoiceCommand(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   // ✅ Handle recognized voice commands
//   Future<void> _handleVoiceCommand(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? targetScreen;
//     String? featureName;
//
//     if (command.contains("register")) {
//       targetScreen = RegistrationScreen();
//       featureName = "Register face";
//     }
//     // else if (command.contains("recognize") ||
//     //     command.contains("recognition") ||
//     //     command.contains("detect")) {
//     //   targetScreen = const RecognitionScreen();
//     //   featureName = "Recognize face";
//     // }
//     else if (command.contains("recognize") ||
//         command.contains("recognition") ||
//         command.contains("detect") ||
//         command.contains("identify")) {
//       targetScreen = const RecognitionScreen();
//       featureName = "Recognize face";
//     }
//
//
//     else if (command.contains("manage") ||
//         command.contains("registered") ||
//         command.contains("faces")) {
//       targetScreen = const RegisteredFacesScreen();
//       featureName = "Manage faces";
//     }
//
//     if (targetScreen != null) {
//       _hasNavigated = true;
//       _isActive = false;
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module.");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => targetScreen!),
//         );
//
//         // ✅ Resume listening after returning
//         _hasNavigated = false;
//         _isActive = true;
//         if (widget.voiceNavigationEnabled) await _speakOptions();
//       }
//     } else {
//       // ⚠️ If unrecognized — say the fallback message and retry
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Register face, Recognize face, or Manage faces.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await _captureVoice();
//     }
//   }
//
//   // ✅ Stop all speech safely on back navigation
//   Future<bool> _onWillPop() async {
//     _isActive = false;
//     await _speechToText.stop();
//     await _flutterTts.stop();
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5F6FA),
//         appBar: AppBar(
//           backgroundColor: Colors.deepPurple,
//           title: const Text("Face Recognition"),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               bool shouldPop = await _onWillPop();
//               if (shouldPop && mounted) Navigator.pop(context);
//             },
//           ),
//           actions: [
//             Row(
//               children: [
//                 const Text("Voice", style: TextStyle(color: Colors.white)),
//                 Icon(
//                   widget.voiceNavigationEnabled ? Icons.mic : Icons.mic_off,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(width: 16),
//               ],
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.tag_faces,
//                           size: 30, color: Colors.deepPurple),
//                       SizedBox(width: 10),
//                       Text(
//                         "Face Recognition",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   Center(
//                     child: Container(
//                       width: screenWidth * 0.55,
//                       height: screenWidth * 0.55,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.deepPurple.withAlpha(80),
//                             spreadRadius: 5,
//                             blurRadius: 15,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                         image: const DecorationImage(
//                           image: AssetImage("assets/images/scan.png"),
//                           fit: BoxFit.fitWidth,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//
//                   // 🔹 Register New Face Button
//                   _actionCard(
//                     context,
//                     icon: Icons.person_add,
//                     title: "Register New Face",
//                     subtitle: "Capture and store a new user face",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _speechToText.stop();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => RegistrationScreen(),
//                         ),
//                       );
//                       _isActive = true;
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//
//                   // 🔹 Recognize Face Button
//                   _actionCard(
//                     context,
//                     icon: Icons.search,
//                     title: "Recognize Face",
//                     subtitle: "Identify registered faces in real-time",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _speechToText.stop();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RecognitionScreen()),
//                       );
//                       _isActive = true;
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//
//                   // 🔹 Manage Faces Button
//                   _actionCard(
//                     context,
//                     icon: Icons.list,
//                     title: "Registered Faces",
//                     subtitle: "View all stored face data",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _speechToText.stop();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RegisteredFacesScreen()),
//                       );
//                       _isActive = true;
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ✅ Card builder for each option
//   Widget _actionCard(
//       BuildContext context, {
//         required IconData icon,
//         required String title,
//         required String subtitle,
//         required VoidCallback onTap,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 28,
//                 backgroundColor: Colors.deepPurple.shade50,
//                 child: Icon(icon, size: 30, color: Colors.deepPurple),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 4),
//                     Text(subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         )),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: Colors.deepPurple, size: 18),
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
// import 'RecognitionScreen.dart';
// import 'RegisteredFacesScreen.dart';
// import 'RegistrationScreen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const HomeScreen({super.key, required this.voiceNavigationEnabled});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool _isActive = true;
//   bool _ttsSpeaking = false;
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initVoiceSystem();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _speechToText.stop();
//     _flutterTts.stop();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initVoiceSystem() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     _flutterTts.setLanguage("en-US");
//     _flutterTts.setPitch(1.0);
//     _flutterTts.setSpeechRate(0.5);
//
//     var status = await Permission.microphone.request();
//     if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please enable microphone permission in settings to use voice navigation.");
//       return;
//     }
//
//     if (widget.voiceNavigationEnabled) {
//       // ✅ Speak options first, then start STT
//       await _speakOptions();
//     }
//   }
//
//   // Speak options and only then start microphone
//   Future<void> _speakOptions() async {
//     if (!_isActive || !widget.voiceNavigationEnabled) return;
//
//     const message =
//         "You are in the Face Recognition module. You can say: Register face, Detect face, or Manage faces. Which one would you like to open?";
//
//     _ttsSpeaking = true;
//
//     await _flutterTts.stop();
//     await _flutterTts.speak(message);
//     await _flutterTts.awaitSpeakCompletion(true);
//
//     _ttsSpeaking = false;
//
//     if (!_isActive) return;
//
//     // ✅ Only after TTS finished, play beep and start listening
//     await _playBeepSound();
//     if (_isActive && widget.voiceNavigationEnabled) {
//       await _startListening();
//     }
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       debugPrint("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   // Start STT after TTS finished
//   Future<void> _startListening() async {
//     if (!_isActive || _ttsSpeaking) return;
//
//     bool available = await _speechToText.initialize(
//       onStatus: (status) async {
//         if (!_isActive) return;
//         if (status == 'notListening' && !_hasNavigated) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && widget.voiceNavigationEnabled) {
//             await _playBeepSound();
//             await _startListening();
//           }
//         }
//       },
//       onError: (error) async {
//         if (!_isActive) return;
//         debugPrint("🎙 Speech error: ${error.errorMsg}");
//         await Future.delayed(const Duration(seconds: 1));
//         if (_isActive && widget.voiceNavigationEnabled) {
//           await _playBeepSound();
//           await _startListening();
//         }
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 4),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive || !widget.voiceNavigationEnabled) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _handleVoiceCommand(text.toLowerCase());
//           }
//         },
//       );
//     } else {
//       await _flutterTts.speak(
//           "Speech recognition is not available on this device.");
//     }
//   }
//
//   Future<void> _handleVoiceCommand(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? targetScreen;
//     String? featureName;
//
//     if (command.contains("register")) {
//       targetScreen = RegistrationScreen();
//       featureName = "Register face";
//     } else if (command.contains("recognize") ||
//         command.contains("recognition") ||
//         command.contains("detect") ||
//         command.contains("identify")) {
//       targetScreen = const RecognitionScreen();
//       featureName = "Recognize face";
//     } else if (command.contains("manage") ||
//         command.contains("registered") ||
//         command.contains("faces")) {
//       targetScreen = const RegisteredFacesScreen();
//       featureName = "Manage faces";
//     }
//
//     if (targetScreen != null) {
//       _hasNavigated = true;
//       _isActive = false;
//       await _flutterTts.stop();
//       await _speechToText.stop();
//       setState(() => isListening = false);
//
//       await _flutterTts.speak("Opening $featureName module.");
//       await _flutterTts.awaitSpeakCompletion(true);
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => targetScreen!),
//         );
//
//         // Resume TTS/STT after returning
//         _hasNavigated = false;
//         _isActive = true;
//         if (widget.voiceNavigationEnabled) await _speakOptions();
//       }
//     } else {
//       // Fallback for unrecognized command
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Register face, Recognize face, or Manage faces.");
//       await _flutterTts.awaitSpeakCompletion(true);
//       await _playBeepSound();
//       await _startListening();
//     }
//   }
//
//   Future<bool> _onWillPop() async {
//     _isActive = false;
//     await _speechToText.stop();
//     await _flutterTts.stop();
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5F6FA),
//         appBar: AppBar(
//           backgroundColor: Colors.deepPurple,
//           title: const Text("Face Recognition"),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               bool shouldPop = await _onWillPop();
//               if (shouldPop && mounted) Navigator.pop(context);
//             },
//           ),
//           actions: [
//             Row(
//               children: [
//                 const Text("Voice", style: TextStyle(color: Colors.white)),
//                 Icon(
//                   widget.voiceNavigationEnabled ? Icons.mic : Icons.mic_off,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(width: 16),
//               ],
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.tag_faces, size: 30, color: Colors.deepPurple),
//                       SizedBox(width: 10),
//                       Text(
//                         "Face Recognition",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   Center(
//                     child: Container(
//                       width: screenWidth * 0.55,
//                       height: screenWidth * 0.55,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.deepPurple.withAlpha(80),
//                             spreadRadius: 5,
//                             blurRadius: 15,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                         image: const DecorationImage(
//                           image: AssetImage("assets/images/scan.png"),
//                           fit: BoxFit.fitWidth,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//
//                   _actionCard(
//                     context,
//                     icon: Icons.person_add,
//                     title: "Register New Face",
//                     subtitle: "Capture and store a new user face",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _speechToText.stop();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => RegistrationScreen(),
//                         ),
//                       );
//                       _isActive = true;
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   _actionCard(
//                     context,
//                     icon: Icons.search,
//                     title: "Recognize Face",
//                     subtitle: "Identify registered faces in real-time",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _speechToText.stop();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RecognitionScreen()),
//                       );
//                       _isActive = true;
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   _actionCard(
//                     context,
//                     icon: Icons.list,
//                     title: "Registered Faces",
//                     subtitle: "View all stored face data",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _speechToText.stop();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RegisteredFacesScreen()),
//                       );
//                       _isActive = true;
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _actionCard(
//       BuildContext context, {
//         required IconData icon,
//         required String title,
//         required String subtitle,
//         required VoidCallback onTap,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 28,
//                 backgroundColor: Colors.deepPurple.shade50,
//                 child: Icon(icon, size: 30, color: Colors.deepPurple),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 4),
//                     Text(subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         )),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: Colors.deepPurple, size: 18),
//             ],
//           ),
//         ),
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
// import 'RecognitionScreen.dart';
// import 'RegisteredFacesScreen.dart';
// import 'RegistrationScreen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const HomeScreen({super.key, required this.voiceNavigationEnabled});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool _isActive = true;
//   bool _ttsSpeaking = false;
//   bool _listeningRequested = false;
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initVoiceSystem();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _stopSttQuietly();
//     _flutterTts.stop();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   Future<void> _stopSttQuietly() async {
//     try {
//       // cancel is safer to fully stop any ongoing session
//       if (_speechToText != null) {
//         await _speechToText.cancel();
//         await _speechToText.stop();
//       }
//     } catch (_) {
//       // ignore
//     } finally {
//       setState(() => isListening = false);
//       _listeningRequested = false;
//     }
//   }
//
//   Future<void> _initVoiceSystem() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setPitch(1.0);
//     await _flutterTts.setSpeechRate(0.5);
//
//     var status = await Permission.microphone.request();
//     if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please enable microphone permission in settings to use voice navigation.");
//       return;
//     }
//
//     if (widget.voiceNavigationEnabled) {
//       // Speak options first, then start STT
//       await _speakOptions();
//     }
//   }
//
//   // Speak options and only then start microphone
//   Future<void> _speakOptions() async {
//     if (!_isActive || !widget.voiceNavigationEnabled) return;
//
//     const message =
//         "You are in the Face Recognition module. You can say: Register face, Detect face, or Manage faces. Which one would you like to open?";
//
//     // Prevent overlapping attempts
//     if (_ttsSpeaking) return;
//     _ttsSpeaking = true;
//
//     try {
//       await _flutterTts.stop();
//       await _flutterTts.speak(message);
//
//       // Some flutter_tts versions: awaitSpeakCompletion(true) helps ensure completion
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {
//         // If awaitSpeakCompletion isn't supported or fails, try a short fallback delay
//         await Future.delayed(const Duration(milliseconds: 800));
//       }
//     } catch (e) {
//       debugPrint("TTS speak error: $e");
//     } finally {
//       _ttsSpeaking = false;
//     }
//
//     if (!_isActive) return;
//
//     // Small delay to give OS time to handback microphone to STT (helps with some plugins)
//     await Future.delayed(const Duration(milliseconds: 250));
//
//     // play beep then start listening
//     await _playBeepSound();
//
//     if (_isActive && widget.voiceNavigationEnabled) {
//       await _startListening();
//     }
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       // Ensure you're including assets/sounds/beep.mp3 in pubspec.yaml
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (e) {
//       debugPrint("⚠️ Beep missing or invalid: $e");
//     }
//   }
//
//   // Start STT after TTS finished. Uses guards and small delays to avoid mic race.
//   Future<void> _startListening() async {
//     if (!_isActive || _ttsSpeaking || _listeningRequested) return;
//
//     _listeningRequested = true;
//
//     // Ensure microphone permission before initializing
//     final perm = await Permission.microphone.status;
//     if (!perm.isGranted) {
//       final req = await Permission.microphone.request();
//       if (!req.isGranted) {
//         await _flutterTts.speak("Microphone permission is required for voice navigation.");
//         _listeningRequested = false;
//         return;
//       }
//     }
//
//     // Ensure STT is fully stopped/cancelled before initialize
//     try {
//       await _speechToText.cancel();
//       await Future.delayed(const Duration(milliseconds: 150));
//     } catch (_) {}
//
//     bool available = false;
//     try {
//       available = await _speechToText.initialize(
//         onStatus: (status) async {
//           if (!_isActive) return;
//           debugPrint("STT status: $status");
//           // If STT reports it's notListening and we haven't navigated, re-prompt after a short delay
//           if (status == 'notListening' && !_hasNavigated && widget.voiceNavigationEnabled) {
//             setState(() => isListening = false);
//             // small cooldown then restart listening flow
//             await Future.delayed(const Duration(seconds: 1));
//             if (_isActive && widget.voiceNavigationEnabled) {
//               await _playBeepSound();
//               _listeningRequested = false; // allow start again
//               await _startListening();
//             }
//           } else if (status == 'listening') {
//             setState(() => isListening = true);
//           }
//         },
//         onError: (error) async {
//           if (!_isActive) return;
//           debugPrint("🎙 Speech error: ${error.errorMsg}");
//           setState(() => isListening = false);
//           _listeningRequested = false;
//           // Try to recover after a short delay
//           await Future.delayed(const Duration(seconds: 1));
//           if (_isActive && widget.voiceNavigationEnabled) {
//             await _playBeepSound();
//             await _startListening();
//           }
//         },
//       );
//     } catch (e) {
//       debugPrint("STT initialize exception: $e");
//     }
//
//     if (!available) {
//       _listeningRequested = false;
//       await _flutterTts.speak("Speech recognition is not available on this device.");
//       return;
//     }
//
//     // Small delay to ensure the microphone is not still being used by the previous screen
//     await Future.delayed(const Duration(milliseconds: 200));
//
//     try {
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 4),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive || !widget.voiceNavigationEnabled) return;
//           setState(() => text = result.recognizedWords);
//           if (result.finalResult && text.isNotEmpty) {
//             _listeningRequested = false;
//             _handleVoiceCommand(text.toLowerCase());
//           }
//         },
//       );
//       setState(() => isListening = true);
//     } catch (e) {
//       debugPrint("STT listen exception: $e");
//       _listeningRequested = false;
//       setState(() => isListening = false);
//     }
//   }
//
//   Future<void> _handleVoiceCommand(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? targetScreen;
//     String? featureName;
//
//     if (command.contains("register")) {
//       targetScreen = RegistrationScreen();
//       featureName = "Register face";
//     } else if (command.contains("recognize") ||
//         command.contains("recognition") ||
//         command.contains("detect") ||
//         command.contains("identify")) {
//       targetScreen = const RecognitionScreen();
//       featureName = "Recognize face";
//     } else if (command.contains("manage") ||
//         command.contains("registered") ||
//         command.contains("faces")) {
//       targetScreen = const RegisteredFacesScreen();
//       featureName = "Manage faces";
//     }
//
//     if (targetScreen != null) {
//       _hasNavigated = true;
//       _isActive = false;
//
//       // Make sure STT/TTS both stopped before navigating
//       await _flutterTts.stop();
//       await _stopSttQuietly();
//       setState(() => isListening = false);
//
//       // Give a tiny delay to ensure native resources are freed (helps especially with camera/mic)
//       await Future.delayed(const Duration(milliseconds: 150));
//
//       await _flutterTts.speak("Opening $featureName module.");
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {
//         await Future.delayed(const Duration(milliseconds: 500));
//       }
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => targetScreen!),
//         );
//
//         // After returning from child, allow a short cooldown to let other plugins release the mic
//         _hasNavigated = false;
//         _isActive = true;
//
//         // Tiny cooldown to avoid mic race (especially for Recognize screen)
//         await Future.delayed(const Duration(milliseconds: 500));
//
//         if (widget.voiceNavigationEnabled) await _speakOptions();
//       }
//     } else {
//       // Fallback for unrecognized command
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Register face, Recognize face, or Manage faces.");
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {
//         await Future.delayed(const Duration(milliseconds: 400));
//       }
//       await _playBeepSound();
//       // Reset listening guard so we can attempt again
//       _listeningRequested = false;
//       await _startListening();
//     }
//   }
//
//   Future<bool> _onWillPop() async {
//     _isActive = false;
//     await _stopSttQuietly();
//     await _flutterTts.stop();
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5F6FA),
//         appBar: AppBar(
//           backgroundColor: Colors.deepPurple,
//           title: const Text("Face Recognition"),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               bool shouldPop = await _onWillPop();
//               if (shouldPop && mounted) Navigator.pop(context);
//             },
//           ),
//           actions: [
//             Row(
//               children: [
//                 const Text("Voice", style: TextStyle(color: Colors.white)),
//                 Icon(
//                   widget.voiceNavigationEnabled ? Icons.mic : Icons.mic_off,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(width: 16),
//               ],
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.tag_faces, size: 30, color: Colors.deepPurple),
//                       SizedBox(width: 10),
//                       Text(
//                         "Face Recognition",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   Center(
//                     child: Container(
//                       width: screenWidth * 0.55,
//                       height: screenWidth * 0.55,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.deepPurple.withAlpha(80),
//                             spreadRadius: 5,
//                             blurRadius: 15,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                         image: const DecorationImage(
//                           image: AssetImage("assets/images/scan.png"),
//                           fit: BoxFit.fitWidth,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//
//                   _actionCard(
//                     context,
//                     icon: Icons.person_add,
//                     title: "Register New Face",
//                     subtitle: "Capture and store a new user face",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => RegistrationScreen(),
//                         ),
//                       );
//                       _isActive = true;
//                       // small cooldown then resume voice flow
//                       await Future.delayed(const Duration(milliseconds: 500));
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   _actionCard(
//                     context,
//                     icon: Icons.search,
//                     title: "Recognize Face",
//                     subtitle: "Identify registered faces in real-time",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RecognitionScreen()),
//                       );
//                       _isActive = true;
//                       // Increase cooldown specifically for Recognize screen (often uses camera/mic)
//                       await Future.delayed(const Duration(milliseconds: 700));
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   _actionCard(
//                     context,
//                     icon: Icons.list,
//                     title: "Registered Faces",
//                     subtitle: "View all stored face data",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RegisteredFacesScreen()),
//                       );
//                       _isActive = true;
//                       await Future.delayed(const Duration(milliseconds: 500));
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _actionCard(
//       BuildContext context, {
//         required IconData icon,
//         required String title,
//         required String subtitle,
//         required VoidCallback onTap,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 28,
//                 backgroundColor: Colors.deepPurple.shade50,
//                 child: Icon(icon, size: 30, color: Colors.deepPurple),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 4),
//                     Text(subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         )),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: Colors.deepPurple, size: 18),
//             ],
//           ),
//         ),
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
// import 'RecognitionScreen.dart';
// import 'RegisteredFacesScreen.dart';
// import 'RegistrationScreen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const HomeScreen({super.key, required this.voiceNavigationEnabled});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool _isActive = true;
//   bool _ttsSpeaking = false;
//   bool _listeningRequested = false;
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initVoiceSystem();
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _stopSttQuietly();
//     _flutterTts.stop();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   Future<void> _stopSttQuietly() async {
//     try {
//       await _speechToText.cancel();
//       await _speechToText.stop();
//     } catch (_) {}
//     setState(() => isListening = false);
//     _listeningRequested = false;
//   }
//
//   // --------------------------------------------
//   // INITIALIZATION UPDATED HERE
//   // --------------------------------------------
//   Future<void> _initVoiceSystem() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setPitch(1.0);
//     await _flutterTts.setSpeechRate(0.5);
//
//     var status = await Permission.microphone.request();
//
//     // 🔹 Voice Navigation is OFF → Only speak simple message
//     if (!widget.voiceNavigationEnabled) {
//       await _flutterTts.speak("You are in the Face Recognition module.");
//       return;
//     }
//
//     // 🔹 Voice Navigation ON but mic permission missing
//     if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please enable microphone permission in settings to use voice navigation.");
//       return;
//     }
//
//     // 🔹 Voice Navigation is ON → Speak full options
//     await _speakOptions();
//   }
//
//   // --------------------------------------------
//   // SPEAK OPTIONS UPDATED WITH TWO MODES
//   // --------------------------------------------
//   Future<void> _speakOptions() async {
//     if (!_isActive) return;
//
//     String message;
//
//     if (widget.voiceNavigationEnabled) {
//       message =
//       "You are in the Face Recognition module. You can say: Register face, Detect face, or Manage faces. Which one would you like to open?";
//     } else {
//       // This will not run normally because we block earlier, but kept as safe fallback
//       message = "You are in the Face Recognition module.";
//     }
//
//     if (_ttsSpeaking) return;
//     _ttsSpeaking = true;
//
//     try {
//       await _flutterTts.stop();
//       await _flutterTts.speak(message);
//
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {
//         await Future.delayed(const Duration(milliseconds: 800));
//       }
//     } finally {
//       _ttsSpeaking = false;
//     }
//
//     // If voice navigation is OFF → DO NOT START LISTENING
//     if (!widget.voiceNavigationEnabled) return;
//
//     // Small delay before STT
//     await Future.delayed(const Duration(milliseconds: 250));
//
//     await _playBeepSound();
//     await _startListening();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (_) {}
//   }
//
//   Future<void> _startListening() async {
//     if (!_isActive || _ttsSpeaking || _listeningRequested) return;
//
//     _listeningRequested = true;
//
//     final perm = await Permission.microphone.status;
//     if (!perm.isGranted) {
//       if (!(await Permission.microphone.request()).isGranted) {
//         await _flutterTts.speak("Microphone permission is required.");
//         _listeningRequested = false;
//         return;
//       }
//     }
//
//     try {
//       await _speechToText.cancel();
//       await Future.delayed(const Duration(milliseconds: 150));
//     } catch (_) {}
//
//     bool available = false;
//     try {
//       available = await _speechToText.initialize(
//         onStatus: (status) async {
//           if (!_isActive) return;
//
//           if (status == 'notListening' && !_hasNavigated) {
//             setState(() => isListening = false);
//             await Future.delayed(const Duration(seconds: 1));
//             await _playBeepSound();
//             _listeningRequested = false;
//             await _startListening();
//           } else if (status == 'listening') {
//             setState(() => isListening = true);
//           }
//         },
//         onError: (error) async {
//           if (!_isActive) return;
//           setState(() => isListening = false);
//           _listeningRequested = false;
//
//           await Future.delayed(const Duration(seconds: 1));
//           await _playBeepSound();
//           await _startListening();
//         },
//       );
//     } catch (_) {}
//
//     if (!available) {
//       _listeningRequested = false;
//       await _flutterTts.speak("Speech recognition is not available.");
//       return;
//     }
//
//     await Future.delayed(const Duration(milliseconds: 200));
//
//     try {
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 4),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive) return;
//
//           setState(() => text = result.recognizedWords);
//
//           if (result.finalResult && text.isNotEmpty) {
//             _listeningRequested = false;
//             _handleVoiceCommand(text.toLowerCase());
//           }
//         },
//       );
//       setState(() => isListening = true);
//     } catch (_) {
//       _listeningRequested = false;
//       setState(() => isListening = false);
//     }
//   }
//
//   Future<void> _handleVoiceCommand(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? targetScreen;
//     String? featureName;
//
//     if (command.contains("register")) {
//       targetScreen = RegistrationScreen();
//       featureName = "Register face";
//     } else if (command.contains("recognize") ||
//         command.contains("detect") ||
//         command.contains("identify")) {
//       targetScreen = const RecognitionScreen();
//       featureName = "Recognize face";
//     } else if (command.contains("manage") ||
//         command.contains("faces")) {
//       targetScreen = const RegisteredFacesScreen();
//       featureName = "Manage faces";
//     }
//
//     if (targetScreen != null) {
//       _hasNavigated = true;
//       _isActive = false;
//
//       await _flutterTts.stop();
//       await _stopSttQuietly();
//
//       await Future.delayed(const Duration(milliseconds: 150));
//
//       await _flutterTts.speak("Opening $featureName module.");
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {}
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => targetScreen!),
//         );
//
//         _hasNavigated = false;
//         _isActive = true;
//
//         await Future.delayed(const Duration(milliseconds: 500));
//
//         if (widget.voiceNavigationEnabled) await _speakOptions();
//       }
//     } else {
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Register face, Recognize face, or Manage faces.");
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {}
//       await _playBeepSound();
//       _listeningRequested = false;
//       await _startListening();
//     }
//   }
//
//   Future<bool> _onWillPop() async {
//     _isActive = false;
//     await _stopSttQuietly();
//     await _flutterTts.stop();
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5F6FA),
//         appBar: AppBar(
//           backgroundColor: Colors.deepPurple,
//           title: const Text("Face Recognition"),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               bool shouldPop = await _onWillPop();
//               if (shouldPop && mounted) Navigator.pop(context);
//             },
//           ),
//           actions: [
//             Row(
//               children: [
//                 const Text("Voice", style: TextStyle(color: Colors.white)),
//                 Icon(
//                   widget.voiceNavigationEnabled ? Icons.mic : Icons.mic_off,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(width: 16),
//               ],
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.tag_faces, size: 30, color: Colors.deepPurple),
//                       SizedBox(width: 10),
//                       Text(
//                         "Face Recognition",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   Center(
//                     child: Container(
//                       width: screenWidth * 0.55,
//                       height: screenWidth * 0.55,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.deepPurple.withOpacity(0.3),
//                             spreadRadius: 5,
//                             blurRadius: 15,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                         image: const DecorationImage(
//                           image: AssetImage("assets/images/scan.png"),
//                           fit: BoxFit.fitWidth,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//
//                   // Buttons
//                   _actionCard(
//                     context,
//                     icon: Icons.person_add,
//                     title: "Register New Face",
//                     subtitle: "Capture and store a new user face",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => RegistrationScreen(),
//                         ),
//                       );
//                       _isActive = true;
//                       await Future.delayed(const Duration(milliseconds: 500));
//
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//
//                   _actionCard(
//                     context,
//                     icon: Icons.search,
//                     title: "Recognize Face",
//                     subtitle: "Identify registered faces in real-time",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RecognitionScreen()),
//                       );
//                       _isActive = true;
//
//                       await Future.delayed(const Duration(milliseconds: 700));
//
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//
//                   _actionCard(
//                     context,
//                     icon: Icons.list,
//                     title: "Registered Faces",
//                     subtitle: "View all stored face data",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RegisteredFacesScreen()),
//                       );
//                       _isActive = true;
//
//                       await Future.delayed(const Duration(milliseconds: 500));
//
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
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
//   Widget _actionCard(
//       BuildContext context, {
//         required IconData icon,
//         required String title,
//         required String subtitle,
//         required VoidCallback onTap,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 28,
//                 backgroundColor: Colors.deepPurple.shade50,
//                 child: Icon(icon, size: 30, color: Colors.deepPurple),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 4),
//                     Text(subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         )),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: Colors.deepPurple, size: 18),
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
// import 'RecognitionScreen.dart';
// import 'RegisteredFacesScreen.dart';
// import 'RegistrationScreen.dart';
//
// // Global RouteObserver to track page transitions
// final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
//
// class HomeScreen extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const HomeScreen({super.key, required this.voiceNavigationEnabled});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with RouteAware {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool _isActive = true;
//   bool _ttsSpeaking = false;
//   bool _listeningRequested = false;
//   String text = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initVoiceSystem();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Subscribe to route changes
//     routeObserver.subscribe(this, ModalRoute.of(context)!);
//   }
//
//   @override
//   void dispose() {
//     routeObserver.unsubscribe(this);
//     _isActive = false;
//     _stopSttQuietly();
//     _flutterTts.stop();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   // 🔹 Called when a child route is popped and this page becomes visible again
//   @override
//   void didPopNext() {
//     _isActive = true;
//     if (widget.voiceNavigationEnabled) {
//       _speakOptions();
//     } else {
//       _flutterTts.speak("You are in the Face Recognition module.");
//     }
//   }
//
//   Future<void> _stopSttQuietly() async {
//     try {
//       await _speechToText.cancel();
//       await _speechToText.stop();
//     } catch (_) {}
//     setState(() => isListening = false);
//     _listeningRequested = false;
//   }
//
//   Future<void> _initVoiceSystem() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setPitch(1.0);
//     await _flutterTts.setSpeechRate(0.5);
//
//     var status = await Permission.microphone.request();
//
//     if (!widget.voiceNavigationEnabled) {
//       await _flutterTts.speak("You are in the Face Recognition module.");
//       return;
//     }
//
//     if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please enable microphone permission in settings to use voice navigation.");
//       return;
//     }
//
//     await _speakOptions();
//   }
//
//   Future<void> _speakOptions() async {
//     if (!_isActive) return;
//
//     String message = widget.voiceNavigationEnabled
//         ? "You are in the Face Recognition module. You can say: Register face, Detect face, or Manage faces. Which one would you like to open?"
//         : "You are in the Face Recognition module.";
//
//     if (_ttsSpeaking) return;
//     _ttsSpeaking = true;
//
//     try {
//       await _flutterTts.stop();
//       await _flutterTts.speak(message);
//
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {
//         await Future.delayed(const Duration(milliseconds: 800));
//       }
//     } finally {
//       _ttsSpeaking = false;
//     }
//
//     if (!widget.voiceNavigationEnabled) return;
//
//     await Future.delayed(const Duration(milliseconds: 250));
//     await _playBeepSound();
//     await _startListening();
//   }
//
//   Future<void> _playBeepSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (_) {}
//   }
//
//   Future<void> _startListening() async {
//     if (!_isActive || _ttsSpeaking || _listeningRequested) return;
//
//     _listeningRequested = true;
//
//     final perm = await Permission.microphone.status;
//     if (!perm.isGranted) {
//       if (!(await Permission.microphone.request()).isGranted) {
//         await _flutterTts.speak("Microphone permission is required.");
//         _listeningRequested = false;
//         return;
//       }
//     }
//
//     try {
//       await _speechToText.cancel();
//       await Future.delayed(const Duration(milliseconds: 150));
//     } catch (_) {}
//
//     bool available = false;
//     try {
//       available = await _speechToText.initialize(
//         onStatus: (status) async {
//           if (!_isActive) return;
//
//           if (status == 'notListening' && !_hasNavigated) {
//             setState(() => isListening = false);
//             await Future.delayed(const Duration(seconds: 1));
//             await _playBeepSound();
//             _listeningRequested = false;
//             await _startListening();
//           } else if (status == 'listening') {
//             setState(() => isListening = true);
//           }
//         },
//         onError: (error) async {
//           if (!_isActive) return;
//           setState(() => isListening = false);
//           _listeningRequested = false;
//
//           await Future.delayed(const Duration(seconds: 1));
//           await _playBeepSound();
//           await _startListening();
//         },
//       );
//     } catch (_) {}
//
//     if (!available) {
//       _listeningRequested = false;
//       await _flutterTts.speak("Speech recognition is not available.");
//       return;
//     }
//
//     await Future.delayed(const Duration(milliseconds: 200));
//
//     try {
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 4),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive) return;
//
//           setState(() => text = result.recognizedWords);
//
//           if (result.finalResult && text.isNotEmpty) {
//             _listeningRequested = false;
//             _handleVoiceCommand(text.toLowerCase());
//           }
//         },
//       );
//       setState(() => isListening = true);
//     } catch (_) {
//       _listeningRequested = false;
//       setState(() => isListening = false);
//     }
//   }
//
//   Future<void> _handleVoiceCommand(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? targetScreen;
//     String? featureName;
//
//     if (command.contains("register")) {
//       targetScreen = RegistrationScreen();
//       featureName = "Register face";
//     } else if (command.contains("recognize") ||
//         command.contains("detect") ||
//         command.contains("identify")) {
//       targetScreen = const RecognitionScreen();
//       featureName = "Recognize face";
//     } else if (command.contains("manage") || command.contains("faces")) {
//       targetScreen = const RegisteredFacesScreen();
//       featureName = "Manage faces";
//     }
//
//     if (targetScreen != null) {
//       _hasNavigated = true;
//       _isActive = false;
//
//       await _flutterTts.stop();
//       await _stopSttQuietly();
//       await Future.delayed(const Duration(milliseconds: 150));
//
//       await _flutterTts.speak("Opening $featureName module.");
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {}
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => targetScreen!),
//         );
//
//         _hasNavigated = false;
//         _isActive = true;
//         await Future.delayed(const Duration(milliseconds: 500));
//
//         if (widget.voiceNavigationEnabled) await _speakOptions();
//       }
//     } else {
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Register face, Recognize face, or Manage faces.");
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {}
//       await _playBeepSound();
//       _listeningRequested = false;
//       await _startListening();
//     }
//   }
//
//   Future<bool> _onWillPop() async {
//     _isActive = false;
//     await _stopSttQuietly();
//     await _flutterTts.stop();
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5F6FA),
//         appBar: AppBar(
//           backgroundColor: Colors.deepPurple,
//           title: const Text("Face Recognition"),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               bool shouldPop = await _onWillPop();
//               if (shouldPop && mounted) Navigator.pop(context);
//             },
//           ),
//           actions: [
//             Row(
//               children: [
//                 const Text("Voice", style: TextStyle(color: Colors.white)),
//                 Icon(
//                   widget.voiceNavigationEnabled ? Icons.mic : Icons.mic_off,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(width: 16),
//               ],
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.tag_faces, size: 30, color: Colors.deepPurple),
//                       SizedBox(width: 10),
//                       Text(
//                         "Face Recognition",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   Center(
//                     child: Container(
//                       width: screenWidth * 0.55,
//                       height: screenWidth * 0.55,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.deepPurple.withOpacity(0.3),
//                             spreadRadius: 5,
//                             blurRadius: 15,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                         image: const DecorationImage(
//                           image: AssetImage("assets/images/scan.png"),
//                           fit: BoxFit.fitWidth,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//
//                   // Buttons
//                   _actionCard(
//                     context,
//                     icon: Icons.person_add,
//                     title: "Register New Face",
//                     subtitle: "Capture and store a new user face",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => RegistrationScreen(),
//                         ),
//                       );
//                       _isActive = true;
//                       await Future.delayed(const Duration(milliseconds: 500));
//
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//
//                   _actionCard(
//                     context,
//                     icon: Icons.search,
//                     title: "Recognize Face",
//                     subtitle: "Identify registered faces in real-time",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RecognitionScreen()),
//                       );
//                       _isActive = true;
//
//                       await Future.delayed(const Duration(milliseconds: 700));
//
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//
//                   _actionCard(
//                     context,
//                     icon: Icons.list,
//                     title: "Registered Faces",
//                     subtitle: "View all stored face data",
//                     onTap: () async {
//                       _isActive = false;
//                       await _flutterTts.stop();
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RegisteredFacesScreen()),
//                       );
//                       _isActive = true;
//
//                       await Future.delayed(const Duration(milliseconds: 500));
//
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
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
//   Widget _actionCard(
//       BuildContext context, {
//         required IconData icon,
//         required String title,
//         required String subtitle,
//         required VoidCallback onTap,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 28,
//                 backgroundColor: Colors.deepPurple.shade50,
//                 child: Icon(icon, size: 30, color: Colors.deepPurple),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 4),
//                     Text(subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         )),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: Colors.deepPurple, size: 18),
//             ],
//           ),
//         ),
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
// import 'RecognitionScreen.dart';
// import 'RegisteredFacesScreen.dart';
// import 'RegistrationScreen.dart';
//
// // Global RouteObserver to track page transitions
// final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
//
// class HomeScreen extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const HomeScreen({super.key, required this.voiceNavigationEnabled});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with RouteAware {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool _isActive = true;
//   bool _ttsSpeaking = false;
//   bool _listeningRequested = false;
//   String text = '';
//
//   /// Tracks if any delayed call of speakOptions/startListening is active
//   bool _delayedCallScheduled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initVoiceSystem();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     routeObserver.subscribe(this, ModalRoute.of(context)!);
//   }
//
//   @override
//   void dispose() {
//     routeObserver.unsubscribe(this);
//     _cancelTimersAndTts();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didPopNext() {
//     // Called when returning from pushed page
//     _isActive = true;
//     _hasNavigated = false;
//     if (widget.voiceNavigationEnabled) {
//       _speakOptions();
//     } else {
//       _flutterTts.speak("You are in the Face Recognition module.");
//     }
//   }
//
//   /// Stop any STT activity quietly
//   Future<void> _stopSttQuietly() async {
//     try {
//       await _speechToText.cancel();
//       await _speechToText.stop();
//     } catch (_) {}
//     if (!mounted) return;
//     setState(() => isListening = false);
//     _listeningRequested = false;
//   }
//
//   /// Completely cancel TTS, STT, and any delayed calls
//   void _cancelTimersAndTts() {
//     _isActive = false;
//     _delayedCallScheduled = false;
//     _ttsSpeaking = false;
//     _stopSttQuietly();
//     _flutterTts.stop();
//   }
//
//   Future<void> _initVoiceSystem() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setPitch(1.0);
//     await _flutterTts.setSpeechRate(0.5);
//
//     var status = await Permission.microphone.request();
//
//     if (!widget.voiceNavigationEnabled) {
//       await _flutterTts.speak("You are in the Face Recognition module.");
//       return;
//     }
//
//     if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please enable microphone permission in settings to use voice navigation.");
//       return;
//     }
//
//     await _speakOptions();
//   }
//
//   Future<void> _speakOptions() async {
//     if (!_isActive || _ttsSpeaking || !mounted) return;
//
//     _ttsSpeaking = true;
//
//     String message = widget.voiceNavigationEnabled
//         ? "You are in the Face Recognition module. You can say: Register face, Detect face, or Manage faces. Which one would you like to open?"
//         : "You are in the Face Recognition module.";
//
//     try {
//       await _flutterTts.speak(message);
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {
//         await Future.delayed(const Duration(milliseconds: 800));
//       }
//     } finally {
//       _ttsSpeaking = false;
//     }
//
//     if (!widget.voiceNavigationEnabled || !_isActive || !mounted) return;
//
//     if (_delayedCallScheduled) return; // Prevent multiple calls
//     _delayedCallScheduled = true;
//
//     Future.delayed(const Duration(milliseconds: 250), () async {
//       if (!_isActive || !mounted) {
//         _delayedCallScheduled = false;
//         return;
//       }
//       await _playBeepSound();
//       if (!_isActive || !mounted) {
//         _delayedCallScheduled = false;
//         return;
//       }
//       await _startListening();
//       _delayedCallScheduled = false;
//     });
//   }
//
//   Future<void> _playBeepSound() async {
//     if (!_isActive) return;
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (_) {}
//   }
//
//   Future<void> _startListening() async {
//     if (!_isActive || _ttsSpeaking || _listeningRequested) return;
//
//     _listeningRequested = true;
//
//     final perm = await Permission.microphone.status;
//     if (!perm.isGranted) {
//       if (!(await Permission.microphone.request()).isGranted) {
//         await _flutterTts.speak("Microphone permission is required.");
//         _listeningRequested = false;
//         return;
//       }
//     }
//
//     try {
//       await _speechToText.cancel();
//       await Future.delayed(const Duration(milliseconds: 150));
//     } catch (_) {}
//
//     bool available = false;
//     try {
//       available = await _speechToText.initialize(
//         onStatus: (status) async {
//           if (!_isActive) return;
//           if (!mounted) return;
//
//           if (status == 'notListening' && !_hasNavigated) {
//             setState(() => isListening = false);
//             if (!_isActive) return;
//             await Future.delayed(const Duration(seconds: 1));
//             if (!_isActive) return;
//             await _playBeepSound();
//             _listeningRequested = false;
//             await _startListening();
//           } else if (status == 'listening') {
//             setState(() => isListening = true);
//           }
//         },
//         onError: (error) async {
//           if (!_isActive) return;
//           if (mounted) setState(() => isListening = false);
//           _listeningRequested = false;
//
//           await Future.delayed(const Duration(seconds: 1));
//           if (!_isActive) return;
//           await _playBeepSound();
//           await _startListening();
//         },
//       );
//     } catch (_) {}
//
//     if (!available) {
//       _listeningRequested = false;
//       await _flutterTts.speak("Speech recognition is not available.");
//       return;
//     }
//
//     await Future.delayed(const Duration(milliseconds: 200));
//     if (!_isActive || !mounted) return;
//
//     try {
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 4),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive) return;
//           if (!mounted) return;
//
//           setState(() => text = result.recognizedWords);
//
//           if (result.finalResult && text.isNotEmpty) {
//             _listeningRequested = false;
//             _handleVoiceCommand(text.toLowerCase());
//           }
//         },
//       );
//       if (mounted) setState(() => isListening = true);
//     } catch (_) {
//       _listeningRequested = false;
//       if (mounted) setState(() => isListening = false);
//     }
//   }
//
//   Future<void> _handleVoiceCommand(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? targetScreen;
//     String? featureName;
//
//     if (command.contains("register")) {
//       targetScreen = RegistrationScreen();
//       featureName = "Register face";
//     } else if (command.contains("recognize") ||
//         command.contains("detect") ||
//         command.contains("identify")) {
//       targetScreen = const RecognitionScreen();
//       featureName = "Recognize face";
//     } else if (command.contains("manage") || command.contains("faces")) {
//       targetScreen = const RegisteredFacesScreen();
//       featureName = "Manage faces";
//     }
//
//     if (targetScreen != null) {
//       _hasNavigated = true;
//       _isActive = false;
//       _delayedCallScheduled = false;
//
//       await _stopSttQuietly();
//
//       await _flutterTts.speak("Opening $featureName module.");
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {}
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => targetScreen!),
//         );
//
//         _hasNavigated = false;
//         _isActive = true;
//         await Future.delayed(const Duration(milliseconds: 500));
//
//         if (widget.voiceNavigationEnabled) await _speakOptions();
//       }
//     } else {
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Register face, Recognize face, or Manage faces.");
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {}
//       await _playBeepSound();
//       _listeningRequested = false;
//       await _startListening();
//     }
//   }
//
//   Future<bool> _onWillPop() async {
//     _cancelTimersAndTts();
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5F6FA),
//         appBar: AppBar(
//           backgroundColor: Colors.deepPurple,
//           title: const Text("Face Recognition"),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               bool shouldPop = await _onWillPop();
//               if (shouldPop && mounted) Navigator.pop(context);
//             },
//           ),
//           actions: [
//             Row(
//               children: [
//                 const Text("Voice", style: TextStyle(color: Colors.white)),
//                 Icon(
//                   widget.voiceNavigationEnabled ? Icons.mic : Icons.mic_off,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(width: 16),
//               ],
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.tag_faces, size: 30, color: Colors.deepPurple),
//                       SizedBox(width: 10),
//                       Text(
//                         "Face Recognition",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   Center(
//                     child: Container(
//                       width: screenWidth * 0.55,
//                       height: screenWidth * 0.55,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.deepPurple.withOpacity(0.3),
//                             spreadRadius: 5,
//                             blurRadius: 15,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                         image: const DecorationImage(
//                           image: AssetImage("assets/images/scan.png"),
//                           fit: BoxFit.fitWidth,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//
//                   // Buttons
//                   _actionCard(
//                     context,
//                     icon: Icons.person_add,
//                     title: "Register New Face",
//                     subtitle: "Capture and store a new user face",
//                     onTap: () async {
//                       _isActive = false;
//                       _delayedCallScheduled = false;
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => RegistrationScreen(),
//                         ),
//                       );
//                       _isActive = true;
//                       await Future.delayed(const Duration(milliseconds: 500));
//
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//
//                   _actionCard(
//                     context,
//                     icon: Icons.search,
//                     title: "Recognize Face",
//                     subtitle: "Identify registered faces in real-time",
//                     onTap: () async {
//                       _isActive = false;
//                       _delayedCallScheduled = false;
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RecognitionScreen()),
//                       );
//                       _isActive = true;
//
//                       await Future.delayed(const Duration(milliseconds: 700));
//
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//
//                   _actionCard(
//                     context,
//                     icon: Icons.list,
//                     title: "Registered Faces",
//                     subtitle: "View all stored face data",
//                     onTap: () async {
//                       _isActive = false;
//                       _delayedCallScheduled = false;
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RegisteredFacesScreen()),
//                       );
//                       _isActive = true;
//
//                       await Future.delayed(const Duration(milliseconds: 500));
//
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
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
//   Widget _actionCard(
//       BuildContext context, {
//         required IconData icon,
//         required String title,
//         required String subtitle,
//         required VoidCallback onTap,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 28,
//                 backgroundColor: Colors.deepPurple.shade50,
//                 child: Icon(icon, size: 30, color: Colors.deepPurple),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 4),
//                     Text(subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         )),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: Colors.deepPurple, size: 18),
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
// import 'RecognitionScreen.dart';
// import 'RegisteredFacesScreen.dart';
// import 'RegistrationScreen.dart';
//
// final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
//
// class HomeScreen extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const HomeScreen({super.key, required this.voiceNavigationEnabled});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with RouteAware {
//   late FlutterTts _flutterTts;
//   late stt.SpeechToText _speechToText;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   bool isListening = false;
//   bool _hasNavigated = false;
//   bool _isActive = true;
//   bool _ttsSpeaking = false;
//   bool _listeningRequested = false;
//   String text = '';
//   bool _delayedCallScheduled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initVoiceSystem();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     routeObserver.subscribe(this, ModalRoute.of(context)!);
//   }
//
//   @override
//   void dispose() {
//     routeObserver.unsubscribe(this);
//     _cancelTimersAndTts();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didPopNext() {
//     if (!_isActive) return;   // 🔥 Prevent old screen TTS from firing
//     _isActive = true;
//     _hasNavigated = false;
//
//     if (widget.voiceNavigationEnabled) {
//       _speakOptions();
//     } else {
//       _flutterTts.speak("You are in the Face Recognition module.");
//     }
//   }
//
//   Future<void> _stopSttQuietly() async {
//     try {
//       await _speechToText.cancel();
//       await _speechToText.stop();
//     } catch (_) {}
//     if (!mounted) return;
//     setState(() => isListening = false);
//     _listeningRequested = false;
//   }
//
//   void _cancelTimersAndTts() {
//     _isActive = false;
//     _delayedCallScheduled = false;
//     _ttsSpeaking = false;
//     _stopSttQuietly();
//     _flutterTts.stop();
//   }
//
//   Future<void> _initVoiceSystem() async {
//     _flutterTts = FlutterTts();
//     _speechToText = stt.SpeechToText();
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setPitch(1.0);
//     await _flutterTts.setSpeechRate(0.5);
//
//     var status = await Permission.microphone.request();
//
//     if (!widget.voiceNavigationEnabled) {
//       await _flutterTts.speak("You are in the Face Recognition module.");
//       return;
//     }
//
//     if (!status.isGranted) {
//       await _flutterTts.speak(
//           "Please enable microphone permission in settings to use voice navigation.");
//       return;
//     }
//
//     await _speakOptions();
//   }
//
//   Future<void> _speakOptions() async {
//     if (!_isActive || _ttsSpeaking || !mounted) return;
//
//     _ttsSpeaking = true;
//
//     String message = widget.voiceNavigationEnabled
//         ? "You are in the Face Recognition module. You can say: Register face, Detect face, or Manage faces. Which one would you like to open?"
//         : "You are in the Face Recognition module.";
//
//     try {
//       await _flutterTts.speak(message);
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {
//         await Future.delayed(const Duration(milliseconds: 800));
//       }
//     } finally {
//       _ttsSpeaking = false;
//     }
//
//     if (!widget.voiceNavigationEnabled || !_isActive || !mounted) return;
//     if (_delayedCallScheduled) return;
//
//     _delayedCallScheduled = true;
//
//     Future.delayed(const Duration(milliseconds: 250), () async {
//       if (!_isActive || !mounted) {
//         _delayedCallScheduled = false;
//         return;
//       }
//       await _playBeepSound();
//       if (!_isActive || !mounted) {
//         _delayedCallScheduled = false;
//         return;
//       }
//       await _startListening();
//       _delayedCallScheduled = false;
//     });
//   }
//
//   Future<void> _playBeepSound() async {
//     if (!_isActive) return;
//     try {
//       await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
//     } catch (_) {}
//   }
//
//   Future<void> _startListening() async {
//     if (!_isActive || _ttsSpeaking || _listeningRequested) return;
//
//     _listeningRequested = true;
//
//     final perm = await Permission.microphone.status;
//     if (!perm.isGranted) {
//       if (!(await Permission.microphone.request()).isGranted) {
//         await _flutterTts.speak("Microphone permission is required.");
//         _listeningRequested = false;
//         return;
//       }
//     }
//
//     try {
//       await _speechToText.cancel();
//       await Future.delayed(const Duration(milliseconds: 150));
//     } catch (_) {}
//
//     bool available = false;
//     try {
//       available = await _speechToText.initialize(
//         onStatus: (status) async {
//           if (!_isActive) return;
//           if (!mounted) return;
//
//           if (status == 'notListening' && !_hasNavigated) {
//             setState(() => isListening = false);
//             if (!_isActive) return;
//             await Future.delayed(const Duration(seconds: 1));
//             if (!_isActive) return;
//             await _playBeepSound();
//             _listeningRequested = false;
//             await _startListening();
//           } else if (status == 'listening') {
//             setState(() => isListening = true);
//           }
//         },
//         onError: (error) async {
//           if (!_isActive) return;
//           if (mounted) setState(() => isListening = false);
//           _listeningRequested = false;
//
//           await Future.delayed(const Duration(seconds: 1));
//           if (!_isActive) return;
//           await _playBeepSound();
//           await _startListening();
//         },
//       );
//     } catch (_) {}
//
//     if (!available) {
//       _listeningRequested = false;
//       await _flutterTts.speak("Speech recognition is not available.");
//       return;
//     }
//
//     await Future.delayed(const Duration(milliseconds: 200));
//     if (!_isActive || !mounted) return;
//
//     try {
//       await _speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 4),
//         listenFor: const Duration(minutes: 5),
//         onResult: (result) {
//           if (!_isActive) return;
//           if (!mounted) return;
//
//           setState(() => text = result.recognizedWords);
//
//           if (result.finalResult && text.isNotEmpty) {
//             _listeningRequested = false;
//             _handleVoiceCommand(text.toLowerCase());
//           }
//         },
//       );
//       if (mounted) setState(() => isListening = true);
//     } catch (_) {
//       _listeningRequested = false;
//       if (mounted) setState(() => isListening = false);
//     }
//   }
//
//   Future<void> _handleVoiceCommand(String command) async {
//     if (_hasNavigated) return;
//
//     Widget? targetScreen;
//     String? featureName;
//
//     if (command.contains("register")) {
//       targetScreen = RegistrationScreen();
//       featureName = "Register face";
//     } else if (command.contains("recognize") ||
//         command.contains("detect") ||
//         command.contains("identify")) {
//       targetScreen = const RecognitionScreen();
//       featureName = "Recognize face";
//     } else if (command.contains("manage") || command.contains("faces")) {
//       targetScreen = const RegisteredFacesScreen();
//       featureName = "Manage faces";
//     }
//
//     if (targetScreen != null) {
//       _hasNavigated = true;
//       _isActive = false;
//       _delayedCallScheduled = false;
//
//       await _stopSttQuietly();
//
//       await _flutterTts.speak("Opening $featureName module.");
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {}
//
//       if (mounted) {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => targetScreen!),
//         );
//
//         _hasNavigated = false;
//         _isActive = true;
//         await Future.delayed(const Duration(milliseconds: 500));
//
//         if (widget.voiceNavigationEnabled) await _speakOptions();
//       }
//     } else {
//       await _flutterTts.speak(
//           "Sorry, I didn't understand. Please say Register face, Recognize face, or Manage faces.");
//       try {
//         await _flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {}
//       await _playBeepSound();
//       _listeningRequested = false;
//       await _startListening();
//     }
//   }
//
//   Future<bool> _onWillPop() async {
//     _cancelTimersAndTts();     // 🔥 Hard stop everything
//     await _stopSttQuietly();   // 🔥 Extra safety
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5F6FA),
//         appBar: AppBar(
//           backgroundColor: Colors.deepPurple,
//           title: const Text("Face Recognition"),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               _cancelTimersAndTts();     // 🔥 FIX
//               await _stopSttQuietly();   // 🔥 FIX
//               Navigator.pop(context);
//             },
//           ),
//           actions: [
//             Row(
//               children: [
//                 const Text("Voice", style: TextStyle(color: Colors.white)),
//                 Icon(
//                   widget.voiceNavigationEnabled ? Icons.mic : Icons.mic_off,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(width: 16),
//               ],
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.tag_faces, size: 30, color: Colors.deepPurple),
//                       SizedBox(width: 10),
//                       Text(
//                         "Face Recognition",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   Center(
//                     child: Container(
//                       width: screenWidth * 0.55,
//                       height: screenWidth * 0.55,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.deepPurple.withOpacity(0.3),
//                             spreadRadius: 5,
//                             blurRadius: 15,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                         image: const DecorationImage(
//                           image: AssetImage("assets/images/scan.png"),
//                           fit: BoxFit.fitWidth,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//
//                   _actionCard(
//                     context,
//                     icon: Icons.person_add,
//                     title: "Register New Face",
//                     subtitle: "Capture and store a new user face",
//                     onTap: () async {
//                       _isActive = false;
//                       _delayedCallScheduled = false;
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => RegistrationScreen(),
//                         ),
//                       );
//                       _isActive = true;
//                       await Future.delayed(const Duration(milliseconds: 500));
//
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//
//                   _actionCard(
//                     context,
//                     icon: Icons.search,
//                     title: "Recognize Face",
//                     subtitle: "Identify registered faces in real-time",
//                     onTap: () async {
//                       _isActive = false;
//                       _delayedCallScheduled = false;
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RecognitionScreen()),
//                       );
//                       _isActive = true;
//
//                       await Future.delayed(const Duration(milliseconds: 700));
//
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//
//                   _actionCard(
//                     context,
//                     icon: Icons.list,
//                     title: "Registered Faces",
//                     subtitle: "View all stored face data",
//                     onTap: () async {
//                       _isActive = false;
//                       _delayedCallScheduled = false;
//                       await _stopSttQuietly();
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RegisteredFacesScreen()),
//                       );
//                       _isActive = true;
//
//                       await Future.delayed(const Duration(milliseconds: 500));
//
//                       if (widget.voiceNavigationEnabled) await _speakOptions();
//                     },
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
//   Widget _actionCard(
//       BuildContext context, {
//         required IconData icon,
//         required String title,
//         required String subtitle,
//         required VoidCallback onTap,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 28,
//                 backgroundColor: Colors.deepPurple.shade50,
//                 child: Icon(icon, size: 30, color: Colors.deepPurple),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 4),
//                     Text(subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         )),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: Colors.deepPurple, size: 18),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'RecognitionScreen.dart';
import 'RegisteredFacesScreen.dart';
import 'RegistrationScreen.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class HomeScreen extends StatefulWidget {
  final bool voiceNavigationEnabled;

  const HomeScreen({super.key, required this.voiceNavigationEnabled});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  late FlutterTts _flutterTts;
  late stt.SpeechToText _speechToText;
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isListening = false;
  bool _hasNavigated = false;
  bool _isActive = true;
  bool _ttsSpeaking = false;
  bool _listeningRequested = false;
  String text = '';
  bool _delayedCallScheduled = false;

  @override
  void initState() {
    super.initState();
    _initVoiceSystem();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _cancelTimersAndTts();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    if (!_isActive) return;   // 🔥 Prevent old screen TTS from firing
    _isActive = true;
    _hasNavigated = false;

    if (widget.voiceNavigationEnabled) {
      _speakOptions();
    } else {
      _flutterTts.speak("You are in the Face Recognition module.");
    }
  }

  /// Stop STT safely with delay for mic release
  Future<void> _stopSttQuietly() async {
    try {
      await _speechToText.cancel();
      await _speechToText.stop();
    } catch (_) {}
    if (!mounted) return;
    setState(() => isListening = false);
    _listeningRequested = false;
    // Small delay for mic release
    await Future.delayed(const Duration(milliseconds: 120));
  }

  /// Cancel all timers and TTS (hard stop)
  void _cancelTimersAndTts() {
    _isActive = false;
    _delayedCallScheduled = false;
    _ttsSpeaking = false;
    try {
      _speechToText.stop();
      _speechToText.cancel();
    } catch (_) {}
    try {
      _flutterTts.stop();
    } catch (_) {}
  }

  /// Speak on return from sub-modules (matches feature_screen pattern)
  Future<void> _speakOnReturn() async {
    if (!_isActive) return;

    await Future.delayed(const Duration(milliseconds: 300));

    if (widget.voiceNavigationEnabled) {
      // Voice mode ON - speak options with commands
      await _speakOptions();
    } else {
      // Voice mode OFF - just speak simple message
      await _stopSttQuietly();
      await _flutterTts.speak("You are in the Face Recognition module.");
    }
  }

  Future<void> _initVoiceSystem() async {
    _flutterTts = FlutterTts();
    _speechToText = stt.SpeechToText();

    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);

    var status = await Permission.microphone.request();

    if (!widget.voiceNavigationEnabled) {
      await _flutterTts.speak("You are in the Face Recognition module.");
      return;
    }

    if (!status.isGranted) {
      await _flutterTts.speak(
          "Please enable microphone permission in settings to use voice navigation.");
      return;
    }

    await _speakOptions();
  }

  Future<void> _speakOptions() async {
    if (!_isActive || _ttsSpeaking || !mounted) return;

    _ttsSpeaking = true;

    String message = widget.voiceNavigationEnabled
        ? "You are in the Face Recognition module. You can say: Register face, Detect face, or Manage faces. Which one would you like to open?"
        : "You are in the Face Recognition module.";

    try {
      await _flutterTts.speak(message);
      try {
        await _flutterTts.awaitSpeakCompletion(true);
      } catch (_) {
        await Future.delayed(const Duration(milliseconds: 800));
      }
    } finally {
      _ttsSpeaking = false;
    }

    if (!widget.voiceNavigationEnabled || !_isActive || !mounted) return;
    if (_delayedCallScheduled) return;

    _delayedCallScheduled = true;

    Future.delayed(const Duration(milliseconds: 250), () async {
      if (!_isActive || !mounted) {
        _delayedCallScheduled = false;
        return;
      }
      await _playBeepSound();
      if (!_isActive || !mounted) {
        _delayedCallScheduled = false;
        return;
      }
      await _startListening();
      _delayedCallScheduled = false;
    });
  }

  Future<void> _playBeepSound() async {
    if (!_isActive) return;
    try {
      await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
    } catch (_) {}
  }

  Future<void> _startListening() async {
    if (!_isActive || _ttsSpeaking || _listeningRequested) return;

    _listeningRequested = true;

    final perm = await Permission.microphone.status;
    if (!perm.isGranted) {
      if (!(await Permission.microphone.request()).isGranted) {
        await _flutterTts.speak("Microphone permission is required.");
        _listeningRequested = false;
        return;
      }
    }

    try {
      await _speechToText.cancel();
      await Future.delayed(const Duration(milliseconds: 150));
    } catch (_) {}

    bool available = false;
    try {
      available = await _speechToText.initialize(
        onStatus: (status) async {
          if (!_isActive) return;
          if (!mounted) return;

          if (status == 'notListening' && !_hasNavigated) {
            setState(() => isListening = false);
            if (!_isActive) return;
            await Future.delayed(const Duration(seconds: 1));
            if (!_isActive) return;
            await _playBeepSound();
            _listeningRequested = false;
            await _startListening();
          } else if (status == 'listening') {
            setState(() => isListening = true);
          }
        },
        onError: (error) async {
          if (!_isActive) return;
          if (mounted) setState(() => isListening = false);
          _listeningRequested = false;

          await Future.delayed(const Duration(seconds: 1));
          if (!_isActive) return;
          await _playBeepSound();
          await _startListening();
        },
      );
    } catch (_) {}

    if (!available) {
      _listeningRequested = false;
      await _flutterTts.speak("Speech recognition is not available.");
      return;
    }

    await Future.delayed(const Duration(milliseconds: 200));
    if (!_isActive || !mounted) return;

    try {
      await _speechToText.listen(
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
        pauseFor: const Duration(seconds: 4),
        listenFor: const Duration(minutes: 5),
        onResult: (result) {
          if (!_isActive) return;
          if (!mounted) return;

          setState(() => text = result.recognizedWords);

          if (result.finalResult && text.isNotEmpty) {
            _listeningRequested = false;
            _handleVoiceCommand(text.toLowerCase());
          }
        },
      );
      if (mounted) setState(() => isListening = true);
    } catch (_) {
      _listeningRequested = false;
      if (mounted) setState(() => isListening = false);
    }
  }

  Future<void> _handleVoiceCommand(String command) async {
    if (_hasNavigated) return;

    Widget? targetScreen;
    String? featureName;

    if (command.contains("register")) {
      targetScreen = RegistrationScreen();
      featureName = "Register face";
    } else if (command.contains("recognize") ||
        command.contains("detect") ||
        command.contains("identify")) {
      targetScreen = const RecognitionScreen();
      featureName = "Recognize face";
    } else if (command.contains("manage") || command.contains("faces")) {
      targetScreen = const RegisteredFacesScreen();
      featureName = "Manage faces";
    }

    if (targetScreen != null) {
      _hasNavigated = true;
      _isActive = false;
      _delayedCallScheduled = false;

      await _stopSttQuietly();

      _ttsSpeaking = true;
      await _flutterTts.speak("Opening $featureName module.");
      try {
        await _flutterTts.awaitSpeakCompletion(true);
      } catch (_) {}
      _ttsSpeaking = false;

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetScreen!),
        );

        // RETURNING BACK
        _hasNavigated = false;
        _isActive = true;
        await _speakOnReturn();
      }
    } else {
      _ttsSpeaking = true;
      await _flutterTts.speak(
          "Sorry, I didn't understand. Please say Register face, Recognize face, or Manage faces.");
      try {
        await _flutterTts.awaitSpeakCompletion(true);
      } catch (_) {}
      _ttsSpeaking = false;

      await _playBeepSound();
      _listeningRequested = false;
      await _startListening();
    }
  }

  Future<bool> _onWillPop() async {
    _cancelTimersAndTts();
    await _stopSttQuietly();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("Face Recognition"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              _cancelTimersAndTts();
              await _stopSttQuietly();
              Navigator.pop(context);
            },
          ),
          actions: [
            Row(
              children: [
                const Text("Voice", style: TextStyle(color: Colors.white)),
                Icon(
                  widget.voiceNavigationEnabled ? Icons.mic : Icons.mic_off,
                  color: Colors.white,
                ),
                const SizedBox(width: 16),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.tag_faces, size: 30, color: Colors.deepPurple),
                      SizedBox(width: 10),
                      Text(
                        "Face Recognition",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      width: screenWidth * 0.55,
                      height: screenWidth * 0.55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage("assets/images/scan.png"),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  _actionCard(
                    context,
                    icon: Icons.person_add,
                    title: "Register New Face",
                    subtitle: "Capture and store a new user face",
                    onTap: () async {
                      _isActive = false;
                      _delayedCallScheduled = false;
                      await _stopSttQuietly();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegistrationScreen(),
                        ),
                      );

                      // RETURNING BACK
                      _isActive = true;
                      await _speakOnReturn();
                    },
                  ),
                  const SizedBox(height: 20),

                  _actionCard(
                    context,
                    icon: Icons.search,
                    title: "Recognize Face",
                    subtitle: "Identify registered faces in real-time",
                    onTap: () async {
                      _isActive = false;
                      _delayedCallScheduled = false;
                      await _stopSttQuietly();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RecognitionScreen()),
                      );

                      // RETURNING BACK
                      _isActive = true;
                      await _speakOnReturn();
                    },
                  ),
                  const SizedBox(height: 20),

                  _actionCard(
                    context,
                    icon: Icons.list,
                    title: "Registered Faces",
                    subtitle: "View all stored face data",
                    onTap: () async {
                      _isActive = false;
                      _delayedCallScheduled = false;
                      await _stopSttQuietly();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisteredFacesScreen()),
                      );

                      // RETURNING BACK
                      _isActive = true;
                      await _speakOnReturn();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.deepPurple.shade50,
                child: Icon(icon, size: 30, color: Colors.deepPurple),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        )),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.deepPurple, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
