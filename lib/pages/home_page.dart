
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import '../helpers/biometrics_helper.dart';
import 'private_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [

                  Color(0xFF736FF3) ,
                  Color(0xFF736FF3) ,

                  Color(0xFFF494DB) ,
                  Color(0xFFF494DB) ,

                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Bottom clipped white wave over gradient
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 260,
              width: double.infinity,
              child: ClipPath(
                clipper: InnerWaveClipper(),
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(



                  children: [

                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildWhiteButton("Login with Fingerprint", _goToPrivatePage),
                    const SizedBox(height: 36),
                    _buildWhiteButton("Login with Face ID", _authenticateWithFace),
                    const SizedBox(height: 36),




                    const Text(
                      "Let's See The World Togather",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),



                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Image.asset(
                            "assets/images/Untitled design.png",
                            width: 240,
                            height: 240,
                          ),
                        ),
                      ],



                    ),




                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // New method to build buttons using image icons
  Widget _buildImageButton(String label, String imagePath) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Image.asset(
        imagePath,
        width: 24,
        height: 24,
      ),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3,
      ),
    );
  }


  Widget _buildWhiteButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF5A4FCF),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3,
        shadowColor: Colors.black26,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSocialButton(String label, Color color, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3,
      ),
    );
  }

  Future<void> _goToPrivatePage() async {
    if (!await BiometricHelper.isBiometricSupported()) {
      Fluttertoast.showToast(msg: "Device does not support biometrics.");
      return;
    }

    final availableBiometrics = await BiometricHelper.getAvailableBiometrics();
    if (availableBiometrics.isEmpty) {
      Fluttertoast.showToast(msg: "No biometrics found. Please set it up.");
      return;
    }

    final bool didAuthenticate = await BiometricHelper.authenticate();
    if (didAuthenticate && mounted) {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PrivatePage()));
    }
  }

  Future<void> _authenticateWithFace() async {
    print("this is called");
    // if (!await BiometricHelper.isBiometricSupported()) {
    //   Fluttertoast.showToast(msg: "Device does not support biometrics.");
    //   return;
    // }

    // final availableBiometrics = await BiometricHelper.getAvailableBiometrics();
    // Fluttertoast.showToast(msg: "Available biometrics##: $availableBiometrics");

    // if (!availableBiometrics.contains(BiometricType.face)) {
    //   Fluttertoast.showToast(msg: "Face ID not found. Please set it up.");
    //   return;
    // }

    final bool didAuthenticate = await BiometricHelper.authenticateWithFace();
    if (didAuthenticate && mounted) {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const PrivatePage()));
    }
  }
}

// White inner wave
class InnerWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.3);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.5, size.width * 0.5, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.3, size.width, size.height * 0.5);
    path.lineTo(size.width, size.height); // ensure it fills bottom
    path.lineTo(0, size.height); // close at the bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
































// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:local_auth/local_auth.dart';
// import '../helpers/biometrics_helper.dart';
// import 'private_page.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final LocalAuthentication auth = LocalAuthentication();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         children: [
//           // Gradient Background
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFFE0C3FC), // Light Purple
//                   Color(0xFF8EC5FC), // Light Blue
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//
//           // White wave layer
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: ClipPath(
//               // clipper: InnerWaveClipper(),
//               child: Container(
//                 height: 260,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//
//           // Content
//           SafeArea(
//             child: Center(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 32),
//                 child: Column(
//                   children: [
//                     const Text(
//                       "Login",
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 40),
//                     _buildWhiteButton("Login with Fingerprint", _goToPrivatePage),
//                     const SizedBox(height: 16),
//                     _buildWhiteButton("Login with Face ID", _authenticateWithFace),
//                     const SizedBox(height: 24),
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text(
//                         "Forgot your password?",
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                     ),
//                     const SizedBox(height: 140),
//                     const Text("or connect with", style: TextStyle(color: Colors.white)),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         _buildSocialButton("Facebook", Color(0xFF1877F2), Icons.facebook),
//                         const SizedBox(width: 16),
//                         _buildSocialButton("Twitter", Color(0xFF1DA1F2), Icons.travel_explore),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWhiteButton(String text, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         foregroundColor: Colors.black,
//         backgroundColor: Colors.white,
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       child: Text(text),
//     );
//   }
//
//   Widget _buildSocialButton(String text, Color color, IconData icon) {
//     return ElevatedButton.icon(
//       onPressed: () {},
//       icon: Icon(icon, color: Colors.white),
//       label: Text(text),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
//
//   Future<void> _goToPrivatePage() async {
//     if (!await BiometricHelper.isBiometricSupported()) {
//       Fluttertoast.showToast(msg: "Device does not support biometrics.");
//       return;
//     }
//
//     final availableBiometrics = await BiometricHelper.getAvailableBiometrics();
//     if (availableBiometrics.isEmpty) {
//       Fluttertoast.showToast(msg: "No biometrics found. Please set it up.");
//       return;
//     }
//
//     final bool didAuthenticate = await BiometricHelper.authenticate();
//     if (didAuthenticate && mounted) {
//       Navigator.of(context).push(
//         MaterialPageRoute(builder: (ctx) => const PrivatePage()),
//       );
//     }
//   }
//
//   Future<void> _authenticateWithFace() async {
//     if (!await BiometricHelper.isBiometricSupported()) {
//       Fluttertoast.showToast(msg: "Device does not support biometrics.");
//       return;
//     }
//
//     final availableBiometrics = await BiometricHelper.getAvailableBiometrics();
//
//     Fluttertoast.showToast(
//       msg: "Available biometrics: $availableBiometrics",
//       toastLength: Toast.LENGTH_LONG,
//     );
//
//     print("Available biometrics ##: $availableBiometrics");
//
//     // ✅ Fallback to device credentials if face not found
//     try {
//       final bool didAuthenticate = await auth.authenticate(
//         localizedReason: 'Please authenticate',
//         options: const AuthenticationOptions(
//           biometricOnly: true, // Use PIN, pattern, face, fingerprint, etc.
//           stickyAuth: true,
//         ),
//       );
//
//       if (didAuthenticate && mounted) {
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (ctx) => const PrivatePage()),
//         );
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Authentication failed: $e");
//     }
//   }
// }
