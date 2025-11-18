
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:objectde/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );



  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // home: const AuthChecker(),
      // home: const ObjectDetectionScreen(),

      // home: HomePage(),
      home:SplashScreen(),



    );
  }
}

class TextToSpeech extends StatefulWidget {
  const TextToSpeech({super.key});

  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          ElevatedButton(
            onPressed: () {
              speak("laptop");
            },
            child: const Text("Sound"),
          ),
        ],
      ),
    );
  }
}




























































// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// // Import your custom pages and helpers
// import 'pages/home_page.dart';
// import 'helpers/routes.dart';
// import 'firebase_options.dart';
// import 'login.dart';
// import 'package:objectde/vechiletheftdetection.dart';
//
// // -----------------------------------------------------
// // Main entry point
// // -----------------------------------------------------
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   runApp(const MyApp());
// }
//
// // -----------------------------------------------------
// // App setup with route handling
// // -----------------------------------------------------
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//
//       // ----------------------------
//       // 🔽 ROUTING CONFIGURATION
//       // ----------------------------
//       initialRoute: MyRoutes.home,
//       routes: MyRoutes.getRoutes(),
//     );
//   }
// }
//
// // -----------------------------------------------------
// // Optional AuthChecker if needed
// // -----------------------------------------------------
// class AuthChecker extends StatelessWidget {
//   const AuthChecker({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       return const VehicleTheftDetection();
//     } else {
//       return const LoginPage();
//     }
//   }
// }
//
// // -----------------------------------------------------
// // Text-to-Speech functionality (separate from routes)
// // -----------------------------------------------------
// class TextToSpeech extends StatefulWidget {
//   const TextToSpeech({super.key});
//
//   @override
//   State<TextToSpeech> createState() => _TextToSpeechState();
// }
//
// class _TextToSpeechState extends State<TextToSpeech> {
//   final FlutterTts flutterTts = FlutterTts();
//   final TextEditingController textEditingController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions();
//   }
//
//   Future<void> requestPermissions() async {
//     var status = await Permission.microphone.status;
//     if (!status.isGranted) {
//       await Permission.microphone.request();
//     }
//   }
//
//   Future<void> speak(String text) async {
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setPitch(1.0);
//     await flutterTts.speak(text);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               speak("laptop");
//             },
//             child: const Text("Sound"),
//           ),
//         ],
//       ),
//     );
//   }
// }
