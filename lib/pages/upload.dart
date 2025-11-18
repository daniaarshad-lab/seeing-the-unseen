//
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
//
// class UploadPage extends StatefulWidget {
//   const UploadPage({Key? key}) : super(key: key);
//
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }
//
// class _UploadPageState extends State<UploadPage> {
//   XFile? _imageFile;
//   dynamic? _pickerror;
//   String? extracted = 'Recognised Extracted Text Will Appear Here';
//   final picker = ImagePicker();
//
//   _imgFromGallery() async {
//     try {
//       final image = await picker.pickImage(source: ImageSource.gallery);
//       EasyLoading.show(status: 'loading...');
//       if (image != null) {
//         extracted = await FlutterTesseractOcr.extractText(image.path);
//       } else {
//         extracted = "Recognised extracted text will be shown here";
//       }
//
//       setState(() {
//         if (image != null) {
//           _imageFile = image;
//         }
//       });
//
//       EasyLoading.dismiss();
//     } catch (e) {
//       setState(() {
//         _pickerror = e;
//       });
//       EasyLoading.dismiss();
//     }
//   }
//
//   Widget preview() {
//     if (_imageFile != null) {
//       return kIsWeb
//           ? Image.network(_imageFile!.path, fit: BoxFit.cover)
//           : Image.file(File(_imageFile!.path), fit: BoxFit.cover);
//     } else if (_pickerror != null) {
//       return const Text(
//         'Error: Select An Image (.PNG,.JPG,.JPEG,..)\nand Wait a Few Seconds',
//         textAlign: TextAlign.center,
//       );
//     } else {
//       return const Text(
//         'You have not yet picked an image\nUpload an Image and Wait a Few Seconds',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: Color(0xFF5A4FCF),
//         ),
//       );
//     }
//   }
//
//   Widget _buildStyledButton(String text, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size(200, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "OCR App",
//       debugShowCheckedModeBanner: false,
//       builder: EasyLoading.init(),
//       home: Container(
//         decoration: const BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment.topCenter,
//             radius: 1.5,
//             colors: [
//               // Colors.white,
//               Color(0xFFF4E9FF),
//               Color(0xFFF4E9FF),
//               // light purplish
//               Color(0xFFFFF1F7),
//
//               // light pink
//             ],
//             stops: [0.2, 0.6, 1.0],
//           ),
//         ),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             iconTheme: const IconThemeData(color: Colors.black),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () => Navigator.pop(context),
//             ),
//             title: const Text(
//               "Extract Text from Image",
//               style: TextStyle(
//                 color: const Color(0xFF5A4FCF),
//                 fontWeight: FontWeight.w300,
//               ),
//             ),
//           ),
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Material(
//                       elevation: 6, // controls shadow strength
//                       shadowColor: Colors.black26,
//                       borderRadius: BorderRadius.circular(12),
//                       child: Container(
//                         height: 250,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: Colors.white, // white background
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Center(child: preview()),
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//                     Hero(
//                       tag: const Key("upload"),
//                       child: _buildStyledButton("Upload Image", _imgFromGallery),
//                     ),
//                     const SizedBox(height: 30),
//                     Card(
//                       color: const Color(0xFF5A4FCF),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       elevation: 4,
//                       child: Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: SelectableText(
//                           extracted ?? "",
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 14),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           bottomNavigationBar: Container(
//             height: 10,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }




// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_tts/flutter_tts.dart';
//
// class UploadPage extends StatefulWidget {
//   const UploadPage({Key? key}) : super(key: key);
//
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }
//
// class _UploadPageState extends State<UploadPage> {
//   XFile? _imageFile;
//   dynamic? _pickerror;
//   String? extracted = 'Recognised Extracted Text Will Appear Here';
//   final picker = ImagePicker();
//   final FlutterTts flutterTts = FlutterTts();
//
//   /// Speak function
//   Future<void> _speakText(String text) async {
//     if (text.isEmpty) return;
//     print("Speaking text: $text");
//
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setPitch(1.0);
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//   }
//
//   _imgFromGallery() async {
//     try {
//       final image = await picker.pickImage(source: ImageSource.gallery);
//       EasyLoading.show(status: 'loading...');
//       if (image != null) {
//         extracted = await FlutterTesseractOcr.extractText(image.path);
//
//         /// ✅ Call speak function after text extraction
//         if (extracted != null && extracted!.isNotEmpty) {
//           await _speakText(extracted!);
//         }
//       } else {
//         extracted = "Recognised extracted text will be shown here";
//       }
//
//       setState(() {
//         if (image != null) {
//           _imageFile = image;
//         }
//       });
//
//       EasyLoading.dismiss();
//     } catch (e) {
//       setState(() {
//         _pickerror = e;
//       });
//       EasyLoading.dismiss();
//     }
//   }
//
//   Widget preview() {
//     if (_imageFile != null) {
//       return kIsWeb
//           ? Image.network(_imageFile!.path, fit: BoxFit.cover)
//           : Image.file(File(_imageFile!.path), fit: BoxFit.cover);
//     } else if (_pickerror != null) {
//       return const Text(
//         'Error: Select An Image (.PNG,.JPG,.JPEG,..)\nand Wait a Few Seconds',
//         textAlign: TextAlign.center,
//       );
//     } else {
//       return const Text(
//         'You have not yet picked an image\nUpload an Image and Wait a Few Seconds',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: Color(0xFF5A4FCF),
//         ),
//       );
//     }
//   }
//
//   Widget _buildStyledButton(String text, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size(200, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "OCR App",
//       debugShowCheckedModeBanner: false,
//       builder: EasyLoading.init(),
//       home: Container(
//         decoration: const BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment.topCenter,
//             radius: 1.5,
//             colors: [
//               Color(0xFFF4E9FF),
//               Color(0xFFF4E9FF),
//               Color(0xFFFFF1F7),
//             ],
//             stops: [0.2, 0.6, 1.0],
//           ),
//         ),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             iconTheme: const IconThemeData(color: Colors.black),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () => Navigator.pop(context, extracted),
//             ),
//             title: const Text(
//               "Extract Text from Image",
//               style: TextStyle(
//                 color: Color(0xFF5A4FCF),
//                 fontWeight: FontWeight.w300,
//               ),
//             ),
//           ),
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Material(
//                       elevation: 6,
//                       shadowColor: Colors.black26,
//                       borderRadius: BorderRadius.circular(12),
//                       child: Container(
//                         height: 250,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Center(child: preview()),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Hero(
//                       tag: const Key("upload"),
//                       child: _buildStyledButton("Upload Image", _imgFromGallery),
//                     ),
//                     const SizedBox(height: 30),
//                     Card(
//                       color: const Color(0xFF5A4FCF),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       elevation: 4,
//                       child: Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: SelectableText(
//                           extracted ?? "",
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 14),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           bottomNavigationBar: Container(
//             height: 10,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }





// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart'; // 🎤 Added for speech input
//
// class UploadPage extends StatefulWidget {
//   const UploadPage({Key? key}) : super(key: key);
//
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }
//
// class _UploadPageState extends State<UploadPage> {
//   XFile? _imageFile;
//   dynamic? _pickerror;
//   String? extracted = 'Recognised Extracted Text Will Appear Here';
//   final picker = ImagePicker();
//   final FlutterTts flutterTts = FlutterTts();
//   final SpeechToText _speech = SpeechToText(); // 🎤 Added SpeechToText instance
//   bool _isListening = false;
//   String _lastWords = '';
//
//   /// 🗣️ Speak text function
//   Future<void> _speakText(String text) async {
//     if (text.isEmpty) return;
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setPitch(1.0);
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//   }
//
//   /// 📸 Pick image from gallery
//   Future<void> _imgFromGallery() async {
//     try {
//       final image = await picker.pickImage(source: ImageSource.gallery);
//       EasyLoading.show(status: 'loading...');
//       if (image != null) {
//         extracted = await FlutterTesseractOcr.extractText(image.path);
//
//         /// ✅ Speak extracted text after OCR
//         if (extracted != null && extracted!.isNotEmpty) {
//           await _speakText(extracted!);
//         }
//       } else {
//         extracted = "Recognised extracted text will be shown here";
//       }
//
//       setState(() {
//         if (image != null) {
//           _imageFile = image;
//         }
//       });
//
//       EasyLoading.dismiss();
//     } catch (e) {
//       setState(() {
//         _pickerror = e;
//       });
//       EasyLoading.dismiss();
//     }
//   }
//
//   /// 🎤 Start listening for commands
//   Future<void> _startListening() async {
//     bool available = await _speech.initialize(
//       onStatus: (status) {
//         if (status == 'done') {
//           // Restart listening automatically if needed
//           _startListening();
//         }
//       },
//       onError: (error) {
//         debugPrint("Speech error: $error");
//       },
//     );
//
//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(
//         onResult: (result) async {
//           setState(() => _lastWords = result.recognizedWords.toLowerCase());
//           debugPrint("Heard: $_lastWords");
//
//           // 🧠 If user says "upload image", trigger upload
//           if (_lastWords.contains("upload image")) {
//             await flutterTts.speak("Opening gallery...");
//             await _speech.stop();
//             setState(() => _isListening = false);
//             await _imgFromGallery();
//             await Future.delayed(const Duration(seconds: 2));
//             await _startListening(); // restart listening after action
//           }
//         },
//       );
//     } else {
//       await _speakText("Speech recognition not available.");
//     }
//   }
//
//   /// 🧠 Stop listening safely
//   Future<void> _stopListening() async {
//     if (_isListening) {
//       await _speech.stop();
//       setState(() => _isListening = false);
//     }
//   }
//
//   /// 🎯 Speak when the page opens
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _speakText(
//           "You are now on the upload image page. Say 'Upload Image' to open the gallery.");
//       await _startListening(); // 🎤 start listening after initial message
//     });
//   }
//
//   @override
//   void dispose() {
//     _stopListening(); // 🎤 stop listening when leaving screen
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   /// 🖼️ Image preview widget
//   Widget preview() {
//     if (_imageFile != null) {
//       return kIsWeb
//           ? Image.network(_imageFile!.path, fit: BoxFit.cover)
//           : Image.file(File(_imageFile!.path), fit: BoxFit.cover);
//     } else if (_pickerror != null) {
//       return const Text(
//         'Error: Select An Image (.PNG,.JPG,.JPEG,..)\nand Wait a Few Seconds',
//         textAlign: TextAlign.center,
//       );
//     } else {
//       return const Text(
//         'You have not yet picked an image\nUpload an Image and Wait a Few Seconds',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: Color(0xFF5A4FCF),
//         ),
//       );
//     }
//   }
//
//   /// 🧱 Styled button widget
//   Widget _buildStyledButton(String text, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size(200, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
//
//   /// 🧩 Main widget
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "OCR App",
//       debugShowCheckedModeBanner: false,
//       builder: EasyLoading.init(),
//       home: Container(
//         decoration: const BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment.topCenter,
//             radius: 1.5,
//             colors: [
//               Color(0xFFF4E9FF),
//               Color(0xFFF4E9FF),
//               Color(0xFFFFF1F7),
//             ],
//             stops: [0.2, 0.6, 1.0],
//           ),
//         ),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             iconTheme: const IconThemeData(color: Colors.black),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () async {
//                 await _stopListening();
//                 await flutterTts.speak(
//                     "Returning to main menu. You can say: Vision, OCR, Object Detection, Task Management, or Person Detection.");
//                 Navigator.pop(context, extracted);
//               },
//             ),
//             title: const Text(
//               "Extract Text from Image",
//               style: TextStyle(
//                 color: Color(0xFF5A4FCF),
//                 fontWeight: FontWeight.w300,
//               ),
//             ),
//           ),
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Material(
//                       elevation: 6,
//                       shadowColor: Colors.black26,
//                       borderRadius: BorderRadius.circular(12),
//                       child: Container(
//                         height: 250,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Center(child: preview()),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Hero(
//                       tag: const Key("upload"),
//                       child:
//                       _buildStyledButton("Upload Image", _imgFromGallery),
//                     ),
//                     const SizedBox(height: 30),
//                     Card(
//                       color: const Color(0xFF5A4FCF),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       elevation: 4,
//                       child: Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: SelectableText(
//                           extracted ?? "",
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 14),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     if (_isListening)
//                       const Text(
//                         "🎤 Listening for: 'Upload Image'...",
//                         style: TextStyle(color: Colors.deepPurple),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           bottomNavigationBar: Container(
//             height: 10,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class UploadPage extends StatefulWidget {
//   final bool voiceNavigationEnabled; // ✅ accept from OCRPage
//
//   const UploadPage({Key? key, this.voiceNavigationEnabled = false}) : super(key: key);
//
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }
//
// class _UploadPageState extends State<UploadPage> {
//   XFile? _imageFile;
//   dynamic? _pickerror;
//   String? extracted = 'Recognised Extracted Text Will Appear Here';
//   final picker = ImagePicker();
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;
//   bool _isActive = true;
//   String _lastWords = '';
//
//   /// 🗣️ Speak text function
//   Future<void> _speakText(String text) async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//     if (text.isEmpty) return;
//
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setPitch(1.0);
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//     await flutterTts.awaitSpeakCompletion(true);
//   }
//
//   /// 📸 Pick image from gallery
//   Future<void> _imgFromGallery() async {
//     try {
//       final image = await picker.pickImage(source: ImageSource.gallery);
//       EasyLoading.show(status: 'loading...');
//       if (image != null) {
//         extracted = await FlutterTesseractOcr.extractText(image.path);
//
//         /// ✅ Speak extracted text after OCR
//         if (extracted != null && extracted!.isNotEmpty) {
//           await _speakText(extracted!);
//         }
//       } else {
//         extracted = "Recognised extracted text will be shown here";
//       }
//
//       setState(() {
//         if (image != null) _imageFile = image;
//       });
//
//       EasyLoading.dismiss();
//     } catch (e) {
//       setState(() {
//         _pickerror = e;
//       });
//       EasyLoading.dismiss();
//     }
//   }
//
//   /// 🎤 Start listening for commands
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await _speech.initialize(
//       onStatus: (status) {
//         if (status == 'done' && _isActive) {
//           // Restart listening automatically if needed
//           _startListening();
//         }
//       },
//       onError: (error) {
//         debugPrint("Speech error: $error");
//       },
//     );
//
//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         onResult: (result) async {
//           if (!_isActive) return;
//
//           setState(() => _lastWords = result.recognizedWords.toLowerCase());
//           debugPrint("Heard: $_lastWords");
//
//           // 🧠 If user says "upload image", trigger upload
//           if (_lastWords.contains("upload image") && result.finalResult) {
//             await flutterTts.speak("Opening gallery...");
//             await _speech.stop();
//             setState(() => _isListening = false);
//             await _imgFromGallery();
//             await Future.delayed(const Duration(seconds: 1));
//             await _startListening(); // restart listening
//           }
//         },
//       );
//     } else {
//       await _speakText("Speech recognition not available.");
//     }
//   }
//
//   /// 🧠 Stop listening safely
//   Future<void> _stopListening() async {
//     if (_isListening) {
//       await _speech.stop();
//       setState(() => _isListening = false);
//     }
//   }
//
//   /// 🎯 Speak instructions when the page opens
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (widget.voiceNavigationEnabled) {
//         await _speakText(
//             "You are now on the upload image page. Say 'Upload Image' to open the gallery.");
//         await _startListening();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _stopListening(); // stop STT
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   /// 🖼️ Image preview widget
//   Widget preview() {
//     if (_imageFile != null) {
//       return kIsWeb
//           ? Image.network(_imageFile!.path, fit: BoxFit.cover)
//           : Image.file(File(_imageFile!.path), fit: BoxFit.cover);
//     } else if (_pickerror != null) {
//       return const Text(
//         'Error: Select An Image (.PNG,.JPG,.JPEG,..)\nand Wait a Few Seconds',
//         textAlign: TextAlign.center,
//       );
//     } else {
//       return const Text(
//         'You have not yet picked an image\nUpload an Image and Wait a Few Seconds',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: Color(0xFF5A4FCF),
//         ),
//       );
//     }
//   }
//
//   /// 🧱 Styled button widget
//   Widget _buildStyledButton(String text, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size(200, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
//
//   /// 🧩 Main widget
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () async {
//             _isActive = false;
//             await _stopListening();
//             await flutterTts.stop();
//             Navigator.pop(context, extracted);
//           },
//         ),
//         title: const Text(
//           "Extract Text from Image",
//           style: TextStyle(
//             color: Color(0xFF5A4FCF),
//             fontWeight: FontWeight.w300,
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment.topCenter,
//             radius: 1.5,
//             colors: [
//               Color(0xFFF4E9FF),
//               Color(0xFFF4E9FF),
//               Color(0xFFFFF1F7),
//             ],
//             stops: [0.2, 0.6, 1.0],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Material(
//                     elevation: 6,
//                     shadowColor: Colors.black26,
//                     borderRadius: BorderRadius.circular(12),
//                     child: Container(
//                       height: 450,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Center(child: preview()),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Hero(
//                     tag: const Key("upload"),
//                     child: _buildStyledButton("Upload Image", _imgFromGallery),
//                   ),
//                   const SizedBox(height: 30),
//                   Card(
//                     color: const Color(0xFF5A4FCF),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: SelectableText(
//                         extracted ?? "",
//                         style: const TextStyle(color: Colors.white, fontSize: 14),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   if (_isListening)
//                     const Text(
//                       "🎤 Listening for: 'Upload Image'...",
//                       style: TextStyle(color: Colors.deepPurple),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         height: 10,
//         color: Colors.white,
//       ),
//     );
//   }
// }





// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class UploadPage extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const UploadPage({Key? key, this.voiceNavigationEnabled = false})
//       : super(key: key);
//
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }
//
// class _UploadPageState extends State<UploadPage> {
//   XFile? _imageFile;
//   dynamic? _pickerror;
//   String? extracted = 'Recognised Extracted Text Will Appear Here';
//   final picker = ImagePicker();
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;
//   bool _isActive = true;
//   bool _hasSpokenInitial = false; // ✅ flag to prevent repeating TTS
//   String _lastWords = '';
//
//   /// 🗣️ Speak text function
//   Future<void> _speakText(String text) async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//     if (text.isEmpty) return;
//
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setPitch(1.0);
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//     await flutterTts.awaitSpeakCompletion(true);
//   }
//
//   /// 📸 Pick image from gallery
//   Future<void> _imgFromGallery() async {
//     // Stop TTS and STT before opening gallery
//     await flutterTts.stop();
//     await _stopListening();
//
//     try {
//       final image = await picker.pickImage(source: ImageSource.gallery);
//       EasyLoading.show(status: 'loading...');
//
//       if (image != null) {
//         extracted = await FlutterTesseractOcr.extractText(image.path);
//
//         if (extracted != null && extracted!.isNotEmpty) {
//           await _speakText(extracted!);
//         }
//       } else {
//         extracted = "Recognised extracted text will be shown here";
//       }
//
//       setState(() {
//         if (image != null) _imageFile = image;
//       });
//
//       EasyLoading.dismiss();
//     } catch (e) {
//       setState(() {
//         _pickerror = e;
//       });
//       EasyLoading.dismiss();
//     }
//   }
//
//   /// 🎤 Start listening for commands
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await _speech.initialize(
//       onStatus: (status) {
//         if (status == 'done' && _isActive) {
//           _startListening(); // restart listening automatically
//         }
//       },
//       onError: (error) {
//         debugPrint("Speech error: $error");
//       },
//     );
//
//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         onResult: (result) async {
//           if (!_isActive) return;
//
//           setState(() => _lastWords = result.recognizedWords.toLowerCase());
//
//           if (_lastWords.contains("upload image") && result.finalResult) {
//             await flutterTts.speak("Opening gallery...");
//             await _speech.stop();
//             setState(() => _isListening = false);
//             await _imgFromGallery();
//             await Future.delayed(const Duration(seconds: 1));
//             await _startListening(); // restart listening after action
//           }
//         },
//       );
//     } else {
//       await _speakText("Speech recognition not available.");
//     }
//   }
//
//   /// 🧠 Stop listening safely
//   Future<void> _stopListening() async {
//     if (_isListening) {
//       await _speech.stop();
//       setState(() => _isListening = false);
//     }
//   }
//
//   /// 🎯 Speak initial instructions only once
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (widget.voiceNavigationEnabled && !_hasSpokenInitial) {
//         _hasSpokenInitial = true;
//         await _speakText(
//             "You are now on the upload image page. Say 'Upload Image' to open the gallery.");
//         await _startListening();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _stopListening();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   /// 🖼️ Image preview widget
//   Widget preview() {
//     if (_imageFile != null) {
//       return kIsWeb
//           ? Image.network(_imageFile!.path, fit: BoxFit.cover)
//           : Image.file(File(_imageFile!.path), fit: BoxFit.cover);
//     } else if (_pickerror != null) {
//       return const Text(
//         'Error: Select An Image (.PNG,.JPG,.JPEG,..)\nand Wait a Few Seconds',
//         textAlign: TextAlign.center,
//       );
//     } else {
//       return const Text(
//         'You have not yet picked an image\nUpload an Image and Wait a Few Seconds',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: Color(0xFF5A4FCF),
//         ),
//       );
//     }
//   }
//
//   /// 🧱 Styled button widget
//   Widget _buildStyledButton(String text, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: () async {
//         // ✅ Stop TTS and STT immediately when button is pressed
//         await flutterTts.stop();
//         await _stopListening();
//         onPressed();
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size(200, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
//
//   /// 🧩 Main widget
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () async {
//             _isActive = false;
//             await _stopListening();
//             await flutterTts.stop();
//             Navigator.pop(context, extracted);
//           },
//         ),
//         title: const Text(
//           "Extract Text from Image",
//           style: TextStyle(
//             color: Color(0xFF5A4FCF),
//             fontWeight: FontWeight.w300,
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment.topCenter,
//             radius: 1.5,
//             colors: [
//               Color(0xFFF4E9FF),
//               Color(0xFFF4E9FF),
//               Color(0xFFFFF1F7),
//             ],
//             stops: [0.2, 0.6, 1.0],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Material(
//                     elevation: 6,
//                     shadowColor: Colors.black26,
//                     borderRadius: BorderRadius.circular(12),
//                     child: Container(
//                       height: 450,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Center(child: preview()),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Hero(
//                     tag: const Key("upload"),
//                     child: _buildStyledButton("Upload Image", _imgFromGallery),
//                   ),
//                   const SizedBox(height: 30),
//                   Card(
//                     color: const Color(0xFF5A4FCF),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: SelectableText(
//                         extracted ?? "",
//                         style: const TextStyle(color: Colors.white, fontSize: 14),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   if (_isListening)
//                     const Text(
//                       "🎤 Listening for: 'Upload Image'...",
//                       style: TextStyle(color: Colors.deepPurple),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         height: 10,
//         color: Colors.white,
//       ),
//     );
//   }
// }




// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class UploadPage extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const UploadPage({Key? key, this.voiceNavigationEnabled = false})
//       : super(key: key);
//
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }
//
// class _UploadPageState extends State<UploadPage> {
//   XFile? _imageFile;
//   dynamic? _pickerror;
//   String? extracted = 'Recognised Extracted Text Will Appear Here';
//   final picker = ImagePicker();
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;
//   bool _isActive = true;
//   String _lastWords = '';
//
//   /// 🗣️ Speak text function
//   Future<void> _speakText(String text) async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//     if (text.isEmpty) return;
//
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setPitch(1.0);
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//     await flutterTts.awaitSpeakCompletion(true);
//   }
//
//   /// 📸 Pick image from gallery
//   Future<void> _imgFromGallery() async {
//     // Stop TTS and STT before opening gallery
//     await flutterTts.stop();
//     await _stopListening();
//
//     try {
//       final image = await picker.pickImage(source: ImageSource.gallery);
//       EasyLoading.show(status: 'loading...');
//
//       if (image != null) {
//         extracted = await FlutterTesseractOcr.extractText(image.path);
//
//         if (extracted != null && extracted!.isNotEmpty) {
//           await _speakText(extracted!); // Speak extracted text
//         }
//
//         setState(() {
//           _imageFile = image;
//         });
//       } else {
//         extracted = "Recognised extracted text will be shown here";
//       }
//
//       EasyLoading.dismiss();
//     } catch (e) {
//       setState(() {
//         _pickerror = e;
//       });
//       EasyLoading.dismiss();
//     }
//
//     // Resume listening after returning from gallery
//     if (widget.voiceNavigationEnabled && _isActive) {
//       await _startListening();
//     }
//   }
//
//   /// 🎤 Start listening for commands
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await _speech.initialize(
//       onStatus: (status) {
//         if (status == 'done' && _isActive) {
//           _startListening(); // restart listening automatically
//         }
//       },
//       onError: (error) {
//         debugPrint("Speech error: $error");
//       },
//     );
//
//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         onResult: (result) async {
//           if (!_isActive) return;
//
//           setState(() => _lastWords = result.recognizedWords.toLowerCase());
//
//           // 🧠 If user says "upload image", trigger upload
//           if (_lastWords.contains("upload image") && result.finalResult) {
//             await flutterTts.speak("Opening gallery...");
//             await _speech.stop();
//             setState(() => _isListening = false);
//             await _imgFromGallery();
//           }
//         },
//       );
//     } else {
//       await _speakText("Speech recognition not available.");
//     }
//   }
//
//   /// 🧠 Stop listening safely
//   Future<void> _stopListening() async {
//     if (_isListening) {
//       await _speech.stop();
//       setState(() => _isListening = false);
//     }
//   }
//
//   /// 🎯 Speak initial instructions only once when page opens
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (widget.voiceNavigationEnabled && _isActive) {
//         await _speakText(
//             "You are now on the upload image page. Say 'Upload Image' to open the gallery.");
//         await _startListening();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _stopListening();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   /// 🖼️ Image preview widget
//   Widget preview() {
//     if (_imageFile != null) {
//       return kIsWeb
//           ? Image.network(_imageFile!.path, fit: BoxFit.cover)
//           : Image.file(File(_imageFile!.path), fit: BoxFit.cover);
//     } else if (_pickerror != null) {
//       return const Text(
//         'Error: Select An Image (.PNG,.JPG,.JPEG,..)\nand Wait a Few Seconds',
//         textAlign: TextAlign.center,
//       );
//     } else {
//       return const Text(
//         'You have not yet picked an image\nUpload an Image and Wait a Few Seconds',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: Color(0xFF5A4FCF),
//         ),
//       );
//     }
//   }
//
//   /// 🧱 Styled button widget
//   Widget _buildStyledButton(String text, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: () async {
//         // Stop TTS/STT immediately when button is pressed
//         await flutterTts.stop();
//         await _stopListening();
//         onPressed();
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size(200, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
//
//   /// 🧩 Main widget
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () async {
//             _isActive = false;
//             await _stopListening();
//             await flutterTts.stop();
//             Navigator.pop(context, extracted);
//           },
//         ),
//         title: const Text(
//           "Extract Text from Image",
//           style: TextStyle(
//             color: Color(0xFF5A4FCF),
//             fontWeight: FontWeight.w300,
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment.topCenter,
//             radius: 1.5,
//             colors: [
//               Color(0xFFF4E9FF),
//               Color(0xFFF4E9FF),
//               Color(0xFFFFF1F7),
//             ],
//             stops: [0.2, 0.6, 1.0],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Material(
//                     elevation: 6,
//                     shadowColor: Colors.black26,
//                     borderRadius: BorderRadius.circular(12),
//                     child: Container(
//                       height: 450,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Center(child: preview()),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Hero(
//                     tag: const Key("upload"),
//                     child: _buildStyledButton("Upload Image", _imgFromGallery),
//                   ),
//                   const SizedBox(height: 30),
//                   Card(
//                     color: const Color(0xFF5A4FCF),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: SelectableText(
//                         extracted ?? "",
//                         style: const TextStyle(
//                             color: Colors.white, fontSize: 14),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   if (_isListening)
//                     const Text(
//                       "🎤 Listening for: 'Upload Image'...",
//                       style: TextStyle(color: Colors.deepPurple),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         height: 10,
//         color: Colors.white,
//       ),
//     );
//   }
// }
//



// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class UploadPage extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const UploadPage({Key? key, this.voiceNavigationEnabled = false})
//       : super(key: key);
//
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }
//
// class _UploadPageState extends State<UploadPage> {
//   XFile? _imageFile;
//   dynamic? _pickerror;
//   String? extracted = 'Recognised Extracted Text Will Appear Here';
//   final picker = ImagePicker();
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;
//   bool _isActive = true;
//   String _lastWords = '';
//   bool _hasSpokenInitial = false;
//
//   /// 🗣️ Speak text function
//   Future<void> _speakText(String text) async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//     if (text.isEmpty) return;
//
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setPitch(1.0);
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//     await flutterTts.awaitSpeakCompletion(true);
//   }
//
//   /// 📸 Pick image from gallery
//   Future<void> _imgFromGallery() async {
//     // Stop TTS/STT before opening gallery
//     await flutterTts.stop();
//     await _stopListening();
//
//     try {
//       final image = await picker.pickImage(source: ImageSource.gallery);
//       EasyLoading.show(status: 'loading...');
//
//       if (image != null) {
//         extracted = await FlutterTesseractOcr.extractText(image.path);
//
//         if (extracted != null && extracted!.isNotEmpty) {
//           await _speakText(extracted!); // Speak extracted text
//         }
//
//         setState(() {
//           _imageFile = image;
//         });
//       } else {
//         // User pressed back from gallery
//         if (widget.voiceNavigationEnabled && _isActive) {
//           await _speakText(
//               "You are now on the upload image page. Say 'Upload Image' to open the gallery.");
//         }
//       }
//
//       EasyLoading.dismiss();
//     } catch (e) {
//       setState(() {
//         _pickerror = e;
//       });
//       EasyLoading.dismiss();
//     }
//
//     // Resume listening if voice navigation is enabled
//     if (widget.voiceNavigationEnabled && _isActive) {
//       await _startListening();
//     }
//   }
//
//   /// 🎤 Start listening for commands
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await _speech.initialize(
//       onStatus: (status) {
//         if (status == 'done' && _isActive) {
//           _startListening(); // restart listening automatically
//         }
//       },
//       onError: (error) {
//         debugPrint("Speech error: $error");
//       },
//     );
//
//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         onResult: (result) async {
//           if (!_isActive) return;
//
//           setState(() => _lastWords = result.recognizedWords.toLowerCase());
//
//           if (_lastWords.contains("upload image") && result.finalResult) {
//             await flutterTts.speak("Opening gallery...");
//             await _speech.stop();
//             setState(() => _isListening = false);
//             await _imgFromGallery();
//           }
//         },
//       );
//     } else {
//       await _speakText("Speech recognition not available.");
//     }
//   }
//
//   /// 🧠 Stop listening safely
//   Future<void> _stopListening() async {
//     if (_isListening) {
//       await _speech.stop();
//       setState(() => _isListening = false);
//     }
//   }
//
//   /// 🎯 Speak initial instructions only once
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (widget.voiceNavigationEnabled && !_hasSpokenInitial && _isActive) {
//         _hasSpokenInitial = true;
//         await _speakText(
//             "You are now on the upload image page. Say 'Upload Image' to open the gallery.");
//         await _startListening();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _stopListening();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   /// 🖼️ Image preview widget
//   Widget preview() {
//     if (_imageFile != null) {
//       return kIsWeb
//           ? Image.network(_imageFile!.path, fit: BoxFit.cover)
//           : Image.file(File(_imageFile!.path), fit: BoxFit.cover);
//     } else if (_pickerror != null) {
//       return const Text(
//         'Error: Select An Image (.PNG,.JPG,.JPEG,..)\nand Wait a Few Seconds',
//         textAlign: TextAlign.center,
//       );
//     } else {
//       return const Text(
//         'You have not yet picked an image\nUpload an Image and Wait a Few Seconds',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: Color(0xFF5A4FCF),
//         ),
//       );
//     }
//   }
//
//   /// 🧱 Styled button widget
//   Widget _buildStyledButton(String text, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: () async {
//         // Stop TTS/STT immediately when button is pressed
//         await flutterTts.stop();
//         await _stopListening();
//         onPressed();
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size(200, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
//
//   /// 🧩 Main widget
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () async {
//             _isActive = false;
//             await _stopListening();
//             await flutterTts.stop();
//             Navigator.pop(context, extracted);
//           },
//         ),
//         title: const Text(
//           "Extract Text from Image",
//           style: TextStyle(
//             color: Color(0xFF5A4FCF),
//             fontWeight: FontWeight.w300,
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment.topCenter,
//             radius: 1.5,
//             colors: [
//               Color(0xFFF4E9FF),
//               Color(0xFFF4E9FF),
//               Color(0xFFFFF1F7),
//             ],
//             stops: [0.2, 0.6, 1.0],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Material(
//                     elevation: 6,
//                     shadowColor: Colors.black26,
//                     borderRadius: BorderRadius.circular(12),
//                     child: Container(
//                       height: 450,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Center(child: preview()),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Hero(
//                     tag: const Key("upload"),
//                     child: _buildStyledButton("Upload Image", _imgFromGallery),
//                   ),
//                   const SizedBox(height: 30),
//                   Card(
//                     color: const Color(0xFF5A4FCF),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: SelectableText(
//                         extracted ?? "",
//                         style: const TextStyle(
//                             color: Colors.white, fontSize: 14),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   if (_isListening)
//                     const Text(
//                       "🎤 Listening for: 'Upload Image'...",
//                       style: TextStyle(color: Colors.deepPurple),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         height: 10,
//         color: Colors.white,
//       ),
//     );
//   }
// }
//



// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class UploadPage extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const UploadPage({Key? key, this.voiceNavigationEnabled = false})
//       : super(key: key);
//
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }
//
// class _UploadPageState extends State<UploadPage> {
//   XFile? _imageFile;
//   dynamic? _pickerror;
//   String? extracted = 'Recognised Extracted Text Will Appear Here';
//   final picker = ImagePicker();
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;
//   bool _isActive = true;
//   String _lastWords = '';
//   bool _hasSpokenInitial = false;
//   bool _ttsSpeaking = false;
//
//   /// 🗣️ Speak text function
//   Future<void> _speakText(String text) async {
//     if (!_isActive || text.isEmpty) return;
//     if (_ttsSpeaking) return;
//
//     _ttsSpeaking = true;
//     try {
//       await flutterTts.stop();
//       await flutterTts.setLanguage("en-US");
//       await flutterTts.setPitch(1.0);
//       await flutterTts.setSpeechRate(0.5);
//       await flutterTts.speak(text);
//       try {
//         await flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {
//         await Future.delayed(const Duration(milliseconds: 500));
//       }
//     } finally {
//       _ttsSpeaking = false;
//     }
//   }
//
//   /// 📸 Pick image from gallery
//   Future<void> _imgFromGallery() async {
//     await flutterTts.stop();
//     await _stopListening();
//
//     try {
//       final image = await picker.pickImage(source: ImageSource.gallery);
//       EasyLoading.show(status: 'loading...');
//
//       if (image != null) {
//         extracted = await FlutterTesseractOcr.extractText(image.path);
//
//         if (extracted != null && extracted!.isNotEmpty) {
//           await _speakText(extracted!);
//         }
//
//         setState(() {
//           _imageFile = image;
//         });
//       } else {
//         // fallback if gallery canceled
//         if (_isActive) {
//           await _speakInitialMessage();
//         }
//       }
//
//       EasyLoading.dismiss();
//     } catch (e) {
//       setState(() {
//         _pickerror = e;
//       });
//       EasyLoading.dismiss();
//     }
//
//     if (widget.voiceNavigationEnabled && _isActive) {
//       await _startListening();
//     }
//   }
//
//   /// 🎤 Start listening for commands
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await _speech.initialize(
//       onStatus: (status) {
//         if (status == 'done' && _isActive) {
//           _startListening(); // restart listening automatically
//         }
//       },
//       onError: (error) {
//         debugPrint("Speech error: $error");
//       },
//     );
//
//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         onResult: (result) async {
//           if (!_isActive) return;
//
//           _lastWords = result.recognizedWords.toLowerCase();
//
//           if (_lastWords.contains("upload image") && result.finalResult) {
//             await flutterTts.speak("Opening gallery...");
//             await _speech.stop();
//             setState(() => _isListening = false);
//             await _imgFromGallery();
//           }
//         },
//       );
//     } else {
//       await _speakText("Speech recognition not available.");
//     }
//   }
//
//   /// 🧠 Stop listening safely
//   Future<void> _stopListening() async {
//     if (_isListening) {
//       await _speech.stop();
//       setState(() => _isListening = false);
//     }
//   }
//
//   /// 🧩 Speak initial instructions depending on navigation type
//   Future<void> _speakInitialMessage() async {
//     if (!_isActive) return;
//
//     if (widget.voiceNavigationEnabled) {
//       await _speakText(
//           "You are now on the upload image page. Say 'Upload Image' to open the gallery.");
//     } else {
//       await _speakText("You are now on the upload image page.");
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (!_hasSpokenInitial && _isActive) {
//         _hasSpokenInitial = true;
//         await _speakInitialMessage();
//
//         if (widget.voiceNavigationEnabled) {
//           await _startListening();
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     _stopListening();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   /// 🖼️ Image preview widget
//   Widget preview() {
//     if (_imageFile != null) {
//       return kIsWeb
//           ? Image.network(_imageFile!.path, fit: BoxFit.cover)
//           : Image.file(File(_imageFile!.path), fit: BoxFit.cover);
//     } else if (_pickerror != null) {
//       return const Text(
//         'Error: Select An Image (.PNG,.JPG,.JPEG,..)\nand Wait a Few Seconds',
//         textAlign: TextAlign.center,
//       );
//     } else {
//       return const Text(
//         'You have not yet picked an image\nUpload an Image and Wait a Few Seconds',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: Color(0xFF5A4FCF),
//         ),
//       );
//     }
//   }
//
//   /// 🧱 Styled button widget
//   Widget _buildStyledButton(String text, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: () async {
//         await flutterTts.stop();
//         await _stopListening();
//         onPressed();
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size(200, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
//
//   /// 🧩 Main widget
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () async {
//             _isActive = false;
//             await _stopListening();
//             await flutterTts.stop();
//             Navigator.pop(context, extracted);
//           },
//         ),
//         title: const Text(
//           "Extract Text from Image",
//           style: TextStyle(
//             color: Color(0xFF5A4FCF),
//             fontWeight: FontWeight.w300,
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment.topCenter,
//             radius: 1.5,
//             colors: [
//               Color(0xFFF4E9FF),
//               Color(0xFFF4E9FF),
//               Color(0xFFFFF1F7),
//             ],
//             stops: [0.2, 0.6, 1.0],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Material(
//                     elevation: 6,
//                     shadowColor: Colors.black26,
//                     borderRadius: BorderRadius.circular(12),
//                     child: Container(
//                       height: 450,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Center(child: preview()),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Hero(
//                     tag: const Key("upload"),
//                     child:
//                     _buildStyledButton("Upload Image", _imgFromGallery),
//                   ),
//                   const SizedBox(height: 30),
//                   Card(
//                     color: const Color(0xFF5A4FCF),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: SelectableText(
//                         extracted ?? "",
//                         style: const TextStyle(
//                             color: Colors.white, fontSize: 14),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   if (_isListening)
//                     const Text(
//                       "🎤 Listening for: 'Upload Image'...",
//                       style: TextStyle(color: Colors.deepPurple),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         height: 10,
//         color: Colors.white,
//       ),
//     );
//   }
// }


// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class UploadPage extends StatefulWidget {
//   final bool voiceNavigationEnabled;
//
//   const UploadPage({Key? key, this.voiceNavigationEnabled = false})
//       : super(key: key);
//
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }
//
// class _UploadPageState extends State<UploadPage> {
//   XFile? _imageFile;
//   dynamic? _pickerror;
//   String? extracted = 'Recognised Extracted Text Will Appear Here';
//   final picker = ImagePicker();
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;
//   bool _isActive = true;
//   String _lastWords = '';
//   bool _hasSpokenInitial = false;
//   bool _ttsSpeaking = false;
//
//   /// 🗣️ Speak text function
//   Future<void> _speakText(String text) async {
//     if (!_isActive || text.isEmpty) return;
//     if (_ttsSpeaking) return;
//
//     _ttsSpeaking = true;
//     try {
//       await flutterTts.stop();
//       await flutterTts.setLanguage("en-US");
//       await flutterTts.setPitch(1.0);
//       await flutterTts.setSpeechRate(0.5);
//       await flutterTts.speak(text);
//       try {
//         await flutterTts.awaitSpeakCompletion(true);
//       } catch (_) {
//         await Future.delayed(const Duration(milliseconds: 500));
//       }
//     } finally {
//       _ttsSpeaking = false;
//     }
//   }
//
//   /// 📸 Pick image from gallery
//   Future<void> _imgFromGallery() async {
//     await flutterTts.stop();
//     await _stopListening();
//
//     try {
//       final image = await picker.pickImage(source: ImageSource.gallery);
//       EasyLoading.show(status: 'loading...');
//
//       if (image != null) {
//         extracted = await FlutterTesseractOcr.extractText(image.path);
//
//         if (extracted != null && extracted!.isNotEmpty) {
//           await _speakText(extracted!);
//         }
//
//         setState(() {
//           _imageFile = image;
//         });
//       } else {
//         // fallback if gallery canceled
//         if (_isActive) {
//           await _speakInitialMessage();
//         }
//       }
//
//       EasyLoading.dismiss();
//     } catch (e) {
//       setState(() {
//         _pickerror = e;
//       });
//       EasyLoading.dismiss();
//     }
//
//     if (widget.voiceNavigationEnabled && _isActive) {
//       await _startListening();
//     }
//   }
//
//   /// 🎤 Start listening for commands
//   Future<void> _startListening() async {
//     if (!widget.voiceNavigationEnabled || !_isActive) return;
//
//     bool available = await _speech.initialize(
//       onStatus: (status) {
//         if (status == 'done' && _isActive) {
//           _startListening(); // restart listening automatically
//         }
//       },
//       onError: (error) {
//         debugPrint("Speech error: $error");
//       },
//     );
//
//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(
//         listenMode: stt.ListenMode.dictation,
//         partialResults: true,
//         onResult: (result) async {
//           if (!_isActive) return;
//
//           _lastWords = result.recognizedWords.toLowerCase();
//
//           if (_lastWords.contains("upload image") && result.finalResult) {
//             await flutterTts.speak("Opening gallery...");
//             await _stopListening();
//             setState(() => _isListening = false);
//             await _imgFromGallery();
//           }
//         },
//       );
//     } else {
//       await _speakText("Speech recognition not available.");
//     }
//   }
//
//   /// 🧠 Stop listening safely (stops and cancels, waits briefly for mic release)
//   Future<void> _stopListening() async {
//     if (!_isListening) {
//       // Try to ensure any lingering STT sessions are cancelled too.
//       try {
//         await _speech.stop();
//       } catch (_) {}
//       try {
//         await _speech.cancel();
//       } catch (_) {}
//       return;
//     }
//
//     try {
//       await _speech.stop();
//     } catch (_) {}
//     try {
//       await _speech.cancel();
//     } catch (_) {}
//     if (mounted) setState(() => _isListening = false);
//
//     // small delay so platform can release mic/audio focus before main TTS
//     await Future.delayed(const Duration(milliseconds: 120));
//   }
//
//   /// 🧩 Speak initial instructions depending on navigation type
//   Future<void> _speakInitialMessage() async {
//     if (!_isActive) return;
//
//     if (widget.voiceNavigationEnabled) {
//       await _speakText(
//           "You are now on the upload image page. Say 'Upload Image' to open the gallery.");
//     } else {
//       await _speakText("You are now on the upload image page.");
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (!_hasSpokenInitial && _isActive) {
//         _hasSpokenInitial = true;
//         await _speakInitialMessage();
//
//         if (widget.voiceNavigationEnabled) {
//           await _startListening();
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _isActive = false;
//     // do best-effort synchronous cancel since dispose can't be async
//     try {
//       _speech.stop();
//     } catch (_) {}
//     try {
//       _speech.cancel();
//     } catch (_) {}
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   /// 🖼️ Image preview widget
//   Widget preview() {
//     if (_imageFile != null) {
//       return kIsWeb
//           ? Image.network(_imageFile!.path, fit: BoxFit.cover)
//           : Image.file(File(_imageFile!.path), fit: BoxFit.cover);
//     } else if (_pickerror != null) {
//       return const Text(
//         'Error: Select An Image (.PNG,.JPG,.JPEG,..)\nand Wait a Few Seconds',
//         textAlign: TextAlign.center,
//       );
//     } else {
//       return const Text(
//         'You have not yet picked an image\nUpload an Image and Wait a Few Seconds',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: Color(0xFF5A4FCF),
//         ),
//       );
//     }
//   }
//
//   /// 🧱 Styled button widget
//   Widget _buildStyledButton(String text, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: () async {
//         await flutterTts.stop();
//         await _stopListening();
//         onPressed();
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF5A4FCF),
//         minimumSize: const Size(200, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         elevation: 3,
//         shadowColor: Colors.black26,
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
//
//   /// 🧩 Main widget
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () async {
//             _isActive = false;
//             await _stopListening();
//             // small delay so mic is released before main page TTS starts
//             await Future.delayed(const Duration(milliseconds: 120));
//             await flutterTts.stop();
//             Navigator.pop(context, extracted);
//           },
//         ),
//         title: const Text(
//           "Extract Text from Image",
//           style: TextStyle(
//             color: Color(0xFF5A4FCF),
//             fontWeight: FontWeight.w300,
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment.topCenter,
//             radius: 1.5,
//             colors: [
//               Color(0xFFF4E9FF),
//               Color(0xFFF4E9FF),
//               Color(0xFFFFF1F7),
//             ],
//             stops: [0.2, 0.6, 1.0],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Material(
//                     elevation: 6,
//                     shadowColor: Colors.black26,
//                     borderRadius: BorderRadius.circular(12),
//                     child: Container(
//                       height: 450,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Center(child: preview()),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Hero(
//                     tag: const Key("upload"),
//                     child:
//                     _buildStyledButton("Upload Image", _imgFromGallery),
//                   ),
//                   const SizedBox(height: 30),
//                   Card(
//                     color: const Color(0xFF5A4FCF),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: SelectableText(
//                         extracted ?? "",
//                         style:
//                         const TextStyle(color: Colors.white, fontSize: 14),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   if (_isListening)
//                     const Text(
//                       "🎤 Listening for: 'Upload Image'...",
//                       style: TextStyle(color: Colors.deepPurple),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         height: 10,
//         color: Colors.white,
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class UploadPage extends StatefulWidget {
  final bool voiceNavigationEnabled;

  const UploadPage({Key? key, this.voiceNavigationEnabled = false})
      : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  XFile? _imageFile;
  dynamic? _pickerror;
  String? extracted = 'Recognised Extracted Text Will Appear Here';
  final picker = ImagePicker();
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isActive = true;
  String _lastWords = '';
  bool _hasSpokenInitial = false;
  bool _ttsSpeaking = false;

  /// 🗣️ Speak text function
  Future<void> _speakText(String text) async {
    if (!_isActive || text.isEmpty) return;
    if (_ttsSpeaking) return;

    _ttsSpeaking = true;
    try {
      try {
        await flutterTts.stop();
      } catch (_) {}

      await Future.delayed(const Duration(milliseconds: 100));

      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);

      await flutterTts.speak(text);
      try {
        await flutterTts.awaitSpeakCompletion(true);
      } catch (_) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } finally {
      _ttsSpeaking = false;
    }
  }

  /// 📸 Pick image from gallery
  Future<void> _imgFromGallery() async {
    await flutterTts.stop();
    await _stopListening();

    try {
      final image = await picker.pickImage(source: ImageSource.gallery);
      EasyLoading.show(status: 'loading...');

      if (image != null) {
        extracted = await FlutterTesseractOcr.extractText(image.path);

        if (extracted != null && extracted!.isNotEmpty) {
          await _speakText(extracted!);
        }

        setState(() {
          _imageFile = image;
        });
      } else {
        // fallback if gallery canceled
        if (_isActive) {
          await _speakInitialMessage();
        }
      }

      EasyLoading.dismiss();
    } catch (e) {
      setState(() {
        _pickerror = e;
      });
      EasyLoading.dismiss();
    }

    if (widget.voiceNavigationEnabled && _isActive) {
      await _startListening();
    }
  }

  /// 🎤 Start listening for commands
  Future<void> _startListening() async {
    if (!widget.voiceNavigationEnabled || !_isActive) return;

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' && _isActive) {
          _startListening(); // restart listening automatically
        }
      },
      onError: (error) {
        debugPrint("Speech error: $error");
      },
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
        onResult: (result) async {
          if (!_isActive) return;

          _lastWords = result.recognizedWords.toLowerCase();

          if (_lastWords.contains("upload image") && result.finalResult) {
            await flutterTts.speak("Opening gallery...");
            await _stopListening();
            setState(() => _isListening = false);
            await _imgFromGallery();
          }
        },
      );
    } else {
      await _speakText("Speech recognition not available.");
    }
  }

  /// 🧠 Stop listening safely (stops and cancels, waits briefly for mic release)
  Future<void> _stopListening() async {
    if (!_isListening) {
      // Try to ensure any lingering STT sessions are cancelled too.
      try {
        await _speech.stop();
      } catch (_) {}
      try {
        await _speech.cancel();
      } catch (_) {}
      return;
    }

    try {
      await _speech.stop();
    } catch (_) {}
    try {
      await _speech.cancel();
    } catch (_) {}
    if (mounted) setState(() => _isListening = false);

    // small delay so platform can release mic/audio focus before main TTS
    await Future.delayed(const Duration(milliseconds: 120));
  }

  /// 🧩 Speak initial instructions depending on navigation type
  Future<void> _speakInitialMessage() async {
    if (!_isActive) return;

    if (widget.voiceNavigationEnabled) {
      await _speakText(
          "You are now on the upload image page. Say 'Upload Image' to open the gallery.");
    } else {
      await _speakText("You are now on the upload image page.");
    }
  }

  /// Speak on return to parent (matches feature_screen pattern)
  Future<void> _speakOnReturn() async {
    if (!_isActive) return;

    await Future.delayed(const Duration(milliseconds: 300));

    if (widget.voiceNavigationEnabled) {
      await _speakInitialMessage();
      if (widget.voiceNavigationEnabled) {
        await _startListening();
      }
    } else {
      await _stopListening();
      await _speakText("You are now on the upload image page.");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_hasSpokenInitial && _isActive) {
        _hasSpokenInitial = true;
        await _speakInitialMessage();

        if (widget.voiceNavigationEnabled) {
          await _startListening();
        }
      }
    });
  }

  @override
  void dispose() {
    _isActive = false;
    // do best-effort synchronous cancel since dispose can't be async
    try {
      _speech.stop();
    } catch (_) {}
    try {
      _speech.cancel();
    } catch (_) {}
    try {
      flutterTts.stop();
    } catch (_) {}
    super.dispose();
  }

  /// 🖼️ Image preview widget
  Widget preview() {
    if (_imageFile != null) {
      return kIsWeb
          ? Image.network(_imageFile!.path, fit: BoxFit.cover)
          : Image.file(File(_imageFile!.path), fit: BoxFit.cover);
    } else if (_pickerror != null) {
      return const Text(
        'Error: Select An Image (.PNG,.JPG,.JPEG,..)\nand Wait a Few Seconds',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image\nUpload an Image and Wait a Few Seconds',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF5A4FCF),
        ),
      );
    }
  }

  /// 🧱 Styled button widget
  Widget _buildStyledButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: () async {
        await _stopListening();
        try {
          await flutterTts.stop();
        } catch (_) {}
        _ttsSpeaking = false;

        await Future.delayed(const Duration(milliseconds: 120));
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF5A4FCF),
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 3,
        shadowColor: Colors.black26,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  /// Handle back press - CRITICAL: Stop TTS and STT
  Future<bool> _onWillPop() async {
    _isActive = false;
    await _stopListening();

    try {
      await flutterTts.stop();
    } catch (_) {}
    _ttsSpeaking = false;

    return true; // Allow pop
  }

  /// 🧩 Main widget
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              _isActive = false;
              await _stopListening();
              try {
                await flutterTts.stop();
              } catch (_) {}
              _ttsSpeaking = false;
              Navigator.pop(context, extracted);
            },
          ),
          title: const Text(
            "Extract Text from Image",
            style: TextStyle(
              color: Color(0xFF5A4FCF),
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.5,
              colors: [
                Color(0xFFF4E9FF),
                Color(0xFFF4E9FF),
                Color(0xFFFFF1F7),
              ],
              stops: [0.2, 0.6, 1.0],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Material(
                      elevation: 6,
                      shadowColor: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 450,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: preview()),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Hero(
                      tag: const Key("upload"),
                      child:
                      _buildStyledButton("Upload Image", _imgFromGallery),
                    ),
                    const SizedBox(height: 30),
                    Card(
                      color: const Color(0xFF5A4FCF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SelectableText(
                          extracted ?? "",
                          style:
                          const TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isListening)
                      const Text(
                        "🎤 Listening for: 'Upload Image'...",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 10,
          color: Colors.white,
        ),
      ),
    );
  }
}
