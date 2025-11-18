import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image/image.dart' as img;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class RealTimeDetecion extends StatefulWidget {
  final CameraDescription camera;

  const RealTimeDetecion({super.key, required this.camera,});

  @override
  State<RealTimeDetecion> createState() => _RealTimeDetecionState();
}

class _RealTimeDetecionState extends State<RealTimeDetecion> {
  late CameraController _controller;
  late WebSocketChannel _channel;
  bool _isStreaming = false;
  String _prediction = '';
  String _lastValidPrediction = '';
  final FlutterTts _tts = FlutterTts(); // Initialize TTS

  void _speakPrediction() async {
    await _tts.setLanguage('en-US');
    await _tts.setPitch(1.0);
    await _tts.speak(_lastValidPrediction);
  }


  void _initializeWebSocket() {
    _channel = IOWebSocketChannel.connect('ws://192.168.0.107:8000/ws/video');
  }

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      startStreaming(); // Start streaming automatically after camera initialization
    });

    _channel.stream.listen((dynamic data) {
      String prediction = data.toString();
      if (prediction != 'N/A') {
        setState(() {
          _prediction = prediction;
          _lastValidPrediction = prediction;
          print('Received prediction: $_prediction');
          _speakPrediction();// Print prediction to console
        });
      } else {
        print('Received invalid prediction: N/A');
      }
    }, onError: (error) {
      print('WebSocket error: $error');
    });
  }

  void startStreaming() {
    if (_controller.value.isInitialized && !_isStreaming) {
      setState(() {
        _isStreaming = true;
      });
      _controller.startImageStream((CameraImage image) {
        if (!_isStreaming) return;

        Uint8List bytes = _convertImageToBytes(image);
        print('Sending frame of length: ${bytes.length}'); // Log sent data length
        _channel.sink.add(bytes); // Send bytes to WebSocket server
      });
    }
  }

  void stopStreaming() {
    setState(() {
      _isStreaming = false;
    });
    _controller.stopImageStream();
    _channel.sink.close();
  }

  Uint8List _convertImageToBytes(CameraImage image) {
    final int width = image.width;
    final int height = image.height;

    final Uint8List y = image.planes[0].bytes;
    final Uint8List u = image.planes[1].bytes;
    final Uint8List v = image.planes[2].bytes;

    // Convert YUV to RGB
    img.Image? rgbImage = img.Image(width: width, height: height);

    if (rgbImage.data == null) {
      return Uint8List(0);
    }

    Uint32List rgbBuffer = rgbImage.data!.buffer.asUint32List();

    for (int yIndex = 0; yIndex < height; yIndex++) {
      for (int xIndex = 0; xIndex < width; xIndex++) {
        int uvOffset = (yIndex ~/ 2 * image.planes[1].bytesPerRow) + (xIndex ~/ 2) * image.planes[1].bytesPerPixel!;
        double r = y[yIndex * width + xIndex] + 1.402 * (v[uvOffset] - 128);
        double g = y[yIndex * width + xIndex] - 0.344 * (u[uvOffset] - 128) - 0.714 * (v[uvOffset] - 128);
        double b = y[yIndex * width + xIndex] + 1.772 * (u[uvOffset] - 128);

        int index = yIndex * width + xIndex;
        if (index < rgbBuffer.length) {
          rgbBuffer[index] = ((r.clamp(0, 255)).toInt() << 16) | ((g.clamp(0, 255)).toInt() << 8) | (b.clamp(0, 255)).toInt();
        }
      }
    }

    // Encode RGB image to JPEG
    Uint8List jpegBytes = img.encodeJpg(rgbImage);

    return jpegBytes;
  }


  @override
  void dispose() {
    _controller.dispose();
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading Camera...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Realtime Detection'),
        centerTitle: true,),
      body:Stack(
        children: <Widget>[
          if (_controller.value.isInitialized)
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: CameraPreview(_controller),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))
              ),
              padding: const EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width*.9,
              child: Text(
                'Prediction: $_lastValidPrediction',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
