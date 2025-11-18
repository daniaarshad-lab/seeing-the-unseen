import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';

class BiometricHelper {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> isBiometricSupported() async {
    return await _auth.isDeviceSupported();
  }

  static Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
  }

  static Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      return didAuthenticate;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Biometric authentication failed. Try again!",
      );
      return false;
    }
  }


  static Future<bool> authenticateWithFace() async {
    print("Button pressed!");
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please scan your face to proceed',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      return didAuthenticate;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Face ID authentication failed. Try again!",
      );
      return false;
    }
  }

}
