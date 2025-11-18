//
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:objectde/pages/upload.dart';
// import 'package:objectde/helpers/scan.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:objectde/person_detection.dart';
// void main() => runApp(const OCRPage());
//
// class OCRPage extends StatefulWidget {
//   const OCRPage({Key? key}) : super(key: key);
//
//   @override
//   State<OCRPage> createState() => _OCRPageState();
// }
//
// class _OCRPageState extends State<OCRPage> {
//   final FlutterTts flutterTts = FlutterTts();
//
//   // reusable button factory
//   Widget _buildWhiteButton(String text, VoidCallback onPressed) =>
//       _AnimatedWhiteButton(label: text, onPressed: onPressed);
//
//
//
//   @override
//
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OCR App',
//       debugShowCheckedModeBanner: false,
//       home: GestureDetector(
//         // ✅ Double tap anywhere on screen
//         onDoubleTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) =>  MyApp()),
//           );
//         },
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.white,
//                 Colors.white,
//                 Color(0xFFFFF1F7),
//                 Color(0xFFE1E1E1)
//               ],
//             ),
//           ),
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             body: Stack(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(30),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 20),
//                           const Padding(
//                             padding: EdgeInsets.all(30),
//                             child: AnimatedCheck(),
//                           ),
//                           const SizedBox(height: 30),
//                           // 🔹 Scan from Camera
//                           _buildWhiteButton('Scan Using Camera', () async {
//                             final scannedText = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => const ScanPage()),
//                             );
//
//                             if (scannedText != null &&
//                                 scannedText.toString().isNotEmpty) {
//                               print("Scanned Text: $scannedText");
//                             } else {
//                               print("No text scanned.");
//                             }
//                           }),
//                           const SizedBox(height: 20),
//                           // 🔹 Upload Image
//                           Hero(
//                             tag: const Key('upload'),
//                             child: _buildWhiteButton('Upload Image', () async {
//                               final uploadedText = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => const UploadPage()),
//                               );
//                             }),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                     top: kToolbarHeight, left: 12, child: AnimatedHeader()),
//               ],
//             ),
//             bottomNavigationBar: Container(
//                 width: double.infinity,
//                 height: 10,
//                 color: Colors.grey.shade800),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // -----------------------------------------------------
// // Header animation
// // -----------------------------------------------------
// class AnimatedHeader extends StatefulWidget {
//   const AnimatedHeader({Key? key}) : super(key: key);
//   @override
//   State<AnimatedHeader> createState() => _AnimatedHeaderState();
// }
//
// class _AnimatedHeaderState extends State<AnimatedHeader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
//     _fade = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeIn));
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 320,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SlideTransition(
//             position: _slide,
//             child: FadeTransition(
//               opacity: _fade,
//               child: Image.asset('assets/images/stick3.png',
//                   height: 540, width: 120, fit: BoxFit.contain),
//             ),
//           ),
//           Transform.translate(
//             offset: const Offset(-78, 0),
//             child: SlideTransition(
//               position: _slide,
//               child: FadeTransition(
//                 opacity: _fade,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("LET'S SEE ",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18, fontWeight: FontWeight.w400)),
//                     Text("THE WORLD",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF5A4FCF))),
//                     Text("Together",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18, fontWeight: FontWeight.w500)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // -----------------------------------------------------
// // Animated check image
// // -----------------------------------------------------
// class AnimatedCheck extends StatefulWidget {
//   const AnimatedCheck({Key? key}) : super(key: key);
//   @override
//   State<AnimatedCheck> createState() => _AnimatedCheckState();
// }
//
// class _AnimatedCheckState extends State<AnimatedCheck>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
//     _fade = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeIn));
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 450,
//       width: 450,
//       child: SlideTransition(
//         position: _slide,
//         child: FadeTransition(
//           opacity: _fade,
//           child: Image.asset('assets/images/check.png', fit: BoxFit.contain),
//         ),
//       ),
//     );
//   }
// }
//
// // -----------------------------------------------------
// // Animated white button
// // -----------------------------------------------------
// class _AnimatedWhiteButton extends StatefulWidget {
//   const _AnimatedWhiteButton({required this.label, required this.onPressed});
//   final String label;
//   final VoidCallback onPressed;
//
//   @override
//   State<_AnimatedWhiteButton> createState() => _AnimatedWhiteButtonState();
// }
//
// class _AnimatedWhiteButtonState extends State<_AnimatedWhiteButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<double> _fade;
//   late final Animation<double> _yOffset;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 600))
//       ..forward();
//     _fade = CurvedAnimation(parent: _c, curve: Curves.easeIn);
//     _yOffset = Tween<double>(begin: 12, end: 0)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: widget.onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size.fromHeight(50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: AnimatedBuilder(
//         animation: _c,
//         builder: (_, child) => Opacity(
//           opacity: _fade.value,
//           child: Transform.translate(
//             offset: Offset(0, _yOffset.value),
//             child: child,
//           ),
//         ),
//         child: Text(
//           widget.label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }





// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:objectde/pages/upload.dart';
// import 'package:objectde/helpers/scan.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:objectde/person_detection.dart';
//
// class OCRPage extends StatefulWidget {
//   final bool voiceNavigationEnabled; // ✅ Receive from main page
//
//   const OCRPage({Key? key, this.voiceNavigationEnabled = false})
//       : super(key: key);
//
//   @override
//   State<OCRPage> createState() => _OCRPageState();
// }
//
// class _OCRPageState extends State<OCRPage> with WidgetsBindingObserver {
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText speechToText = stt.SpeechToText();
//
//   bool isListening = false;
//   bool hasNavigated = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     // ✅ If voice navigation is ON, start voice setup
//     if (widget.voiceNavigationEnabled) {
//       Future.delayed(const Duration(seconds: 1), () async {
//         await _speakOptions();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     speechToText.stop();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   // ✅ Speak available options
//   Future<void> _speakOptions() async {
//     const text =
//         "You are on the OCR Page. Say: Scan using camera, or Upload image.";
//
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//     await flutterTts.awaitSpeakCompletion(true);
//
//     // Start listening after speaking
//     await _startListening();
//   }
//
//   Future<void> _startListening() async {
//     bool available = await speechToText.initialize(
//       onError: (err) => print("❌ STT Error: $err"),
//       onStatus: (status) => print("🧠 STT Status: $status"),
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       await speechToText.listen(
//         listenMode: stt.ListenMode.confirmation,
//         onResult: (result) async {
//           String command = result.recognizedWords.toLowerCase();
//           print("🎙 You said: $command");
//           if (result.finalResult && command.isNotEmpty) {
//             await _handleVoiceCommand(command);
//           }
//         },
//       );
//     }
//   }
//
//   Future<void> _handleVoiceCommand(String command) async {
//     if (hasNavigated) return;
//     hasNavigated = true;
//
//     speechToText.stop();
//     flutterTts.stop();
//
//     if (command.contains("camera")) {
//       await flutterTts.speak("Opening camera scanner...");
//       await flutterTts.awaitSpeakCompletion(true);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const ScanPage()),
//       );
//     } else if (command.contains("upload")) {
//       await flutterTts.speak("Opening image upload...");
//       await flutterTts.awaitSpeakCompletion(true);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const UploadPage()),
//       );
//     } else {
//       await flutterTts.speak(
//           "Sorry, I didn’t catch that. Please say camera or upload.");
//       await flutterTts.awaitSpeakCompletion(true);
//       hasNavigated = false;
//       await _startListening(); // Retry
//     }
//   }
//
//   // ✅ Reusable button factory
//   Widget _buildWhiteButton(String text, VoidCallback onPressed) =>
//       _AnimatedWhiteButton(label: text, onPressed: onPressed);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OCR App',
//       debugShowCheckedModeBanner: false,
//       home: GestureDetector(
//         onDoubleTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) =>  MyApp()),
//           );
//         },
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.white,
//                 Colors.white,
//                 Color(0xFFFFF1F7),
//                 Color(0xFFE1E1E1)
//               ],
//             ),
//           ),
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             body: Stack(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(30),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 20),
//                           const Padding(
//                             padding: EdgeInsets.all(30),
//                             child: AnimatedCheck(),
//                           ),
//                           const SizedBox(height: 30),
//                           // 🔹 Scan from Camera
//                           _buildWhiteButton('Scan Using Camera', () async {
//                             final scannedText = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => const ScanPage()),
//                             );
//                             if (scannedText != null &&
//                                 scannedText.toString().isNotEmpty) {
//                               print("Scanned Text: $scannedText");
//                             }
//                           }),
//                           const SizedBox(height: 20),
//                           // 🔹 Upload Image
//                           Hero(
//                             tag: const Key('upload'),
//                             child: _buildWhiteButton('Upload Image', () async {
//                               final uploadedText = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => const UploadPage()),
//                               );
//                             }),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                     top: kToolbarHeight, left: 12, child: AnimatedHeader()),
//               ],
//             ),
//             bottomNavigationBar: Container(
//                 width: double.infinity,
//                 height: 10,
//                 color: Colors.grey.shade800),
//           ),
//         ),
//       ),
//     );
//   }
// }





//
//
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:objectde/pages/upload.dart';
// import 'package:objectde/helpers/scan.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:objectde/person_detection.dart';
//
// class OCRPage extends StatefulWidget {
//   final bool voiceNavigationEnabled; // ✅ Receive from main page
//
//   const OCRPage({Key? key, this.voiceNavigationEnabled = false})
//       : super(key: key);
//
//   @override
//   State<OCRPage> createState() => _OCRPageState();
// }
//
// class _OCRPageState extends State<OCRPage> with WidgetsBindingObserver {
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText speechToText = stt.SpeechToText();
//
//   bool isListening = false;
//   bool hasNavigated = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     // ✅ If voice navigation is ON, start speaking options automatically
//     if (widget.voiceNavigationEnabled) {
//       Future.delayed(const Duration(seconds: 1), () async {
//         await _speakOptions();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     speechToText.stop();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   // -------------------------------
//   // Speak the available options
//   // -------------------------------
//   Future<void> _speakOptions() async {
//     if (!widget.voiceNavigationEnabled) return; // 🔹 check toggle
//
//     const text =
//         "You are on the OCR Page. Say: Scan using camera, or Upload image.";
//
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//     await flutterTts.awaitSpeakCompletion(true);
//
//     // Start listening after speaking options
//     await _startListening();
//   }
//
//   // -------------------------------
//   // Start voice recognition
//   // -------------------------------
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled) return;
//
//     bool available = await speechToText.initialize(
//       onError: (err) => print("❌ STT Error: $err"),
//       onStatus: (status) => print("🧠 STT Status: $status"),
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//
//       await speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 2),
//         onResult: (result) async {
//           if (!widget.voiceNavigationEnabled) return;
//
//           String command = result.recognizedWords.toLowerCase();
//           print("🎙 You said: $command");
//
//           if (result.finalResult && command.isNotEmpty) {
//             await _handleVoiceCommand(command);
//           }
//         },
//       );
//     }
//   }
//
//   // -------------------------------
//   // Handle voice commands
//   // -------------------------------
//   Future<void> _handleVoiceCommand(String command) async {
//     if (hasNavigated) return;
//     hasNavigated = true;
//
//     await speechToText.stop();
//     await flutterTts.stop();
//
//     if (command.contains("camera")) {
//       await flutterTts.speak("Opening camera scanner...");
//       await flutterTts.awaitSpeakCompletion(true);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const ScanPage()),
//       ).then((_) {
//         hasNavigated = false;
//         if (widget.voiceNavigationEnabled) _speakOptions();
//       });
//     } else if (command.contains("upload")) {
//       await flutterTts.speak("Opening image upload...");
//       await flutterTts.awaitSpeakCompletion(true);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const UploadPage()),
//       ).then((_) {
//         hasNavigated = false;
//         if (widget.voiceNavigationEnabled) _speakOptions();
//       });
//     } else {
//       await flutterTts.speak(
//           "Sorry, I didn’t catch that. Please say camera or upload.");
//       await flutterTts.awaitSpeakCompletion(true);
//       hasNavigated = false;
//       await _startListening(); // Retry listening
//     }
//   }
//
//   // -------------------------------
//   // Reusable button factory
//   // -------------------------------
//   Widget _buildWhiteButton(String text, VoidCallback onPressed) =>
//       _AnimatedWhiteButton(label: text, onPressed: onPressed);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OCR App',
//       debugShowCheckedModeBanner: false,
//       home: GestureDetector(
//         onDoubleTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => MyApp()),
//           );
//         },
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.white,
//                 Colors.white,
//                 Color(0xFFFFF1F7),
//                 Color(0xFFE1E1E1)
//               ],
//             ),
//           ),
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             body: Stack(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(30),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 20),
//                           const Padding(
//                             padding: EdgeInsets.all(30),
//                             child: AnimatedCheck(),
//                           ),
//                           const SizedBox(height: 30),
//                           // 🔹 Scan from Camera
//                           _buildWhiteButton('Scan Using Camera', () async {
//                             final scannedText = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => const ScanPage()),
//                             );
//                             if (scannedText != null &&
//                                 scannedText.toString().isNotEmpty) {
//                               print("Scanned Text: $scannedText");
//                             }
//                             // ✅ Restart TTS options if voice navigation is ON
//                             if (widget.voiceNavigationEnabled) _speakOptions();
//                           }),
//                           const SizedBox(height: 20),
//                           // 🔹 Upload Image
//                           Hero(
//                             tag: const Key('upload'),
//                             child: _buildWhiteButton('Upload Image', () async {
//                               final uploadedText = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => const UploadPage()),
//                               );
//                               if (widget.voiceNavigationEnabled) _speakOptions();
//                             }),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                     top: kToolbarHeight, left: 12, child: AnimatedHeader()),
//               ],
//             ),
//             bottomNavigationBar: Container(
//                 width: double.infinity,
//                 height: 10,
//                 color: Colors.grey.shade800),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// // -----------------------------------------------------
// // Header animation
// // -----------------------------------------------------
// class AnimatedHeader extends StatefulWidget {
//   const AnimatedHeader({Key? key}) : super(key: key);
//   @override
//   State<AnimatedHeader> createState() => _AnimatedHeaderState();
// }
//
// class _AnimatedHeaderState extends State<AnimatedHeader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
//     _fade = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeIn));
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 320,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SlideTransition(
//             position: _slide,
//             child: FadeTransition(
//               opacity: _fade,
//               child: Image.asset('assets/images/stick3.png',
//                   height: 540, width: 120, fit: BoxFit.contain),
//             ),
//           ),
//           Transform.translate(
//             offset: const Offset(-78, 0),
//             child: SlideTransition(
//               position: _slide,
//               child: FadeTransition(
//                 opacity: _fade,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("LET'S SEE ",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18, fontWeight: FontWeight.w400)),
//                     Text("THE WORLD",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF5A4FCF))),
//                     Text("Together",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18, fontWeight: FontWeight.w500)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // -----------------------------------------------------
// // Animated check image
// // -----------------------------------------------------
// class AnimatedCheck extends StatefulWidget {
//   const AnimatedCheck({Key? key}) : super(key: key);
//   @override
//   State<AnimatedCheck> createState() => _AnimatedCheckState();
// }
//
// class _AnimatedCheckState extends State<AnimatedCheck>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
//     _fade = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeIn));
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 450,
//       width: 450,
//       child: SlideTransition(
//         position: _slide,
//         child: FadeTransition(
//           opacity: _fade,
//           child: Image.asset('assets/images/check.png', fit: BoxFit.contain),
//         ),
//       ),
//     );
//   }
// }
//
// // -----------------------------------------------------
// // Animated white button
// // -----------------------------------------------------
// class _AnimatedWhiteButton extends StatefulWidget {
//   const _AnimatedWhiteButton({required this.label, required this.onPressed});
//   final String label;
//   final VoidCallback onPressed;
//
//   @override
//   State<_AnimatedWhiteButton> createState() => _AnimatedWhiteButtonState();
// }
//
// class _AnimatedWhiteButtonState extends State<_AnimatedWhiteButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<double> _fade;
//   late final Animation<double> _yOffset;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 600))
//       ..forward();
//     _fade = CurvedAnimation(parent: _c, curve: Curves.easeIn);
//     _yOffset = Tween<double>(begin: 12, end: 0)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: widget.onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size.fromHeight(50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: AnimatedBuilder(
//         animation: _c,
//         builder: (_, child) => Opacity(
//           opacity: _fade.value,
//           child: Transform.translate(
//             offset: Offset(0, _yOffset.value),
//             child: child,
//           ),
//         ),
//         child: Text(
//           widget.label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }
//








// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:objectde/pages/upload.dart';
// import 'package:objectde/helpers/scan.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:objectde/person_detection.dart';
//
// class OCRPage extends StatefulWidget {
//   final bool voiceNavigationEnabled; // ✅ Receive from FeatureScreen
//
//   const OCRPage({Key? key, this.voiceNavigationEnabled = false})
//       : super(key: key);
//
//   @override
//   State<OCRPage> createState() => _OCRPageState();
// }
//
// class _OCRPageState extends State<OCRPage> with WidgetsBindingObserver {
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText speechToText = stt.SpeechToText();
//
//   bool isListening = false;
//   bool hasNavigated = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     // ✅ Start voice navigation automatically if enabled
//     if (widget.voiceNavigationEnabled) {
//       Future.delayed(const Duration(milliseconds: 500), () async {
//         await _speakOptions();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     speechToText.stop();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   // -------------------------------
//   // Speak the available options
//   // -------------------------------
//   Future<void> _speakOptions() async {
//     if (!widget.voiceNavigationEnabled) return;
//
//     const text =
//         "You are on the OCR Page. Say: Scan using camera, or Upload image.";
//
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//     await flutterTts.awaitSpeakCompletion(true);
//
//     // Start listening after speaking options
//     await _startListening();
//   }
//
//   // -------------------------------
//   // Start voice recognition
//   // -------------------------------
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled) return;
//
//     bool available = await speechToText.initialize(
//       onError: (err) => print("❌ STT Error: $err"),
//       onStatus: (status) => print("🧠 STT Status: $status"),
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//
//       await speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 2),
//         onResult: (result) async {
//           if (!widget.voiceNavigationEnabled) return;
//
//           String command = result.recognizedWords.toLowerCase();
//           print("🎙 You said: $command");
//
//           if (result.finalResult && command.isNotEmpty) {
//             await _handleVoiceCommand(command);
//           }
//         },
//       );
//     }
//   }
//
//   // -------------------------------
//   // Handle voice commands
//   // -------------------------------
//   Future<void> _handleVoiceCommand(String command) async {
//     if (hasNavigated) return;
//     hasNavigated = true;
//
//     await speechToText.stop();
//     await flutterTts.stop();
//
//     if (command.contains("camera")) {
//       await flutterTts.speak("Opening camera scanner...");
//       await flutterTts.awaitSpeakCompletion(true);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const ScanPage()),
//       ).then((_) {
//         hasNavigated = false;
//         if (widget.voiceNavigationEnabled) _speakOptions();
//       });
//     } else if (command.contains("upload")) {
//       await flutterTts.speak("Opening image upload...");
//       await flutterTts.awaitSpeakCompletion(true);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const UploadPage()),
//       ).then((_) {
//         hasNavigated = false;
//         if (widget.voiceNavigationEnabled) _speakOptions();
//       });
//     } else {
//       await flutterTts.speak(
//           "Sorry, I didn’t catch that. Please say camera or upload.");
//       await flutterTts.awaitSpeakCompletion(true);
//       hasNavigated = false;
//       await _startListening(); // Retry listening
//     }
//   }
//
//   // -------------------------------
//   // Reusable button factory
//   // -------------------------------
//   Widget _buildWhiteButton(String text, VoidCallback onPressed) =>
//       _AnimatedWhiteButton(label: text, onPressed: onPressed);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OCR App',
//       debugShowCheckedModeBanner: false,
//       home: GestureDetector(
//         onDoubleTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => MyApp()),
//           );
//         },
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.white,
//                 Colors.white,
//                 Color(0xFFFFF1F7),
//                 Color(0xFFE1E1E1)
//               ],
//             ),
//           ),
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             body: Stack(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(30),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 20),
//                           const Padding(
//                             padding: EdgeInsets.all(30),
//                             child: AnimatedCheck(),
//                           ),
//                           const SizedBox(height: 30),
//                           // 🔹 Scan from Camera
//                           _buildWhiteButton('Scan Using Camera', () async {
//                             final scannedText = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => const ScanPage()),
//                             );
//                             if (scannedText != null &&
//                                 scannedText.toString().isNotEmpty) {
//                               print("Scanned Text: $scannedText");
//                             }
//                             // ✅ Restart voice options after return
//                             if (widget.voiceNavigationEnabled) _speakOptions();
//                           }),
//                           const SizedBox(height: 20),
//                           // 🔹 Upload Image
//                           Hero(
//                             tag: const Key('upload'),
//                             child: _buildWhiteButton('Upload Image', () async {
//                               final uploadedText = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => const UploadPage()),
//                               );
//                               if (widget.voiceNavigationEnabled) _speakOptions();
//                             }),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                     top: kToolbarHeight, left: 12, child: AnimatedHeader()),
//               ],
//             ),
//             bottomNavigationBar: Container(
//                 width: double.infinity,
//                 height: 10,
//                 color: Colors.grey.shade800),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // -------------------------------
// // AnimatedHeader
// // -------------------------------
// class AnimatedHeader extends StatefulWidget {
//   const AnimatedHeader({Key? key}) : super(key: key);
//   @override
//   State<AnimatedHeader> createState() => _AnimatedHeaderState();
// }
//
// class _AnimatedHeaderState extends State<AnimatedHeader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
//     _fade = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeIn));
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 320,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SlideTransition(
//             position: _slide,
//             child: FadeTransition(
//               opacity: _fade,
//               child: Image.asset('assets/images/stick3.png',
//                   height: 540, width: 120, fit: BoxFit.contain),
//             ),
//           ),
//           Transform.translate(
//             offset: const Offset(-78, 0),
//             child: SlideTransition(
//               position: _slide,
//               child: FadeTransition(
//                 opacity: _fade,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("LET'S SEE ",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18, fontWeight: FontWeight.w400)),
//                     Text("THE WORLD",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF5A4FCF))),
//                     Text("Together",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18, fontWeight: FontWeight.w500)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // -------------------------------
// // AnimatedCheck
// // -------------------------------
// class AnimatedCheck extends StatefulWidget {
//   const AnimatedCheck({Key? key}) : super(key: key);
//   @override
//   State<AnimatedCheck> createState() => _AnimatedCheckState();
// }
//
// class _AnimatedCheckState extends State<AnimatedCheck>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
//     _fade = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeIn));
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 450,
//       width: 450,
//       child: SlideTransition(
//         position: _slide,
//         child: FadeTransition(
//           opacity: _fade,
//           child: Image.asset('assets/images/check.png', fit: BoxFit.contain),
//         ),
//       ),
//     );
//   }
// }
//
// // -------------------------------
// // Animated white button
// // -------------------------------
// class _AnimatedWhiteButton extends StatefulWidget {
//   const _AnimatedWhiteButton({required this.label, required this.onPressed});
//   final String label;
//   final VoidCallback onPressed;
//
//   @override
//   State<_AnimatedWhiteButton> createState() => _AnimatedWhiteButtonState();
// }
//
// class _AnimatedWhiteButtonState extends State<_AnimatedWhiteButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<double> _fade;
//   late final Animation<double> _yOffset;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 600))
//       ..forward();
//     _fade = CurvedAnimation(parent: _c, curve: Curves.easeIn);
//     _yOffset = Tween<double>(begin: 12, end: 0)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: widget.onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size.fromHeight(50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: AnimatedBuilder(
//         animation: _c,
//         builder: (_, child) => Opacity(
//           opacity: _fade.value,
//           child: Transform.translate(
//             offset: Offset(0, _yOffset.value),
//             child: child,
//           ),
//         ),
//         child: Text(
//           widget.label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }













// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:objectde/pages/upload.dart';
// import 'package:objectde/helpers/scan.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:objectde/person_detection.dart';
//
// class OCRPage extends StatefulWidget {
//   final bool voiceNavigationEnabled; // ✅ Receive from FeatureScreen
//
//   const OCRPage({Key? key, this.voiceNavigationEnabled = false})
//       : super(key: key);
//
//   @override
//   State<OCRPage> createState() => _OCRPageState();
// }
//
// class _OCRPageState extends State<OCRPage> with WidgetsBindingObserver {
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText speechToText = stt.SpeechToText();
//
//   bool isListening = false;
//   bool hasNavigated = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     // ✅ Start voice navigation automatically if enabled
//     if (widget.voiceNavigationEnabled) {
//       Future.delayed(const Duration(milliseconds: 500), () async {
//         await _speakOptions();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     speechToText.stop();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   // -------------------------------
//   // Speak the available options
//   // -------------------------------
//   Future<void> _speakOptions() async {
//     if (!widget.voiceNavigationEnabled) return;
//
//     // ✅ Stop any background TTS (FeatureScreen might still be speaking)
//     await flutterTts.stop();
//
//     const text =
//         "You are on the OCR Page. Say: Scan using camera, or Upload image.";
//
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//     await flutterTts.awaitSpeakCompletion(true);
//
//     // Start listening after speaking options
//     await _startListening();
//   }
//
//   // -------------------------------
//   // Start voice recognition
//   // -------------------------------
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled) return;
//
//     bool available = await speechToText.initialize(
//       onError: (err) => print("❌ STT Error: $err"),
//       onStatus: (status) => print("🧠 STT Status: $status"),
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//
//       await speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 2),
//         onResult: (result) async {
//           if (!widget.voiceNavigationEnabled) return;
//
//           String command = result.recognizedWords.toLowerCase();
//           print("🎙 You said: $command");
//
//           if (result.finalResult && command.isNotEmpty) {
//             await _handleVoiceCommand(command);
//           }
//         },
//       );
//     }
//   }
//
//   // -------------------------------
//   // Handle voice commands
//   // -------------------------------
//   Future<void> _handleVoiceCommand(String command) async {
//     if (hasNavigated) return;
//     hasNavigated = true;
//
//     await speechToText.stop();
//     await flutterTts.stop();
//
//     if (command.contains("camera")) {
//       await flutterTts.speak("Opening camera scanner...");
//       await flutterTts.awaitSpeakCompletion(true);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const ScanPage()),
//       ).then((_) {
//         hasNavigated = false;
//         if (widget.voiceNavigationEnabled) _speakOptions();
//       });
//     } else if (command.contains("upload")) {
//       await flutterTts.speak("Opening image upload...");
//       await flutterTts.awaitSpeakCompletion(true);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const UploadPage()),
//       ).then((_) {
//         hasNavigated = false;
//         if (widget.voiceNavigationEnabled) _speakOptions();
//       });
//     } else {
//       // ✅ Stop any previous TTS before retry
//       await flutterTts.stop();
//       await flutterTts.speak(
//           "Sorry, I didn’t catch that. Please say scan using camera, or upload image.");
//       await flutterTts.awaitSpeakCompletion(true);
//       hasNavigated = false;
//       await _startListening(); // Retry listening
//     }
//   }
//
//   // -------------------------------
//   // Reusable button factory
//   // -------------------------------
//   Widget _buildWhiteButton(String text, VoidCallback onPressed) =>
//       _AnimatedWhiteButton(label: text, onPressed: onPressed);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OCR App',
//       debugShowCheckedModeBanner: false,
//       home: GestureDetector(
//         onDoubleTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => MyApp()),
//           );
//         },
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.white,
//                 Colors.white,
//                 Color(0xFFFFF1F7),
//                 Color(0xFFE1E1E1)
//               ],
//             ),
//           ),
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             body: Stack(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(30),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 20),
//                           const Padding(
//                             padding: EdgeInsets.all(30),
//                             child: AnimatedCheck(),
//                           ),
//                           const SizedBox(height: 30),
//                           // 🔹 Scan from Camera
//                           _buildWhiteButton('Scan Using Camera', () async {
//                             final scannedText = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => const ScanPage()),
//                             );
//                             if (scannedText != null &&
//                                 scannedText.toString().isNotEmpty) {
//                               print("Scanned Text: $scannedText");
//                             }
//                             if (widget.voiceNavigationEnabled) _speakOptions();
//                           }),
//                           const SizedBox(height: 20),
//                           // 🔹 Upload Image
//                           Hero(
//                             tag: const Key('upload'),
//                             child: _buildWhiteButton('Upload Image', () async {
//                               final uploadedText = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => const UploadPage()),
//                               );
//                               if (widget.voiceNavigationEnabled) _speakOptions();
//                             }),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                     top: kToolbarHeight, left: 12, child: AnimatedHeader()),
//               ],
//             ),
//             bottomNavigationBar: Container(
//                 width: double.infinity,
//                 height: 10,
//                 color: Colors.grey.shade800),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // -------------------------------
// // AnimatedHeader
// // -------------------------------
// class AnimatedHeader extends StatefulWidget {
//   const AnimatedHeader({Key? key}) : super(key: key);
//   @override
//   State<AnimatedHeader> createState() => _AnimatedHeaderState();
// }
//
// class _AnimatedHeaderState extends State<AnimatedHeader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
//     _fade = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeIn));
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 320,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SlideTransition(
//             position: _slide,
//             child: FadeTransition(
//               opacity: _fade,
//               child: Image.asset('assets/images/stick3.png',
//                   height: 540, width: 120, fit: BoxFit.contain),
//             ),
//           ),
//           Transform.translate(
//             offset: const Offset(-78, 0),
//             child: SlideTransition(
//               position: _slide,
//               child: FadeTransition(
//                 opacity: _fade,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("LET'S SEE ",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18, fontWeight: FontWeight.w400)),
//                     Text("THE WORLD",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF5A4FCF))),
//                     Text("Together",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18, fontWeight: FontWeight.w500)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // -------------------------------
// // AnimatedCheck
// // -------------------------------
// class AnimatedCheck extends StatefulWidget {
//   const AnimatedCheck({Key? key}) : super(key: key);
//   @override
//   State<AnimatedCheck> createState() => _AnimatedCheckState();
// }
//
// class _AnimatedCheckState extends State<AnimatedCheck>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
//     _fade = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeIn));
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 450,
//       width: 450,
//       child: SlideTransition(
//         position: _slide,
//         child: FadeTransition(
//           opacity: _fade,
//           child: Image.asset('assets/images/check.png', fit: BoxFit.contain),
//         ),
//       ),
//     );
//   }
// }
//
// // -------------------------------
// // Animated white button
// // -------------------------------
// class _AnimatedWhiteButton extends StatefulWidget {
//   const _AnimatedWhiteButton({required this.label, required this.onPressed});
//   final String label;
//   final VoidCallback onPressed;
//
//   @override
//   State<_AnimatedWhiteButton> createState() => _AnimatedWhiteButtonState();
// }
//
// class _AnimatedWhiteButtonState extends State<_AnimatedWhiteButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<double> _fade;
//   late final Animation<double> _yOffset;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 600))
//       ..forward();
//     _fade = CurvedAnimation(parent: _c, curve: Curves.easeIn);
//     _yOffset = Tween<double>(begin: 12, end: 0)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: widget.onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size.fromHeight(50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: AnimatedBuilder(
//         animation: _c,
//         builder: (_, child) => Opacity(
//           opacity: _fade.value,
//           child: Transform.translate(
//             offset: Offset(0, _yOffset.value),
//             child: child,
//           ),
//         ),
//         child: Text(
//           widget.label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }












// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:objectde/pages/upload.dart';
// import 'package:objectde/helpers/scan.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:objectde/person_detection.dart';
//
// class OCRPage extends StatefulWidget {
//   final bool voiceNavigationEnabled; // ✅ Receive from FeatureScreen
//
//   const OCRPage({Key? key, this.voiceNavigationEnabled = false})
//       : super(key: key);
//
//   @override
//   State<OCRPage> createState() => _OCRPageState();
// }
//
// class _OCRPageState extends State<OCRPage> with WidgetsBindingObserver {
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText speechToText = stt.SpeechToText();
//
//   bool isListening = false;
//   bool hasNavigated = false;
//   bool _isActive = true; // Track if OCRPage is active for listening
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     // Start voice navigation automatically if enabled
//     if (widget.voiceNavigationEnabled) {
//       Future.delayed(const Duration(milliseconds: 500), () async {
//         await _speakOptions();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     WidgetsBinding.instance.removeObserver(this);
//     speechToText.stop();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   // -------------------------------
//   // Speak the available options
//   // -------------------------------
//   Future<void> _speakOptions() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     // Stop any background TTS
//     await flutterTts.stop();
//
//     const text =
//         "You are on the OCR Page. Say: Scan using camera, or Upload image.";
//
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//     await flutterTts.awaitSpeakCompletion(true);
//
//     // Start listening after speaking options
//     await _startListening();
//   }
//
//   // -------------------------------
//   // Start voice recognition
//   // -------------------------------
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await speechToText.initialize(
//       onError: (err) => print("❌ STT Error: $err"),
//       onStatus: (status) => print("🧠 STT Status: $status"),
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//
//       await speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 2),
//         onResult: (result) async {
//           if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//           String command = result.recognizedWords.toLowerCase();
//           print("🎙 You said: $command");
//
//           if (result.finalResult && command.isNotEmpty) {
//             await _handleVoiceCommand(command);
//           }
//         },
//       );
//     }
//   }
//
//   // -------------------------------
//   // Handle voice commands
//   // -------------------------------
//   Future<void> _handleVoiceCommand(String command) async {
//     if (hasNavigated) return;
//     hasNavigated = true;
//
//     await speechToText.stop();
//     await flutterTts.stop();
//
//     if (command.contains("camera")) {
//       await flutterTts.speak("Opening camera scanner...");
//       await flutterTts.awaitSpeakCompletion(true);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const ScanPage()),
//       ).then((_) {
//         hasNavigated = false;
//         if (widget.voiceNavigationEnabled && _isActive) _speakOptions();
//       });
//     } else if (command.contains("upload")) {
//       await flutterTts.speak("Opening image upload...");
//       await flutterTts.awaitSpeakCompletion(true);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const UploadPage()),
//       ).then((_) {
//         hasNavigated = false;
//         if (widget.voiceNavigationEnabled && _isActive) _speakOptions();
//       });
//     } else {
//       // Retry on unknown command
//       await flutterTts.stop();
//       await flutterTts.speak(
//           "Sorry, I didn’t catch that. Please say scan using camera, or upload image.");
//       await flutterTts.awaitSpeakCompletion(true);
//       hasNavigated = false;
//       await _startListening();
//     }
//   }
//
//   // -------------------------------
//   // Handle back press
//   // -------------------------------
//   Future<bool> _onWillPop() async {
//     _isActive = false;
//     await speechToText.stop();
//     await flutterTts.stop();
//     return true; // Allow pop
//   }
//
//   // -------------------------------
//   // Reusable button factory
//   // -------------------------------
//   Widget _buildWhiteButton(String text, VoidCallback onPressed) =>
//       _AnimatedWhiteButton(label: text, onPressed: onPressed);
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop, // ✅ Capture back button
//       child: MaterialApp(
//         title: 'OCR App',
//         debugShowCheckedModeBanner: false,
//         home: GestureDetector(
//           // onDoubleTap: () {
//           //   Navigator.push(
//           //     context,
//           //     MaterialPageRoute(builder: (_) => MyApp()),
//           //   );
//           // },
//           child: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.white,
//                   Colors.white,
//                   Color(0xFFFFF1F7),
//                   Color(0xFFE1E1E1)
//                 ],
//               ),
//             ),
//             child: Scaffold(
//               backgroundColor: Colors.transparent,
//               body: Stack(
//                 children: [
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(30),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const SizedBox(height: 20),
//                             const Padding(
//                               padding: EdgeInsets.all(30),
//                               child: AnimatedCheck(),
//                             ),
//                             const SizedBox(height: 30),
//                             // 🔹 Scan from Camera
//                             _buildWhiteButton('Scan Using Camera', () async {
//                               final scannedText = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => const ScanPage()),
//                               );
//                               if (widget.voiceNavigationEnabled && _isActive) {
//                                 await _speakOptions();
//                               }
//                             }),
//                             const SizedBox(height: 20),
//                             // 🔹 Upload Image
//                             Hero(
//                               tag: const Key('upload'),
//                               child: _buildWhiteButton('Upload Image',
//                                       () async {
//                                     final uploadedText = await Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (_) => const UploadPage()),
//                                     );
//                                     if (widget.voiceNavigationEnabled &&
//                                         _isActive) {
//                                       await _speakOptions();
//                                     }
//                                   }),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const Positioned(
//                       top: kToolbarHeight, left: 12, child: AnimatedHeader()),
//                 ],
//               ),
//               bottomNavigationBar: Container(
//                   width: double.infinity,
//                   height: 10,
//                   color: Colors.grey.shade800),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // -------------------------------
// // AnimatedHeader
// // -------------------------------
// class AnimatedHeader extends StatefulWidget {
//   const AnimatedHeader({Key? key}) : super(key: key);
//   @override
//   State<AnimatedHeader> createState() => _AnimatedHeaderState();
// }
//
// class _AnimatedHeaderState extends State<AnimatedHeader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
//     _fade = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeIn));
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 320,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SlideTransition(
//             position: _slide,
//             child: FadeTransition(
//               opacity: _fade,
//               child: Image.asset('assets/images/stick3.png',
//                   height: 540, width: 120, fit: BoxFit.contain),
//             ),
//           ),
//           Transform.translate(
//             offset: const Offset(-78, 0),
//             child: SlideTransition(
//               position: _slide,
//               child: FadeTransition(
//                 opacity: _fade,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("LET'S SEE ",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18, fontWeight: FontWeight.w400)),
//                     Text("THE WORLD",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF5A4FCF))),
//                     Text("Together",
//                         style: GoogleFonts.poppins(
//                             fontSize: 18, fontWeight: FontWeight.w500)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // -------------------------------
// // AnimatedCheck
// // -------------------------------
// class AnimatedCheck extends StatefulWidget {
//   const AnimatedCheck({Key? key}) : super(key: key);
//   @override
//   State<AnimatedCheck> createState() => _AnimatedCheckState();
// }
//
// class _AnimatedCheckState extends State<AnimatedCheck>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
//     _fade = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeIn));
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 450,
//       width: 450,
//       child: SlideTransition(
//         position: _slide,
//         child: FadeTransition(
//           opacity: _fade,
//           child: Image.asset('assets/images/check.png', fit: BoxFit.contain),
//         ),
//       ),
//     );
//   }
// }
//
// // -------------------------------
// // Animated white button
// // -------------------------------
// class _AnimatedWhiteButton extends StatefulWidget {
//   const _AnimatedWhiteButton({required this.label, required this.onPressed});
//   final String label;
//   final VoidCallback onPressed;
//
//   @override
//   State<_AnimatedWhiteButton> createState() => _AnimatedWhiteButtonState();
// }
//
// class _AnimatedWhiteButtonState extends State<_AnimatedWhiteButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<double> _fade;
//   late final Animation<double> _yOffset;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 600))
//       ..forward();
//     _fade = CurvedAnimation(parent: _c, curve: Curves.easeIn);
//     _yOffset = Tween<double>(begin: 12, end: 0)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: widget.onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size.fromHeight(50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: AnimatedBuilder(
//         animation: _c,
//         builder: (_, child) => Opacity(
//           opacity: _fade.value,
//           child: Transform.translate(
//             offset: Offset(0, _yOffset.value),
//             child: child,
//           ),
//         ),
//         child: Text(
//           widget.label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }




// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:objectde/pages/upload.dart';
// import 'package:objectde/helpers/scan.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class OCRPage extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const OCRPage({Key? key, this.voiceNavigationEnabled = false}) : super(key: key);
//
//   @override
//   State<OCRPage> createState() => _OCRPageState();
// }
//
// class _OCRPageState extends State<OCRPage> with WidgetsBindingObserver {
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText speechToText = stt.SpeechToText();
//
//   bool isListening = false;
//   bool hasNavigated = false;
//   bool _isActive = true;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     if (widget.voiceNavigationEnabled) {
//       Future.delayed(const Duration(milliseconds: 600), () async {
//         await _speakOptions();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     WidgetsBinding.instance.removeObserver(this);
//     speechToText.stop();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   /// ✅ Speak available OCR options
//   Future<void> _speakOptions() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     await flutterTts.stop();
//     const text = "You are on the OCR Page. Say: Scan using camera, or Upload image.";
//
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//     await flutterTts.awaitSpeakCompletion(true);
//
//     if (_isActive) await _startListening();
//   }
//
//   /// ✅ Start voice recognition
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await speechToText.initialize(
//       onError: (err) => print("❌ STT Error: $err"),
//       onStatus: (status) => print("🧠 STT Status: $status"),
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//
//       await speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 2),
//         onResult: (result) async {
//           if (!_isActive || !widget.voiceNavigationEnabled) return;
//           String command = result.recognizedWords.toLowerCase();
//
//           if (result.finalResult && command.isNotEmpty) {
//             await _handleVoiceCommand(command);
//           }
//         },
//       );
//     }
//   }
//
//   /// ✅ Handle user commands
//   Future<void> _handleVoiceCommand(String command) async {
//     if (hasNavigated) return;
//     hasNavigated = true;
//
//     await speechToText.stop();
//     await flutterTts.stop();
//
//     if (command.contains("camera")) {
//       await flutterTts.speak("Opening camera scanner...");
//       await flutterTts.awaitSpeakCompletion(true);
//       await Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const ScanPage()),
//       );
//
//       // 🔹 After returning
//       hasNavigated = false;
//       if (widget.voiceNavigationEnabled && _isActive) await _speakOptions();
//     } else if (command.contains("upload")) {
//       await flutterTts.speak("Opening image upload...");
//       await flutterTts.awaitSpeakCompletion(true);
//       await Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const UploadPage()),
//       );
//
//       // 🔹 After returning
//       hasNavigated = false;
//       if (widget.voiceNavigationEnabled && _isActive) await _speakOptions();
//     } else {
//       await flutterTts.speak(
//           "Sorry, I didn’t catch that. Please say scan using camera, or upload image.");
//       await flutterTts.awaitSpeakCompletion(true);
//       hasNavigated = false;
//       await _startListening();
//     }
//   }
//
//   /// ✅ Handle back press properly
//   Future<bool> _onWillPop() async {
//     _isActive = false;
//     await speechToText.stop();
//     await flutterTts.stop();
//     return true;
//   }
//
//   Widget _buildWhiteButton(String text, VoidCallback onPressed) =>
//       _AnimatedWhiteButton(label: text, onPressed: onPressed);
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.white,
//                 Colors.white,
//                 Color(0xFFFFF1F7),
//                 Color(0xFFE1E1E1),
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: Stack(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(30),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 20),
//                           const Padding(
//                             padding: EdgeInsets.all(30),
//                             child: AnimatedCheck(),
//                           ),
//                           const SizedBox(height: 30),
//                           _buildWhiteButton('Scan Using Camera', () async {
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => const ScanPage()),
//                             );
//                             // ✅ Speak again when returning
//                             if (widget.voiceNavigationEnabled && _isActive) {
//                               await _speakOptions();
//                             }
//                           }),
//                           const SizedBox(height: 20),
//                           _buildWhiteButton('Upload Image', () async {
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => const UploadPage()),
//                             );
//                             // ✅ Speak again when returning
//                             if (widget.voiceNavigationEnabled && _isActive) {
//                               await _speakOptions();
//                             }
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                     top: kToolbarHeight, left: 12, child: AnimatedHeader()),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: Container(
//           width: double.infinity,
//           height: 10,
//           color: Colors.grey.shade800,
//         ),
//       ),
//     );
//   }
// }
//
// /// =========================
// /// 🔹 AnimatedHeader Widget
// /// =========================
// class AnimatedHeader extends StatefulWidget {
//   const AnimatedHeader({Key? key}) : super(key: key);
//   @override
//   State<AnimatedHeader> createState() => _AnimatedHeaderState();
// }
//
// class _AnimatedHeaderState extends State<AnimatedHeader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide =
//         Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(_c);
//     _fade = Tween<double>(begin: 0, end: 1).animate(_c);
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 320,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SlideTransition(
//             position: _slide,
//             child: FadeTransition(
//               opacity: _fade,
//               child: Image.asset('assets/images/stick3.png',
//                   height: 540, width: 120, fit: BoxFit.contain),
//             ),
//           ),
//           Transform.translate(
//             offset: const Offset(-78, 0),
//             child: FadeTransition(
//               opacity: _fade,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("LET'S SEE ",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18, fontWeight: FontWeight.w400)),
//                   Text("THE WORLD",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xFF5A4FCF))),
//                   Text("Together",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18, fontWeight: FontWeight.w500)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// =========================
// /// 🔹 AnimatedCheck Widget
// /// =========================
// class AnimatedCheck extends StatefulWidget {
//   const AnimatedCheck({Key? key}) : super(key: key);
//   @override
//   State<AnimatedCheck> createState() => _AnimatedCheckState();
// }
//
// class _AnimatedCheckState extends State<AnimatedCheck>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide =
//         Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(_c);
//     _fade = Tween<double>(begin: 0, end: 1).animate(_c);
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 450,
//       width: 450,
//       child: SlideTransition(
//         position: _slide,
//         child: FadeTransition(
//           opacity: _fade,
//           child: Image.asset('assets/images/check.png', fit: BoxFit.contain),
//         ),
//       ),
//     );
//   }
// }
//
// /// =========================
// /// 🔹 Animated White Button
// /// =========================
// class _AnimatedWhiteButton extends StatefulWidget {
//   const _AnimatedWhiteButton({required this.label, required this.onPressed});
//   final String label;
//   final VoidCallback onPressed;
//
//   @override
//   State<_AnimatedWhiteButton> createState() => _AnimatedWhiteButtonState();
// }
//
// class _AnimatedWhiteButtonState extends State<_AnimatedWhiteButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<double> _fade;
//   late final Animation<double> _yOffset;
//
//   @override
//   void initState() {
//     super.initState();
//     _c =
//     AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
//       ..forward();
//     _fade = CurvedAnimation(parent: _c, curve: Curves.easeIn);
//     _yOffset = Tween<double>(begin: 12, end: 0)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: widget.onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size.fromHeight(50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: AnimatedBuilder(
//         animation: _c,
//         builder: (_, child) => Opacity(
//           opacity: _fade.value,
//           child: Transform.translate(offset: Offset(0, _yOffset.value), child: child),
//         ),
//         child: Text(
//           widget.label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }






// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:objectde/pages/upload.dart';
// import 'package:objectde/helpers/scan.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class OCRPage extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const OCRPage({Key? key, this.voiceNavigationEnabled = false}) : super(key: key);
//
//   @override
//   State<OCRPage> createState() => _OCRPageState();
// }
//
// class _OCRPageState extends State<OCRPage> with WidgetsBindingObserver {
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText speechToText = stt.SpeechToText();
//
//   bool isListening = false;
//   bool hasNavigated = false;
//   bool _isActive = true;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     if (widget.voiceNavigationEnabled) {
//       Future.delayed(const Duration(milliseconds: 600), () async {
//         await _speakOptions();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     WidgetsBinding.instance.removeObserver(this);
//     speechToText.stop();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   /// ✅ Speak available OCR options
//   Future<void> _speakOptions() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     await flutterTts.stop();
//     const text = "You are on the OCR Page. Say: Scan using camera, or Upload image.";
//
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//     await flutterTts.awaitSpeakCompletion(true);
//
//     if (_isActive) await _startListening();
//   }
//
//   /// ✅ Start voice recognition
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await speechToText.initialize(
//       onError: (err) => print("❌ STT Error: $err"),
//       onStatus: (status) => print("🧠 STT Status: $status"),
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//
//       await speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 2),
//         onResult: (result) async {
//           if (!_isActive || !widget.voiceNavigationEnabled) return;
//           String command = result.recognizedWords.toLowerCase();
//
//           if (result.finalResult && command.isNotEmpty) {
//             await _handleVoiceCommand(command);
//           }
//         },
//       );
//     }
//   }
//
//   /// ✅ Handle user commands
//   Future<void> _handleVoiceCommand(String command) async {
//     if (hasNavigated) return;
//     hasNavigated = true;
//
//     await speechToText.stop();
//     await flutterTts.stop();
//
//     if (command.contains("camera")) {
//       await flutterTts.speak("Opening camera scanner...");
//       await flutterTts.awaitSpeakCompletion(true);
//       await Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const ScanPage()),
//       );
//
//       // 🔹 After returning
//       hasNavigated = false;
//       if (widget.voiceNavigationEnabled && _isActive) await _speakOptions();
//     } else if (command.contains("upload")) {
//       await flutterTts.speak("Opening image upload...");
//       await flutterTts.awaitSpeakCompletion(true);
//       await Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const UploadPage()),
//       );
//
//       // 🔹 After returning
//       hasNavigated = false;
//       if (widget.voiceNavigationEnabled && _isActive) await _speakOptions();
//     } else {
//       await flutterTts.speak(
//           "Sorry, I didn’t catch that. Please say scan using camera, or upload image.");
//       await flutterTts.awaitSpeakCompletion(true);
//       hasNavigated = false;
//       await _startListening();
//     }
//   }
//
//   /// ✅ Handle back press properly
//   Future<bool> _onWillPop() async {
//     _isActive = false;
//     await speechToText.stop();
//     await flutterTts.stop();
//     return true;
//   }
//
//   Widget _buildWhiteButton(String text, VoidCallback onPressed) =>
//       _AnimatedWhiteButton(label: text, onPressed: onPressed);
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.white,
//                 Colors.white,
//                 Color(0xFFFFF1F7),
//                 Color(0xFFE1E1E1),
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: Stack(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(30),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 20),
//                           const Padding(
//                             padding: EdgeInsets.all(30),
//                             child: AnimatedCheck(),
//                           ),
//                           const SizedBox(height: 30),
//                           // ✅ Button 1: Scan Using Camera
//                           _buildWhiteButton('Scan Using Camera', () async {
//                             // 🔹 Stop TTS & STT before navigating
//                             await flutterTts.stop();
//                             await speechToText.stop();
//                             _isActive = false;
//
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => const ScanPage()),
//                             );
//
//                             // 🔹 Speak again after returning
//                             _isActive = true;
//                             if (widget.voiceNavigationEnabled) {
//                               await _speakOptions();
//                             }
//                           }),
//
//                           const SizedBox(height: 20),
//
//                           // ✅ Button 2: Upload Image
//                           _buildWhiteButton('Upload Image', () async {
//                             // 🔹 Stop TTS & STT before navigating
//                             await flutterTts.stop();
//                             await speechToText.stop();
//                             _isActive = false;
//
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => const UploadPage()),
//                             );
//
//                             // 🔹 Speak again after returning
//                             _isActive = true;
//                             if (widget.voiceNavigationEnabled) {
//                               await _speakOptions();
//                             }
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                     top: kToolbarHeight, left: 12, child: AnimatedHeader()),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: Container(
//           width: double.infinity,
//           height: 10,
//           color: Colors.grey.shade800,
//         ),
//       ),
//     );
//   }
// }
//
// /// =========================
// /// 🔹 AnimatedHeader Widget
// /// =========================
// class AnimatedHeader extends StatefulWidget {
//   const AnimatedHeader({Key? key}) : super(key: key);
//   @override
//   State<AnimatedHeader> createState() => _AnimatedHeaderState();
// }
//
// class _AnimatedHeaderState extends State<AnimatedHeader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide =
//         Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(_c);
//     _fade = Tween<double>(begin: 0, end: 1).animate(_c);
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 320,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SlideTransition(
//             position: _slide,
//             child: FadeTransition(
//               opacity: _fade,
//               child: Image.asset('assets/images/stick3.png',
//                   height: 540, width: 120, fit: BoxFit.contain),
//             ),
//           ),
//           Transform.translate(
//             offset: const Offset(-78, 0),
//             child: FadeTransition(
//               opacity: _fade,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("LET'S SEE ",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18, fontWeight: FontWeight.w400)),
//                   Text("THE WORLD",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xFF5A4FCF))),
//                   Text("Together",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18, fontWeight: FontWeight.w500)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// =========================
// /// 🔹 AnimatedCheck Widget
// /// =========================
// class AnimatedCheck extends StatefulWidget {
//   const AnimatedCheck({Key? key}) : super(key: key);
//   @override
//   State<AnimatedCheck> createState() => _AnimatedCheckState();
// }
//
// class _AnimatedCheckState extends State<AnimatedCheck>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide =
//         Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(_c);
//     _fade = Tween<double>(begin: 0, end: 1).animate(_c);
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 450,
//       width: 450,
//       child: SlideTransition(
//         position: _slide,
//         child: FadeTransition(
//           opacity: _fade,
//           child: Image.asset('assets/images/check.png', fit: BoxFit.contain),
//         ),
//       ),
//     );
//   }
// }
//
// /// =========================
// /// 🔹 Animated White Button
// /// =========================
// class _AnimatedWhiteButton extends StatefulWidget {
//   const _AnimatedWhiteButton({required this.label, required this.onPressed});
//   final String label;
//   final VoidCallback onPressed;
//
//   @override
//   State<_AnimatedWhiteButton> createState() => _AnimatedWhiteButtonState();
// }
//
// class _AnimatedWhiteButtonState extends State<_AnimatedWhiteButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<double> _fade;
//   late final Animation<double> _yOffset;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
//       ..forward();
//     _fade = CurvedAnimation(parent: _c, curve: Curves.easeIn);
//     _yOffset = Tween<double>(begin: 12, end: 0)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: widget.onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size.fromHeight(50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: AnimatedBuilder(
//         animation: _c,
//         builder: (_, child) => Opacity(
//           opacity: _fade.value,
//           child: Transform.translate(offset: Offset(0, _yOffset.value), child: child),
//         ),
//         child: Text(
//           widget.label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }
//






















// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:objectde/pages/upload.dart';
// import 'package:objectde/helpers/scan.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class OCRPage extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const OCRPage({Key? key, this.voiceNavigationEnabled = false}) : super(key: key);
//
//   @override
//   State<OCRPage> createState() => _OCRPageState();
// }
//
// class _OCRPageState extends State<OCRPage> with WidgetsBindingObserver {
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText speechToText = stt.SpeechToText();
//
//   bool isListening = false;
//   bool hasNavigated = false;
//   bool _isActive = true;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     if (widget.voiceNavigationEnabled) {
//       Future.delayed(const Duration(milliseconds: 600), () async {
//         await _speakOptions();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     WidgetsBinding.instance.removeObserver(this);
//     speechToText.stop();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   // / Speak available OCR options
//   Future<void> _speakOptions() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     await flutterTts.stop();
//     const text = "You are on the OCR Page. Say: Scan using camera, or Upload image.";
//
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//     await flutterTts.awaitSpeakCompletion(true);
//
//     if (_isActive) await _startListening();
//   }
//
//   /// Speak available OCR options
//
//
//
//
//
//   /// Start voice recognition
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await speechToText.initialize(
//       onError: (err) => print("❌ STT Error: $err"),
//       onStatus: (status) => print("🧠 STT Status: $status"),
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//
//       await speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 2),
//         onResult: (result) async {
//           if (!_isActive || !widget.voiceNavigationEnabled) return;
//           String command = result.recognizedWords.toLowerCase();
//
//           if (result.finalResult && command.isNotEmpty) {
//             await _handleVoiceCommand(command);
//           }
//         },
//       );
//     }
//   }
//
//   /// Handle user commands
//   Future<void> _handleVoiceCommand(String command) async {
//     if (hasNavigated) return;
//     hasNavigated = true;
//
//     await speechToText.stop();
//     await flutterTts.stop();
//
//     if (command.contains("camera")) {
//       await flutterTts.speak("Opening camera scanner...");
//       await flutterTts.awaitSpeakCompletion(true);
//       await Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const ScanPage()),
//       );
//
//       // After returning
//       hasNavigated = false;
//       if (widget.voiceNavigationEnabled && _isActive) await _speakOptions();
//     } else if (command.contains("upload")) {
//       await flutterTts.speak("Opening image upload...");
//       await flutterTts.awaitSpeakCompletion(true);
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => UploadPage(voiceNavigationEnabled: widget.voiceNavigationEnabled),
//         ),
//       );
//
//       // After returning
//       hasNavigated = false;
//       if (widget.voiceNavigationEnabled && _isActive) await _speakOptions();
//     } else {
//       await flutterTts.speak(
//           "Sorry, I didn’t catch that. Please say scan using camera, or upload image.");
//       await flutterTts.awaitSpeakCompletion(true);
//       hasNavigated = false;
//       await _startListening();
//     }
//   }
//
//   /// Handle back press
//   Future<bool> _onWillPop() async {
//     _isActive = false;
//     await speechToText.stop();
//     await flutterTts.stop();
//     return true;
//   }
//
//   Widget _buildWhiteButton(String text, VoidCallback onPressed) =>
//       _AnimatedWhiteButton(label: text, onPressed: onPressed);
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.white,
//                 Colors.white,
//                 Color(0xFFFFF1F7),
//                 Color(0xFFE1E1E1),
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: Stack(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(30),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 20),
//                           const Padding(
//                             padding: EdgeInsets.all(30),
//                             child: AnimatedCheck(),
//                           ),
//                           const SizedBox(height: 30),
//                           // Button 1: Scan Using Camera
//                           _buildWhiteButton('Scan Using Camera', () async {
//                             await flutterTts.stop();
//                             await speechToText.stop();
//                             _isActive = false;
//
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => const ScanPage()),
//                             );
//
//                             _isActive = true;
//                             if (widget.voiceNavigationEnabled) await _speakOptions();
//                           }),
//                           const SizedBox(height: 20),
//                           // Button 2: Upload Image
//                           _buildWhiteButton('Upload Image', () async {
//                             await flutterTts.stop();
//                             await speechToText.stop();
//                             _isActive = false;
//
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => UploadPage(
//                                   voiceNavigationEnabled: widget.voiceNavigationEnabled,
//                                 ),
//                               ),
//                             );
//
//                             _isActive = true;
//                             if (widget.voiceNavigationEnabled) await _speakOptions();
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                     top: kToolbarHeight, left: 12, child: AnimatedHeader()),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: Container(
//           width: double.infinity,
//           height: 10,
//           color: Colors.grey.shade800,
//         ),
//       ),
//     );
//   }
// }
//
// /// =========================
// /// AnimatedHeader Widget
// /// =========================
// class AnimatedHeader extends StatefulWidget {
//   const AnimatedHeader({Key? key}) : super(key: key);
//   @override
//   State<AnimatedHeader> createState() => _AnimatedHeaderState();
// }
//
// class _AnimatedHeaderState extends State<AnimatedHeader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide =
//         Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(_c);
//     _fade = Tween<double>(begin: 0, end: 1).animate(_c);
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 320,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SlideTransition(
//             position: _slide,
//             child: FadeTransition(
//               opacity: _fade,
//               child: Image.asset('assets/images/stick3.png',
//                   height: 540, width: 120, fit: BoxFit.contain),
//             ),
//           ),
//           Transform.translate(
//             offset: const Offset(-78, 0),
//             child: FadeTransition(
//               opacity: _fade,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("LET'S SEE ",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18, fontWeight: FontWeight.w400)),
//                   Text("THE WORLD",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xFF5A4FCF))),
//                   Text("Together",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18, fontWeight: FontWeight.w500)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// =========================
// /// AnimatedCheck Widget
// /// =========================
// class AnimatedCheck extends StatefulWidget {
//   const AnimatedCheck({Key? key}) : super(key: key);
//   @override
//   State<AnimatedCheck> createState() => _AnimatedCheckState();
// }
//
// class _AnimatedCheckState extends State<AnimatedCheck>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide =
//         Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(_c);
//     _fade = Tween<double>(begin: 0, end: 1).animate(_c);
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 450,
//       width: 450,
//       child: SlideTransition(
//         position: _slide,
//         child: FadeTransition(
//           opacity: _fade,
//           child: Image.asset('assets/images/check.png', fit: BoxFit.contain),
//         ),
//       ),
//     );
//   }
// }
//
// /// =========================
// /// Animated White Button
// /// =========================
// class _AnimatedWhiteButton extends StatefulWidget {
//   const _AnimatedWhiteButton({required this.label, required this.onPressed});
//   final String label;
//   final VoidCallback onPressed;
//
//   @override
//   State<_AnimatedWhiteButton> createState() => _AnimatedWhiteButtonState();
// }
//
// class _AnimatedWhiteButtonState extends State<_AnimatedWhiteButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<double> _fade;
//   late final Animation<double> _yOffset;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
//       ..forward();
//     _fade = CurvedAnimation(parent: _c, curve: Curves.easeIn);
//     _yOffset = Tween<double>(begin: 12, end: 0)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: widget.onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size.fromHeight(50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: AnimatedBuilder(
//         animation: _c,
//         builder: (_, child) => Opacity(
//           opacity: _fade.value,
//           child: Transform.translate(offset: Offset(0, _yOffset.value), child: child),
//         ),
//         child: Text(
//           widget.label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }
//





// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:objectde/pages/upload.dart';
// import 'package:objectde/helpers/scan.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class OCRPage extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const OCRPage({Key? key, this.voiceNavigationEnabled = false}) : super(key: key);
//
//   @override
//   State<OCRPage> createState() => _OCRPageState();
// }
//
// class _OCRPageState extends State<OCRPage> with WidgetsBindingObserver {
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText speechToText = stt.SpeechToText();
//
//   bool isListening = false;
//   bool hasNavigated = false;
//   bool _isActive = true;
//   bool _ttsSpeaking = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     // Speak the page message after short delay
//     Future.delayed(const Duration(milliseconds: 600), () async {
//       await _speakOptions();
//     });
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     WidgetsBinding.instance.removeObserver(this);
//     speechToText.stop();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   /// Speak page message
//   Future<void> _speakOptions() async {
//     if (!_isActive) return;
//
//     String message = widget.voiceNavigationEnabled
//         ? "You are on the OCR Page. Say: Scan using camera, or Upload image."
//         : "You are on the OCR Page";
//
//     if (_ttsSpeaking) return;
//     _ttsSpeaking = true;
//
//     try {
//       await flutterTts.stop();
//       await flutterTts.speak(message);
//       try {
//         await flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {
//         await Future.delayed(const Duration(milliseconds: 500));
//       }
//     } finally {
//       _ttsSpeaking = false;
//     }
//
//     // Only start listening if voice navigation is enabled
//     if (!widget.voiceNavigationEnabled) return;
//
//     await Future.delayed(const Duration(milliseconds: 250));
//     await _startListening();
//   }
//
//   /// Start voice recognition
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await speechToText.initialize(
//       onError: (err) => print("❌ STT Error: $err"),
//       onStatus: (status) => print("🧠 STT Status: $status"),
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//
//       await speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 2),
//         onResult: (result) async {
//           if (!_isActive || !widget.voiceNavigationEnabled) return;
//           String command = result.recognizedWords.toLowerCase();
//
//           if (result.finalResult && command.isNotEmpty) {
//             await _handleVoiceCommand(command);
//           }
//         },
//       );
//     }
//   }
//
//   /// Handle user commands
//   Future<void> _handleVoiceCommand(String command) async {
//     if (hasNavigated) return;
//     hasNavigated = true;
//
//     await speechToText.stop();
//     await flutterTts.stop();
//
//     if (command.contains("camera")) {
//       await flutterTts.speak("Opening camera scanner...");
//       await flutterTts.awaitSpeakCompletion(true);
//       await Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const ScanPage()),
//       );
//
//       // After returning
//       hasNavigated = false;
//       _isActive = true;
//       await _speakOptions();
//     } else if (command.contains("upload")) {
//       await flutterTts.speak("Opening image upload...");
//       await flutterTts.awaitSpeakCompletion(true);
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => UploadPage(voiceNavigationEnabled: widget.voiceNavigationEnabled),
//         ),
//       );
//
//       // After returning
//       hasNavigated = false;
//       _isActive = true;
//       await _speakOptions();
//     } else {
//       await flutterTts.speak(
//           "Sorry, I didn’t catch that. Please say scan using camera, or upload image.");
//       await flutterTts.awaitSpeakCompletion(true);
//       hasNavigated = false;
//       await _startListening();
//     }
//   }
//
//   /// Handle back press
//   Future<bool> _onWillPop() async {
//     _isActive = false;
//     await speechToText.stop();
//     await flutterTts.stop();
//     return true;
//   }
//
//   Widget _buildWhiteButton(String text, VoidCallback onPressed) =>
//       _AnimatedWhiteButton(label: text, onPressed: onPressed);
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.white,
//                 Colors.white,
//                 Color(0xFFFFF1F7),
//                 Color(0xFFE1E1E1),
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: Stack(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(30),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 20),
//                           const Padding(
//                             padding: EdgeInsets.all(30),
//                             child: AnimatedCheck(),
//                           ),
//                           const SizedBox(height: 30),
//                           _buildWhiteButton('Scan Using Camera', () async {
//                             await flutterTts.stop();
//                             await speechToText.stop();
//
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (_) => const ScanPage()),
//                             );
//
//                             _isActive = true;
//                             await _speakOptions();
//                           }),
//                           const SizedBox(height: 20),
//                           _buildWhiteButton('Upload Image', () async {
//                             await flutterTts.stop();
//                             await speechToText.stop();
//
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => UploadPage(
//                                   voiceNavigationEnabled: widget.voiceNavigationEnabled,
//                                 ),
//                               ),
//                             );
//
//                             _isActive = true;
//                             await _speakOptions();
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                     top: kToolbarHeight, left: 12, child: AnimatedHeader()),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: Container(
//           width: double.infinity,
//           height: 10,
//           color: Colors.grey.shade800,
//         ),
//       ),
//     );
//   }
// }
//
// /// =========================
// /// AnimatedHeader Widget
// /// =========================
// class AnimatedHeader extends StatefulWidget {
//   const AnimatedHeader({Key? key}) : super(key: key);
//   @override
//   State<AnimatedHeader> createState() => _AnimatedHeaderState();
// }
//
// class _AnimatedHeaderState extends State<AnimatedHeader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide =
//         Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(_c);
//     _fade = Tween<double>(begin: 0, end: 1).animate(_c);
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 320,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SlideTransition(
//             position: _slide,
//             child: FadeTransition(
//               opacity: _fade,
//               child: Image.asset('assets/images/stick3.png',
//                   height: 540, width: 120, fit: BoxFit.contain),
//             ),
//           ),
//           Transform.translate(
//             offset: const Offset(-78, 0),
//             child: FadeTransition(
//               opacity: _fade,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("LET'S SEE ",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18, fontWeight: FontWeight.w400)),
//                   Text("THE WORLD",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xFF5A4FCF))),
//                   Text("Together",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18, fontWeight: FontWeight.w500)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// =========================
// /// AnimatedCheck Widget
// /// =========================
// class AnimatedCheck extends StatefulWidget {
//   const AnimatedCheck({Key? key}) : super(key: key);
//   @override
//   State<AnimatedCheck> createState() => _AnimatedCheckState();
// }
//
// class _AnimatedCheckState extends State<AnimatedCheck>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide =
//         Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(_c);
//     _fade = Tween<double>(begin: 0, end: 1).animate(_c);
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 450,
//       width: 450,
//       child: SlideTransition(
//         position: _slide,
//         child: FadeTransition(
//           opacity: _fade,
//           child: Image.asset('assets/images/check.png', fit: BoxFit.contain),
//         ),
//       ),
//     );
//   }
// }
//
// /// =========================
// /// Animated White Button
// /// =========================
// class _AnimatedWhiteButton extends StatefulWidget {
//   const _AnimatedWhiteButton({required this.label, required this.onPressed});
//   final String label;
//   final VoidCallback onPressed;
//
//   @override
//   State<_AnimatedWhiteButton> createState() => _AnimatedWhiteButtonState();
// }
//
// class _AnimatedWhiteButtonState extends State<_AnimatedWhiteButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<double> _fade;
//   late final Animation<double> _yOffset;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
//       ..forward();
//     _fade = CurvedAnimation(parent: _c, curve: Curves.easeIn);
//     _yOffset = Tween<double>(begin: 12, end: 0)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: widget.onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size.fromHeight(50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: AnimatedBuilder(
//         animation: _c,
//         builder: (_, child) => Opacity(
//           opacity: _fade.value,
//           child: Transform.translate(offset: Offset(0, _yOffset.value), child: child),
//         ),
//         child: Text(
//           widget.label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }




// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:objectde/pages/upload.dart';
// import 'package:objectde/helpers/scan.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class OCRPage extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const OCRPage({Key? key, this.voiceNavigationEnabled = false}) : super(key: key);
//
//   @override
//   State<OCRPage> createState() => _OCRPageState();
// }
//
// class _OCRPageState extends State<OCRPage> with WidgetsBindingObserver {
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText speechToText = stt.SpeechToText();
//
//   bool isListening = false;
//   bool hasNavigated = false;
//   bool _isActive = true;
//   bool _ttsSpeaking = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     // Speak the page message after short delay
//     Future.delayed(const Duration(milliseconds: 600), () async {
//       await _speakOptions();
//     });
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     WidgetsBinding.instance.removeObserver(this);
//     speechToText.stop();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   /// Speak page message
//   Future<void> _speakOptions() async {
//     if (!_isActive) return;
//
//     String message = widget.voiceNavigationEnabled
//         ? "You are on the OCR Page. Say: Scan using camera, or Upload image."
//         : "You are on the OCR Page";
//
//     if (_ttsSpeaking) return;
//     _ttsSpeaking = true;
//
//     try {
//       await flutterTts.stop();
//       await flutterTts.speak(message);
//       try {
//         await flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {
//         await Future.delayed(const Duration(milliseconds: 500));
//       }
//     } finally {
//       _ttsSpeaking = false;
//     }
//
//     // Only start listening if voice navigation is enabled
//     if (!widget.voiceNavigationEnabled) return;
//
//     await Future.delayed(const Duration(milliseconds: 250));
//     await _startListening();
//   }
//
//   /// Start voice recognition
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await speechToText.initialize(
//       onError: (err) => print("❌ STT Error: $err"),
//       onStatus: (status) => print("🧠 STT Status: $status"),
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//
//       await speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 2),
//         onResult: (result) async {
//           if (!_isActive || !widget.voiceNavigationEnabled) return;
//           String command = result.recognizedWords.toLowerCase();
//
//           if (result.finalResult && command.isNotEmpty) {
//             await _handleVoiceCommand(command);
//           }
//         },
//       );
//     }
//   }
//
//   /// Handle user commands
//   Future<void> _handleVoiceCommand(String command) async {
//     if (hasNavigated) return;
//     hasNavigated = true;
//
//     await speechToText.stop();
//     await flutterTts.stop();
//
//     if (command.contains("camera")) {
//       await flutterTts.speak("Opening camera scanner...");
//       await flutterTts.awaitSpeakCompletion(true);
//       await Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const ScanPage()),
//       );
//
//       // After returning
//       hasNavigated = false;
//       _isActive = true;
//       await _speakOptions();
//     } else if (command.contains("upload")) {
//       await flutterTts.speak("Opening image upload...");
//       await flutterTts.awaitSpeakCompletion(true);
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => UploadPage(voiceNavigationEnabled: widget.voiceNavigationEnabled),
//         ),
//       );
//
//       // After returning
//       hasNavigated = false;
//       _isActive = true;
//       await _speakOptions();
//     } else {
//       await flutterTts.speak(
//           "Sorry, I didn’t catch that. Please say scan using camera, or upload image.");
//       await flutterTts.awaitSpeakCompletion(true);
//       hasNavigated = false;
//       await _startListening();
//     }
//   }
//
//   /// Handle back press
//   Future<bool> _onWillPop() async {
//     // Stop TTS and STT safely even during speaking
//     if (_ttsSpeaking) {
//       await flutterTts.stop();
//       _ttsSpeaking = false;
//     }
//     await speechToText.stop();
//     return true; // Allow pop
//   }
//
//   Widget _buildWhiteButton(String text, VoidCallback onPressed) =>
//       _AnimatedWhiteButton(label: text, onPressed: onPressed);
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.white,
//                 Colors.white,
//                 Color(0xFFFFF1F7),
//                 Color(0xFFE1E1E1),
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: Stack(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(30),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 20),
//                           const Padding(
//                             padding: EdgeInsets.all(30),
//                             child: AnimatedCheck(),
//                           ),
//                           const SizedBox(height: 30),
//                           _buildWhiteButton('Scan Using Camera', () async {
//                             await flutterTts.stop();
//                             await speechToText.stop();
//
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (_) => const ScanPage()),
//                             );
//
//                             _isActive = true;
//                             await _speakOptions();
//                           }),
//                           const SizedBox(height: 20),
//                           _buildWhiteButton('Upload Image', () async {
//                             await flutterTts.stop();
//                             await speechToText.stop();
//
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => UploadPage(
//                                   voiceNavigationEnabled: widget.voiceNavigationEnabled,
//                                 ),
//                               ),
//                             );
//
//                             _isActive = true;
//                             await _speakOptions();
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                     top: kToolbarHeight, left: 12, child: AnimatedHeader()),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: Container(
//           width: double.infinity,
//           height: 10,
//           color: Colors.grey.shade800,
//         ),
//       ),
//     );
//   }
// }
//
// /// =========================
// /// AnimatedHeader Widget
// /// =========================
// class AnimatedHeader extends StatefulWidget {
//   const AnimatedHeader({Key? key}) : super(key: key);
//   @override
//   State<AnimatedHeader> createState() => _AnimatedHeaderState();
// }
//
// class _AnimatedHeaderState extends State<AnimatedHeader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide =
//         Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(_c);
//     _fade = Tween<double>(begin: 0, end: 1).animate(_c);
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 320,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SlideTransition(
//             position: _slide,
//             child: FadeTransition(
//               opacity: _fade,
//               child: Image.asset('assets/images/stick3.png',
//                   height: 540, width: 120, fit: BoxFit.contain),
//             ),
//           ),
//           Transform.translate(
//             offset: const Offset(-78, 0),
//             child: FadeTransition(
//               opacity: _fade,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("LET'S SEE ",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18, fontWeight: FontWeight.w400)),
//                   Text("THE WORLD",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xFF5A4FCF))),
//                   Text("Together",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18, fontWeight: FontWeight.w500)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// =========================
// /// AnimatedCheck Widget
// /// =========================
// class AnimatedCheck extends StatefulWidget {
//   const AnimatedCheck({Key? key}) : super(key: key);
//   @override
//   State<AnimatedCheck> createState() => _AnimatedCheckState();
// }
//
// class _AnimatedCheckState extends State<AnimatedCheck>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide =
//         Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(_c);
//     _fade = Tween<double>(begin: 0, end: 1).animate(_c);
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 450,
//       width: 450,
//       child: SlideTransition(
//         position: _slide,
//         child: FadeTransition(
//           opacity: _fade,
//           child: Image.asset('assets/images/check.png', fit: BoxFit.contain),
//         ),
//       ),
//     );
//   }
// }
//
// /// =========================
// /// Animated White Button
// /// =========================
// class _AnimatedWhiteButton extends StatefulWidget {
//   const _AnimatedWhiteButton({required this.label, required this.onPressed});
//   final String label;
//   final VoidCallback onPressed;
//
//   @override
//   State<_AnimatedWhiteButton> createState() => _AnimatedWhiteButtonState();
// }
//
// class _AnimatedWhiteButtonState extends State<_AnimatedWhiteButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<double> _fade;
//   late final Animation<double> _yOffset;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
//       ..forward();
//     _fade = CurvedAnimation(parent: _c, curve: Curves.easeIn);
//     _yOffset = Tween<double>(begin: 12, end: 0)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: widget.onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size.fromHeight(50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: AnimatedBuilder(
//         animation: _c,
//         builder: (_, child) => Opacity(
//           opacity: _fade.value,
//           child: Transform.translate(offset: Offset(0, _yOffset.value), child: child),
//         ),
//         child: Text(
//           widget.label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }




// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:objectde/pages/upload.dart';
// import 'package:objectde/helpers/scan.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class OCRPage extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const OCRPage({Key? key, this.voiceNavigationEnabled = false}) : super(key: key);
//
//   @override
//   State<OCRPage> createState() => _OCRPageState();
// }
//
// class _OCRPageState extends State<OCRPage> with WidgetsBindingObserver {
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText speechToText = stt.SpeechToText();
//
//   bool isListening = false;
//   bool hasNavigated = false;
//   bool _isActive = true;
//   bool _ttsSpeaking = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     // Speak the page message after short delay
//     Future.delayed(const Duration(milliseconds: 600), () async {
//       await _speakOptions();
//     });
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     WidgetsBinding.instance.removeObserver(this);
//     // best-effort synchronous stop in dispose
//     try {
//       speechToText.stop();
//     } catch (_) {}
//     try {
//       speechToText.cancel();
//     } catch (_) {}
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   /// Stop and cancel STT safely
//   Future<void> _stopSpeechToText() async {
//     try {
//       await speechToText.stop();
//     } catch (_) {}
//     try {
//       await speechToText.cancel();
//     } catch (_) {}
//     if (mounted) setState(() => isListening = false);
//     await Future.delayed(const Duration(milliseconds: 120)); // release mic
//   }
//
//   /// Speak page message
//   Future<void> _speakOptions() async {
//     if (!_isActive) return;
//
//     String message = widget.voiceNavigationEnabled
//         ? "You are on the OCR Page. Say: Scan using camera, or Upload image."
//         : "You are on the OCR Page";
//
//     if (_ttsSpeaking) return;
//     _ttsSpeaking = true;
//
//     try {
//       await flutterTts.stop();
//       await flutterTts.speak(message);
//       try {
//         await flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {
//         await Future.delayed(const Duration(milliseconds: 500));
//       }
//     } finally {
//       _ttsSpeaking = false;
//     }
//
//     // Only start listening if voice navigation is enabled
//     if (!widget.voiceNavigationEnabled) return;
//
//     await Future.delayed(const Duration(milliseconds: 250));
//     await _startListening();
//   }
//
//   /// Start voice recognition
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await speechToText.initialize(
//       onError: (err) => print("❌ STT Error: $err"),
//       onStatus: (status) => print("🧠 STT Status: $status"),
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//
//       await speechToText.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         pauseFor: const Duration(seconds: 5),
//         listenFor: const Duration(minutes: 2),
//         onResult: (result) async {
//           if (!_isActive || !widget.voiceNavigationEnabled) return;
//           String command = result.recognizedWords.toLowerCase();
//
//           if (result.finalResult && command.isNotEmpty) {
//             await _handleVoiceCommand(command);
//           }
//         },
//       );
//     }
//   }
//
//   /// Handle user commands
//   Future<void> _handleVoiceCommand(String command) async {
//     if (hasNavigated) return;
//     hasNavigated = true;
//
//     // Ensure STT is fully stopped and TTS is stopped before navigating
//     await _stopSpeechToText();
//     await flutterTts.stop();
//
//     if (command.contains("camera")) {
//       await flutterTts.speak("Opening camera scanner...");
//       await flutterTts.awaitSpeakCompletion(true);
//       await Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const ScanPage()),
//       );
//
//       // After returning: ensure mic released, then speak
//       hasNavigated = false;
//       _isActive = true;
//       await Future.delayed(const Duration(milliseconds: 120));
//       await _speakOptions();
//     } else if (command.contains("upload")) {
//       await flutterTts.speak("Opening image upload...");
//       await flutterTts.awaitSpeakCompletion(true);
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => UploadPage(voiceNavigationEnabled: widget.voiceNavigationEnabled),
//         ),
//       );
//
//       // After returning: ensure mic released, then speak
//       hasNavigated = false;
//       _isActive = true;
//       await Future.delayed(const Duration(milliseconds: 120));
//       await _speakOptions();
//     } else {
//       await flutterTts.speak(
//           "Sorry, I didn’t catch that. Please say scan using camera, or upload image.");
//       await flutterTts.awaitSpeakCompletion(true);
//       hasNavigated = false;
//       await _startListening();
//     }
//   }
//
//   /// Handle back press
//   Future<bool> _onWillPop() async {
//     // Stop TTS and STT safely even during speaking
//     if (_ttsSpeaking) {
//       await flutterTts.stop();
//       _ttsSpeaking = false;
//     }
//     await _stopSpeechToText();
//     return true; // Allow pop
//   }
//
//   Widget _buildWhiteButton(String text, VoidCallback onPressed) =>
//       _AnimatedWhiteButton(label: text, onPressed: onPressed);
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.white,
//                 Colors.white,
//                 Color(0xFFFFF1F7),
//                 Color(0xFFE1E1E1),
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: Stack(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(30),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 20),
//                           const Padding(
//                             padding: EdgeInsets.all(30),
//                             child: AnimatedCheck(),
//                           ),
//                           const SizedBox(height: 30),
//                           _buildWhiteButton('Scan Using Camera', () async {
//                             await flutterTts.stop();
//                             await _stopSpeechToText();
//
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (_) => const ScanPage()),
//                             );
//
//                             _isActive = true;
//                             await Future.delayed(const Duration(milliseconds: 120));
//                             await _speakOptions();
//                           }),
//                           const SizedBox(height: 20),
//                           _buildWhiteButton('Upload Image', () async {
//                             await flutterTts.stop();
//                             await _stopSpeechToText();
//
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => UploadPage(
//                                   voiceNavigationEnabled: widget.voiceNavigationEnabled,
//                                 ),
//                               ),
//                             );
//
//                             _isActive = true;
//                             await Future.delayed(const Duration(milliseconds: 120));
//                             await _speakOptions();
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                     top: kToolbarHeight, left: 12, child: AnimatedHeader()),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: Container(
//           width: double.infinity,
//           height: 10,
//           color: Colors.grey.shade800,
//         ),
//       ),
//     );
//   }
// }
//
// /// =========================
// /// AnimatedHeader Widget
// /// =========================
// class AnimatedHeader extends StatefulWidget {
//   const AnimatedHeader({Key? key}) : super(key: key);
//   @override
//   State<AnimatedHeader> createState() => _AnimatedHeaderState();
// }
//
// class _AnimatedHeaderState extends State<AnimatedHeader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide =
//         Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(_c);
//     _fade = Tween<double>(begin: 0, end: 1).animate(_c);
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 320,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SlideTransition(
//             position: _slide,
//             child: FadeTransition(
//               opacity: _fade,
//               child: Image.asset('assets/images/stick3.png',
//                   height: 540, width: 120, fit: BoxFit.contain),
//             ),
//           ),
//           Transform.translate(
//             offset: const Offset(-78, 0),
//             child: FadeTransition(
//               opacity: _fade,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("LET'S SEE ",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18, fontWeight: FontWeight.w400)),
//                   Text("THE WORLD",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xFF5A4FCF))),
//                   Text("Together",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18, fontWeight: FontWeight.w500)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// =========================
// /// AnimatedCheck Widget
// /// =========================
// class AnimatedCheck extends StatefulWidget {
//   const AnimatedCheck({Key? key}) : super(key: key);
//   @override
//   State<AnimatedCheck> createState() => _AnimatedCheckState();
// }
//
// class _AnimatedCheckState extends State<AnimatedCheck>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _fade;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
//     _slide =
//         Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(_c);
//     _fade = Tween<double>(begin: 0, end: 1).animate(_c);
//     _c.forward();
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 450,
//       width: 450,
//       child: SlideTransition(
//         position: _slide,
//         child: FadeTransition(
//           opacity: _fade,
//           child: Image.asset('assets/images/check.png', fit: BoxFit.contain),
//         ),
//       ),
//     );
//   }
// }
//
// /// =========================
// /// Animated White Button
// /// =========================
// class _AnimatedWhiteButton extends StatefulWidget {
//   const _AnimatedWhiteButton({required this.label, required this.onPressed});
//   final String label;
//   final VoidCallback onPressed;
//
//   @override
//   State<_AnimatedWhiteButton> createState() => _AnimatedWhiteButtonState();
// }
//
// class _AnimatedWhiteButtonState extends State<_AnimatedWhiteButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;
//   late final Animation<double> _fade;
//   late final Animation<double> _yOffset;
//
//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
//       ..forward();
//     _fade = CurvedAnimation(parent: _c, curve: Curves.easeIn);
//     _yOffset = Tween<double>(begin: 12, end: 0)
//         .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
//   }
//
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: widget.onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size.fromHeight(50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: AnimatedBuilder(
//         animation: _c,
//         builder: (_, child) => Opacity(
//           opacity: _fade.value,
//           child: Transform.translate(offset: Offset(0, _yOffset.value), child: child),
//         ),
//         child: Text(
//           widget.label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }



import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:objectde/pages/upload.dart';
import 'package:objectde/helpers/scan.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class OCRPage extends StatefulWidget {
  final bool voiceNavigationEnabled;

  const OCRPage({Key? key, this.voiceNavigationEnabled = false}) : super(key: key);

  @override
  State<OCRPage> createState() => _OCRPageState();
}

class _OCRPageState extends State<OCRPage> with WidgetsBindingObserver {
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText speechToText = stt.SpeechToText();

  bool isListening = false;
  bool hasNavigated = false;
  bool _isActive = true;
  bool _ttsSpeaking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Speak the page message after short delay
    Future.delayed(const Duration(milliseconds: 600), () async {
      if (_isActive) {
        await _speakOptions();
      }
    });
  }

  @override
  void dispose() {
    _isActive = false;
    WidgetsBinding.instance.removeObserver(this);
    // Stop STT
    try {
      speechToText.stop();
    } catch (_) {}
    try {
      speechToText.cancel();
    } catch (_) {}
    // Stop TTS
    try {
      flutterTts.stop();
    } catch (_) {}
    super.dispose();
  }

  /// Stop and cancel STT safely
  Future<void> _stopSpeechToText() async {
    try {
      await speechToText.stop();
    } catch (_) {}
    try {
      await speechToText.cancel();
    } catch (_) {}
    if (mounted) setState(() => isListening = false);
    await Future.delayed(const Duration(milliseconds: 120)); // release mic
  }

  /// Speak page message
  Future<void> _speakOptions() async {
    if (!_isActive) return;

    String message = widget.voiceNavigationEnabled
        ? "You are on the OCR Page. Say: Scan using camera, or Upload image."
        : "You are on the OCR Page";

    if (_ttsSpeaking) return;
    _ttsSpeaking = true;

    try {
      // Stop any previous TTS ONLY if not currently speaking
      try {
        await flutterTts.stop();
      } catch (_) {}

      // Small delay to ensure stop is processed
      await Future.delayed(const Duration(milliseconds: 100));

      // Speak the message
      await flutterTts.speak(message);

      // Wait for speech to complete
      try {
        await flutterTts.awaitSpeakCompletion(true);
      } catch (_) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } finally {
      _ttsSpeaking = false;
    }

    // Only start listening if voice navigation is enabled
    if (!widget.voiceNavigationEnabled) return;

    await Future.delayed(const Duration(milliseconds: 250));
    await _startListening();
  }

  /// Start voice recognition
  Future<void> _startListening() async {
    if (!widget.voiceNavigationEnabled || !_isActive) return;

    bool available = await speechToText.initialize(
      onError: (err) => print("❌ STT Error: $err"),
      onStatus: (status) => print("🧠 STT Status: $status"),
    );

    if (available) {
      setState(() => isListening = true);

      await speechToText.listen(
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
        pauseFor: const Duration(seconds: 5),
        listenFor: const Duration(minutes: 2),
        onResult: (result) async {
          if (!_isActive || !widget.voiceNavigationEnabled) return;
          String command = result.recognizedWords.toLowerCase();

          if (result.finalResult && command.isNotEmpty) {
            await _handleVoiceCommand(command);
          }
        },
      );
    }
  }

  /// Handle user commands
  Future<void> _handleVoiceCommand(String command) async {
    if (hasNavigated) return;
    hasNavigated = true;

    // Stop everything
    _isActive = false;
    await _stopSpeechToText();
    try {
      await flutterTts.stop();
    } catch (_) {}
    _ttsSpeaking = false;

    if (command.contains("camera")) {
      _ttsSpeaking = true;
      await flutterTts.speak("Opening camera scanner...");
      try {
        await flutterTts.awaitSpeakCompletion(true);
      } catch (_) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      _ttsSpeaking = false;

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ScanPage()),
      );

      // RETURNING BACK
      hasNavigated = false;
      _isActive = true;
      await _speakOnReturn();

    } else if (command.contains("upload")) {
      _ttsSpeaking = true;
      await flutterTts.speak("Opening image upload...");
      try {
        await flutterTts.awaitSpeakCompletion(true);
      } catch (_) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      _ttsSpeaking = false;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UploadPage(voiceNavigationEnabled: widget.voiceNavigationEnabled),
        ),
      );

      // RETURNING BACK
      hasNavigated = false;
      _isActive = true;
      await _speakOnReturn();

    } else {
      _ttsSpeaking = true;
      await flutterTts.speak(
          "Sorry, I didn't catch that. Please say scan using camera, or upload image.");
      try {
        await flutterTts.awaitSpeakCompletion(true);
      } catch (_) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      _ttsSpeaking = false;

      hasNavigated = false;
      _isActive = true;
      await _startListening();
    }
  }

  /// Speak on return from sub-modules (matches feature_screen pattern)
  Future<void> _speakOnReturn() async {
    if (!_isActive) return;

    await Future.delayed(const Duration(milliseconds: 300));

    if (widget.voiceNavigationEnabled) {
      // Voice navigation ON - speak options with commands
      await _speakOptions();
    } else {
      // Voice navigation OFF - just speak page message
      await _stopSpeechToText();
      await flutterTts.speak("You are on the OCR Page.");
    }
  }

  /// Handle back press - CRITICAL: Stop all audio and STT
  Future<bool> _onWillPop() async {
    _isActive = false;

    // Stop TTS
    try {
      await flutterTts.stop();
    } catch (_) {}
    _ttsSpeaking = false;

    // Stop STT
    await _stopSpeechToText();

    return true; // Allow pop
  }

  Widget _buildWhiteButton(String text, VoidCallback onPressed) =>
      _AnimatedWhiteButton(label: text, onPressed: onPressed);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.white,
                Color(0xFFFFF1F7),
                Color(0xFFE1E1E1),
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.all(30),
                            child: AnimatedCheck(),
                          ),
                          const SizedBox(height: 30),
                          _buildWhiteButton('Scan Using Camera', () async {
                            _isActive = false;
                            await _stopSpeechToText();
                            try {
                              await flutterTts.stop();
                            } catch (_) {}
                            _ttsSpeaking = false;

                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ScanPage()),
                            );

                            // RETURNING BACK
                            _isActive = true;
                            await _speakOnReturn();
                          }),
                          const SizedBox(height: 20),
                          _buildWhiteButton('Upload Image', () async {
                            _isActive = false;
                            await _stopSpeechToText();
                            try {
                              await flutterTts.stop();
                            } catch (_) {}
                            _ttsSpeaking = false;

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UploadPage(
                                  voiceNavigationEnabled: widget.voiceNavigationEnabled,
                                ),
                              ),
                            );

                            // RETURNING BACK
                            _isActive = true;
                            await _speakOnReturn();
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                const Positioned(
                    top: kToolbarHeight, left: 12, child: AnimatedHeader()),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 10,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }
}

/// =========================
/// AnimatedHeader Widget
/// =========================
class AnimatedHeader extends StatefulWidget {
  const AnimatedHeader({Key? key}) : super(key: key);
  @override
  State<AnimatedHeader> createState() => _AnimatedHeaderState();
}

class _AnimatedHeaderState extends State<AnimatedHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _slide =
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(_c);
    _fade = Tween<double>(begin: 0, end: 1).animate(_c);
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              child: Image.asset('assets/images/stick3.png',
                  height: 540, width: 120, fit: BoxFit.contain),
            ),
          ),
          Transform.translate(
            offset: const Offset(-78, 0),
            child: FadeTransition(
              opacity: _fade,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("LET'S SEE ",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w400)),
                  Text("THE WORLD",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5A4FCF))),
                  Text("Together",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// =========================
/// AnimatedCheck Widget
/// =========================
class AnimatedCheck extends StatefulWidget {
  const AnimatedCheck({Key? key}) : super(key: key);
  @override
  State<AnimatedCheck> createState() => _AnimatedCheckState();
}

class _AnimatedCheckState extends State<AnimatedCheck>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _slide =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(_c);
    _fade = Tween<double>(begin: 0, end: 1).animate(_c);
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      width: 450,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Image.asset('assets/images/check.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}

/// =========================
/// Animated White Button
/// =========================
class _AnimatedWhiteButton extends StatefulWidget {
  const _AnimatedWhiteButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  State<_AnimatedWhiteButton> createState() => _AnimatedWhiteButtonState();
}

class _AnimatedWhiteButtonState extends State<_AnimatedWhiteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<double> _yOffset;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeIn);
    _yOffset = Tween<double>(begin: 12, end: 0)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF5A4FCF),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3,
        shadowColor: Colors.black26,
      ),
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, child) => Opacity(
          opacity: _fade.value,
          child: Transform.translate(offset: Offset(0, _yOffset.value), child: child),
        ),
        child: Text(
          widget.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
