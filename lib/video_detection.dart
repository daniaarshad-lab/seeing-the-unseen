import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoDetection extends StatefulWidget {
  const VideoDetection({super.key});

  @override
  State<VideoDetection> createState() => _VideoDetectionState();
}

class _VideoDetectionState extends State<VideoDetection> {
  VideoPlayerController? _controller;
  final ImagePicker _picker = ImagePicker();
  String? _prediction;
  bool _isLoading = false;
  final FlutterTts _tts = FlutterTts();


  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    setState(() {
      _isLoading = true; // Set the loading flag to true
    });
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      var request = http.MultipartRequest('POST',
          Uri.parse(' 192.168.0.107:8000/predict_video/'));
      request.files
          .add(await http.MultipartFile.fromPath('file', pickedFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.toBytes();
        var responseJson = jsonDecode(utf8.decode(responseBody));
        var prediction = responseJson['prediction'];
        setState(() async{
          _prediction = prediction;
          _isLoading = false;
          await _tts.setLanguage('en-US');
          await _tts.setPitch(1.0);
          await _tts.speak(_prediction!);// Set the loading flag to false
        });
      } else {
        setState(() {
          _isLoading = false; // Set the loading flag to false
        });
        print('Failed to receive prediction: ${response.statusCode}');
      }

      _controller = VideoPlayerController.file(File(pickedFile.path))
        ..initialize().then((_) {
          setState(() {});
          _controller?.play();
        });
    } else {
      setState(() {
        _isLoading = false; // Set the loading flag to false if no file is picked
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Detection'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Processing video, please wait'),
          ],
        ),
      )
          : Column(
        children: [
          _controller != null && _controller!.value.isInitialized
              ? Center(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(
                            width: _controller!.value.size.width ?? 0,
                            height: _controller!.value.size.height ?? 0,
                            child: VideoPlayer(_controller!),
                          ),
                        ),
                        VideoProgressIndicator(_controller!, allowScrubbing: true),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _controller!.value.isPlaying
                                      ? _controller!.pause()
                                      : _controller!.play();
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _pickVideo();
                        },
                        icon: const Icon(
                          Icons.upload,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Select a file',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_controller != null) {
                            _controller!.pause();
                            _controller!.dispose();
                            _controller = null;
                            setState(() {});
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(12.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text(
                            'Prediction',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          const Divider(
                            indent: 20,
                            endIndent: 20,
                          ),
                          _prediction != null
                              ? Text(
                            _prediction!,
                            style:
                            const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          )
                              : const Text('Processing, please wait'),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
              : Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .9,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius:
                const BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please select a video file from device',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _pickVideo();
                    },
                    icon: const Icon(
                      Icons.upload,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Select a file',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
