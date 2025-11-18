import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class EmotionDetectionScreen extends StatefulWidget {
  const EmotionDetectionScreen({super.key});

  @override
  _EmotionDetectionScreenState createState() => _EmotionDetectionScreenState();
}

class _EmotionDetectionScreenState extends State<EmotionDetectionScreen> {
  CameraController? _cameraController;
  bool _isDetecting = false;
  String? _recognizedEmotion;
  late CameraDescription frontCamera;

  // List to store detected emotions
  final List<String> _emotions = [];

  Timer? _timer; // Timer to stop detection after a certain duration
  final int _detectionDuration = 5; // Duration to observe emotions (in seconds)

  @override
  void initState() {
    super.initState();
    requestPermissions().then((granted) {
      if (granted) {
        _initializeCamera();
        _loadModel();
        _startEmotionDetectionTimer(); // Start the detection timer
      } else {
        print("Permissions not granted");
      }
    });
  }

  Future<bool> requestPermissions() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
    }

    return cameraStatus.isGranted;
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    _cameraController!.startImageStream((CameraImage image) {
      if (!_isDetecting) {
        _isDetecting = true;

        _runModelOnFrame(image).then((emotion) {
          setState(() {
            _recognizedEmotion = emotion;
            if (emotion != null) {
              _emotions.add(emotion); // Add detected emotion to list
            }
          });

          _isDetecting = false;
        });
      }
    });
  }

  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: "assets/facialemotionmodel.tflite",
      labels: "assets/emotion_labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  Future<String?> _runModelOnFrame(CameraImage image) async {
    int rotation = 0;
    if (frontCamera.sensorOrientation == 270) {
      rotation = -90;
    } else if (frontCamera.sensorOrientation == 90) {
      rotation = 90;
    }

    final List<dynamic>? recognitions = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: rotation,
      numResults: 1,
      threshold: 0.1,
      asynch: true,
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      return recognitions.first["label"];
    }
    return null;
  }

  void _startEmotionDetectionTimer() {
    _timer = Timer(Duration(seconds: _detectionDuration), () {
      _stopEmotionDetection();
    });
  }

  void _stopEmotionDetection() {
    _cameraController?.stopImageStream();
    _navigateToEmotionResult();
  }

  void _navigateToEmotionResult() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmotionResultScreen(emotions: _emotions),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Detection'),
      ),
      body: Stack(
        children: [
          _cameraController == null
              ? const Center(child: CircularProgressIndicator())
              : CameraPreview(_cameraController!),
          _buildRecognitionWidget(),
        ],
      ),
    );
  }

  Widget _buildRecognitionWidget() {
    if (_recognizedEmotion == null) return Container();

    return Positioned(
      bottom: 20,
      left: 20,
      child: Text(
        "Detected Emotion: $_recognizedEmotion",
        style: const TextStyle(
          backgroundColor: Colors.red,
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
    );
  }
}

class EmotionResultScreen extends StatelessWidget {
  final List<String> emotions;

  const EmotionResultScreen({super.key, required this.emotions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Detected Emotions:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ...emotions.map((emotion) => Text(
              emotion,
              style: const TextStyle(fontSize: 18),
            )),
          ],
        ),
      ),
    );
  }
}
