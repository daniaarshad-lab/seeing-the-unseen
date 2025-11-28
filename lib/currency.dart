// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:tflite_v2/tflite_v2.dart';
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   CameraController? cameraController;
//   List? recognitions;
//   bool isDetecting = false;
//
//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//     initializeCamera();
//   }
//
//   @override
//   void dispose() {
//     cameraController?.dispose();
//     Tflite.close();
//     super.dispose();
//   }
//
//   Future<void> loadModel() async {
//     String? res = await Tflite.loadModel(
//       model: 'assets/model.tflite',
//       labels: 'assets/labels.txt',
//     );
//     print("Model loaded: $res");
//   }
//
//   void initializeCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;
//
//     cameraController = CameraController(firstCamera, ResolutionPreset.medium);
//     await cameraController!.initialize();
//
//     cameraController!.startImageStream((CameraImage image) {
//       if (!isDetecting) {
//         isDetecting = true;
//
//         Tflite.runModelOnFrame(
//           bytesList: image.planes.map((plane) => plane.bytes).toList(),
//           imageHeight: image.height,
//           imageWidth: image.width,
//           imageMean: 127.5,
//           imageStd: 127.5,
//           rotation: 90,
//           numResults: 2,
//           threshold: 0.5,
//         ).then((recognitions) {
//           setState(() {
//             this.recognitions = recognitions;
//           });
//           isDetecting = false;
//         });
//       }
//     });
//
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: cameraController == null
//           ? const Center(child: CircularProgressIndicator())
//           : Stack(
//         children: [
//           CameraPreview(cameraController!),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: recognitions?.map((res) {
//                 return Text(
//                   "${res["label"]} - ${(res["confidence"] * 100).toStringAsFixed(0)}%",
//                   style: const TextStyle(
//                     backgroundColor: Colors.black54,
//                     color: Colors.white,
//                     fontSize: 20,
//                   ),
//                 );
//               }).toList() ??
//                   [],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }



// ****WAHAJ WALA CODE BACKUP****

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController? cameraController;
  List? recognitions;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    loadModel();
    initializeCamera();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }

  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
    print("Model loaded: $res");
  }

  void initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    cameraController = CameraController(firstCamera, ResolutionPreset.medium);
    await cameraController!.initialize();

    cameraController!.startImageStream((CameraImage image) {
      if (!isDetecting) {
        isDetecting = true;

        Tflite.runModelOnFrame(
          bytesList: image.planes.map((plane) => plane.bytes).toList(),
          imageHeight: image.height,
          imageWidth: image.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.5,
        ).then((recognitions) {
          setState(() {
            this.recognitions = recognitions;
          });
          isDetecting = false;
        });
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cameraController == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          CameraPreview(cameraController!),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recognitions?.map((res) {
                return Text(
                  "${res["label"]} - ${(res["confidence"] * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(
                    backgroundColor: Colors.black54,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                );
              }).toList() ??
                  [],
            ),
          )
        ],
      ),
    );
  }
}


