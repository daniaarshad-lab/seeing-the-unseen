import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

class VehicleTheftDetection extends StatefulWidget {
  const VehicleTheftDetection({super.key});

  @override
  State<VehicleTheftDetection> createState() => _VehicleTheftDetectionState();
}

class _VehicleTheftDetectionState extends State<VehicleTheftDetection> {
  CameraController? _cameraController;
  bool _isDetecting = false;
  List<dynamic>? _recognitions;
  String? alertDocId;
  Future<void> _retrieveUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        alertDocId = user.uid; // Store the user ID
      });
      print("User ID: $alertDocId"); // Debugging
    } else {
      print("No user is currently logged in.");
    }
  }
  @override
  void initState() {
    super.initState();
    _retrieveUserId();
    requestPermissions().then((granted) {
      if (granted) {
        _initializeCamera();
        _loadModel();
      } else {
        print("Permissions not granted");
      }
    });
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

    _cameraController!.startImageStream((CameraImage image) {
      if (!_isDetecting) {
        _isDetecting = true;

        _runModelOnFrame(image).then((recognitions) async {
          setState(() {
            _recognitions = recognitions;
          });

          if (_isBothDetected()) {
            await _checkAndUpdateAlert();
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
      numResultsPerClass: 3,
      threshold: 0.3,
      asynch: true,
    );

    return recognitions?.where((recognition) {
      final label = recognition["detectedClass"];
      final confidence = recognition["confidenceInClass"];
      return (label == "car" || label == "person") && confidence >= 0.55;
    }).toList();
  }

  bool _isBothDetected() {
    bool personDetected = _recognitions?.any((rec) => rec["detectedClass"] == "person") ?? false;
    bool carDetected = _recognitions?.any((rec) => rec["detectedClass"] == "car") ?? false;
    return personDetected && carDetected;
  }

  Future<void> _checkAndUpdateAlert() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;


    try {
      final doc = await firestore.collection("Alerts").doc(alertDocId).get();

      if (doc.exists) {
        final data = doc.data();
        if (data == null) return;

        final alarmEnabled = data["Alarm"] == "Enabled";
        print("Alarm status: ${alarmEnabled ? "Enabled" : "Disabled"}");
        if (!alarmEnabled) return;

        final startingTime = (data["StartingTime"] as Timestamp).toDate();
        final endingTime = (data["EndingTime"] as Timestamp).toDate();
        final lastRing = (data["LastRing"] as Timestamp).toDate();
        final currentTime = DateTime.now();

        // Print all the times for debugging
        print("Starting Time: $startingTime");
        print("Ending Time: $endingTime");
        print("Last Ring Time: $lastRing");
        print("Current Time: $currentTime");

        // Check comparisons and print results
        print("Current Time > Starting Time: ${currentTime.isAfter(startingTime)}");
        print("Current Time < Ending Time: ${currentTime.isBefore(endingTime)}");
        print(
            "Time Difference since Last Ring > 5 minutes: ${currentTime.difference(lastRing).inMinutes > 5}");

        // Check time conditions
        if (currentTime.isAfter(startingTime) &&
            currentTime.isBefore(endingTime) &&
            currentTime.difference(lastRing).inMinutes > 1) {
          // Update Alert to Ring
          await firestore.collection("Alerts").doc(alertDocId).update({
            "Alert": "Ring",
            "LastRing": Timestamp.fromDate(currentTime),
          });

          print("Alert updated to Ring");
        } else {
          print("Conditions not met for updating Alert.");
        }
      } else {
        print("Document with ID $alertDocId does not exist.");
      }
    } catch (e) {
      print("Error checking and updating alert: $e");
    }
  }


  @override
  void dispose() {
    _cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Vehicle Security System",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red[900],
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                // Log out the user
                await FirebaseAuth.instance.signOut();

                // Navigate to LoginPage
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      body: Stack(
        children: [
          _cameraController == null
              ? const Center(child: CircularProgressIndicator())
              : CameraPreview(_cameraController!),
          _buildRecognitionWidgets(),
        ],
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
              border: Border.all(
                color: Colors.red,
                width: 2.0,
              ),
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
