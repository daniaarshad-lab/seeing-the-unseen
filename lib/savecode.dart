/*import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class VehicleTheftDetection extends StatefulWidget {
  const VehicleTheftDetection({super.key});

  @override
  State<VehicleTheftDetection> createState() => _VehicleTheftDetectionState();
}

class _VehicleTheftDetectionState extends State<VehicleTheftDetection> {
  CameraController? _cameraController;
  bool _isDetecting = false;
  bool _isDialogShowing = false;
  List<dynamic>? _recognitions;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
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
      if (!_isDetecting && !_isDialogShowing) {
        _isDetecting = true;

        _runModelOnFrame(image).then((recognitions) {
          setState(() {
            _recognitions = recognitions;
          });

          if (_isBothDetected() && !_isDialogShowing) {
            print("Both detected, showing dialog");
            _showDetectedDialog();
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
      return (label == "car" || label == "person") && confidence >= 0.65;
    }).toList();
  }

  bool _isBothDetected() {
    bool personDetected = _recognitions?.any((rec) => rec["detectedClass"] == "person") ?? false;
    bool carDetected = _recognitions?.any((rec) => rec["detectedClass"] == "car") ?? false;
    return personDetected && carDetected;
  }

  void _showDetectedDialog() {
    setState(() {
      _isDialogShowing = true;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text("Laptop and Cell Phone detected at the same time."),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isDialogShowing = false;
                });
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    ).then((_) {
      // Ensure _isDialogShowing is reset when the dialog is dismissed.
      setState(() {
        _isDialogShowing = false;
      });
    });
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
        title: Text('Vehicle Monitoring'),
      ),
      body: Stack(
        children: [
          _cameraController == null
              ? Center(child: CircularProgressIndicator())
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
              style: TextStyle(
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
*/