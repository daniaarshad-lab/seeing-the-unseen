// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;
// // import 'package:realtime_face_recognition_2026/Util.dart';
// import 'package:objectde/Util.dart';
//
// import '../ML/Recognition.dart';
// import '../ML/Recognizer.dart';
//
// // import '../main.dart';
// import 'package:objectde/person_detection.dart';
//
// class RecognitionScreen extends StatefulWidget {
//   const RecognitionScreen({super.key});
//
//   @override
//   State<RecognitionScreen> createState() => _RecognitionScreenState();
// }
//
// class _RecognitionScreenState extends State<RecognitionScreen> {
//   dynamic controller;
//   bool isBusy = false;
//   late Size size;
//   late CameraDescription description = cameras[1];
//   CameraLensDirection camDirec = CameraLensDirection.front;
//   late List<Recognition> recognitions = [];
//
//   //TODO declare face detector
//   late FaceDetector faceDetector;
//   //TODO declare face recognizer
//   late Recognizer recognizer;
//   @override
//   void initState() {
//     super.initState();
//
//     //TODO initialize face detector
//     var options = FaceDetectorOptions(performanceMode: FaceDetectorMode.fast);
//     faceDetector = FaceDetector(options: options);
//
//     //TODO initialize face recognizer
//     recognizer = Recognizer();
//
//     //TODO initialize camera footage
//     initializeCamera();
//   }
//
//   //TODO code to initialize the camera feed
//   initializeCamera() async {
//     controller = CameraController(
//       description,
//       ResolutionPreset.medium,
//       imageFormatGroup:
//           Platform.isAndroid
//               ? ImageFormatGroup
//                   .nv21 // for Android
//               : ImageFormatGroup.bgra8888,
//       enableAudio: false,
//     ); // for iOS);
//     await controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {
//         controller;
//       });
//       controller.startImageStream(
//         (image) => {
//           if (!isBusy) {isBusy = true, frame = image, doFaceDetectionOnFrame()},
//         },
//       );
//     });
//   }
//
//   //TODO close all resources
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
//
//   //TODO face detection on a frame
//   dynamic _scanResults;
//   CameraImage? frame;
//   doFaceDetectionOnFrame() async {
//     //TODO convert frame into InputImage format
//     InputImage? inputImage = getInputImage();
//     if (inputImage == null) {
//       setState(() {
//         isBusy = false;
//       });
//       return;
//     }
//
//     //TODO pass InputImage to face detection model and detect faces
//     List<Face> faces = await faceDetector.processImage(inputImage);
//
//     //TODO perform face recognition on detected faces
//     performFaceRecognition(faces);
//     // setState(() {
//     //   _scanResults = faces;
//     //   isBusy = false;
//     // });
//   }
//
//   img.Image? image;
//   bool register = false;
//   //TODO perform Face Recognition
//   performFaceRecognition(List<Face> faces) async {
//     recognitions.clear();
//
//     //TODO convert CameraImage to Image and rotate it so that our frame will be in a portrait
//     image =
//         Platform.isIOS
//             ? Util.convertBGRA8888ToImage(frame!)
//             : Util.convertNV21(frame!);
//     image = img.copyRotate(
//       image!,
//       angle: camDirec == CameraLensDirection.front ? 270 : 90,
//     );
//
//     for (Face face in faces) {
//       Rect faceRect = face.boundingBox;
//       //TODO crop face
//       img.Image croppedFace = img.copyCrop(
//         image!,
//         x: faceRect.left.toInt(),
//         y: faceRect.top.toInt(),
//         width: faceRect.width.toInt(),
//         height: faceRect.height.toInt(),
//       );
//
//       //TODO pass cropped face to face recognition model
//       Recognition recognition = await recognizer.recognize(
//         croppedFace,
//         faceRect,
//       );
//       if(recognition.distance<0.3 ) {
//         recognition.name = "Unknown";
//       }
//       recognitions.add(recognition);
//     }
//
//     setState(() {
//       isBusy = false;
//       _scanResults = recognitions;
//     });
//   }
//
//   // //TODO convert CameraImage to InputImage
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };
//   InputImage? getInputImage() {
//     final camera =
//         camDirec == CameraLensDirection.front ? cameras[1] : cameras[0];
//     final sensorOrientation = camera.sensorOrientation;
//
//     InputImageRotation? rotation;
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       var rotationCompensation =
//           _orientations[controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//       if (camera.lensDirection == CameraLensDirection.front) {
//         // front-facing
//         rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
//       } else {
//         // back-facing
//         rotationCompensation =
//             (sensorOrientation - rotationCompensation + 360) % 360;
//       }
//       rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
//     }
//     if (rotation == null) return null;
//
//     final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888))
//       return null;
//
//     if (frame!.planes.length != 1) return null;
//     final plane = frame!.planes.first;
//
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: plane.bytesPerRow,
//       ),
//     );
//   }
//
//   // TODO Show rectangles around detected faces
//   Widget buildResult() {
//     if (_scanResults == null ||
//         controller == null ||
//         !controller.value.isInitialized) {
//       return const Center(child: Text('Camera is not initialized'));
//     }
//     final Size imageSize = Size(
//       controller.value.previewSize!.height,
//       controller.value.previewSize!.width,
//     );
//     CustomPainter painter = FaceDetectorPainter(
//       imageSize,
//       _scanResults,
//       camDirec,
//     );
//     return CustomPaint(painter: painter);
//   }
//
//   //TODO toggle camera direction
//   void _toggleCameraDirection() async {
//     if (camDirec == CameraLensDirection.back) {
//       camDirec = CameraLensDirection.front;
//       description = cameras[1];
//     } else {
//       camDirec = CameraLensDirection.back;
//       description = cameras[0];
//     }
//     await controller.stopImageStream();
//     setState(() {
//       controller;
//     });
//     initializeCamera();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> stackChildren = [];
//     size = MediaQuery.of(context).size;
//     if (controller != null) {
//       //TODO View for displaying the live camera footage
//       stackChildren.add(
//         Positioned(
//           top: 0.0,
//           left: 0.0,
//           width: size.width,
//           height: size.height,
//           child: Container(
//             child:
//                 (controller.value.isInitialized)
//                     ? AspectRatio(
//                       aspectRatio: controller.value.aspectRatio,
//                       child: CameraPreview(controller),
//                     )
//                     : Container(),
//           ),
//         ),
//       );
//
//       //TODO View for displaying rectangles around detected aces
//       stackChildren.add(
//         Positioned(
//           top: 0.0,
//           left: 0.0,
//           width: size.width,
//           height: size.height,
//           child: buildResult(),
//         ),
//       );
//     }
//
//     //TODO View for displaying the bar to switch camera direction or for registering faces
//     stackChildren.add(
//       Positioned(
//         bottom: 40,
//         left: 20,
//         right: 20,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.deepPurple.withAlpha(80),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.white.withOpacity(0.2)),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 300),
//                     child: IconButton(
//                       icon: Icon(Icons.cached, color: Colors.white),
//                       iconSize: 40,
//                       color: Colors.black,
//                       onPressed: () {
//                         _toggleCameraDirection();
//                       },
//                     ),
//                   ),
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Container(
//           margin: const EdgeInsets.only(top: 0),
//           color: Colors.black,
//           child: Stack(children: stackChildren),
//         ),
//       ),
//     );
//   }
// }
//
// class FaceDetectorPainter extends CustomPainter {
//   final Size absoluteImageSize;
//   final List<Recognition> faces;
//   final CameraLensDirection camDirection;
//
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDirection);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double scaleX = size.width / absoluteImageSize.width;
//     final double scaleY = size.height / absoluteImageSize.height;
//
//     final Paint boxPaint =
//         Paint()
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 2.5
//           ..color = Colors.deepPurple.shade300;
//
//     final Paint labelBgPaint =
//         Paint()
//           ..style = PaintingStyle.fill
//           ..color = Colors.deepPurple.shade300.withAlpha(150);
//
//     for (final face in faces) {
//       final double left =
//           camDirection == CameraLensDirection.front
//               ? (absoluteImageSize.width - face.location.right) * scaleX
//               : face.location.left * scaleX;
//       final double top = face.location.top * scaleY;
//       final double right =
//           camDirection == CameraLensDirection.front
//               ? (absoluteImageSize.width - face.location.left) * scaleX
//               : face.location.right * scaleX;
//       final double bottom = face.location.bottom * scaleY;
//
//       final rect = Rect.fromLTRB(left, top, right, bottom);
//       final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
//       canvas.drawRRect(rRect, boxPaint);
//
//       // Draw name label
//       final String label =
//           face.name.isNotEmpty
//               ? '${face.name} (${face.distance.toStringAsFixed(2)})'
//               : 'Unknown';
//
//       final textSpan = TextSpan(
//         text: label,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       );
//
//       final textPainter = TextPainter(
//         text: textSpan,
//         textDirection: TextDirection.ltr,
//       )..layout(maxWidth: size.width * 0.6);
//
//       final double labelPadding = 6;
//       final double labelX = left;
//       final double labelY = top - textPainter.height - 8;
//
//       final backgroundRect = Rect.fromLTWH(
//         labelX,
//         labelY < 0 ? top + 4 : labelY,
//         textPainter.width + labelPadding * 2,
//         textPainter.height + labelPadding,
//       );
//
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(backgroundRect, const Radius.circular(8)),
//         labelBgPaint,
//       );
//
//       textPainter.paint(
//         canvas,
//         Offset(
//           backgroundRect.left + labelPadding,
//           backgroundRect.top + labelPadding / 2,
//         ),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) => true;
// }


// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;
// import 'package:objectde/Util.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import '../ML/Recognition.dart';
// import '../ML/Recognizer.dart';
// import 'package:objectde/person_detection.dart';
//
// class RecognitionScreen extends StatefulWidget {
//   const RecognitionScreen({super.key});
//
//   @override
//   State<RecognitionScreen> createState() => _RecognitionScreenState();
// }
//
// class _RecognitionScreenState extends State<RecognitionScreen> {
//   CameraController? controller;
//   bool isBusy = false;
//   late Size size;
//   late CameraDescription description;
//   CameraLensDirection camDirec = CameraLensDirection.front;
//   late List<Recognition> recognitions = [];
//
//   late FaceDetector faceDetector;
//   late Recognizer recognizer;
//
//   CameraImage? frame;
//   dynamic _scanResults;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Face Detector
//     var options = FaceDetectorOptions(performanceMode: FaceDetectorMode.fast);
//     faceDetector = FaceDetector(options: options);
//
//     // Face Recognizer
//     recognizer = Recognizer();
//
//     // Initialize camera
//     _initializeCamera();
//   }
//
//   /// Initialize camera (front by default, like your other code)
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//
//     // Pick camera based on camDirec (front/back)
//     description = cameras.firstWhere(
//           (camera) => camera.lensDirection == camDirec,
//       orElse: () => cameras.first,
//     );
//
//     controller = CameraController(
//       description,
//       ResolutionPreset.medium,
//       imageFormatGroup: Platform.isAndroid
//           ? ImageFormatGroup.nv21
//           : ImageFormatGroup.bgra8888,
//       enableAudio: false,
//     );
//
//     await controller!.initialize();
//
//     controller!.startImageStream((CameraImage image) {
//       if (!isBusy) {
//         isBusy = true;
//         frame = image;
//         doFaceDetectionOnFrame();
//       }
//     });
//
//     setState(() {});
//   }
//
//   /// Toggle between front & back camera
//   Future<void> _toggleCameraDirection() async {
//     camDirec = (camDirec == CameraLensDirection.back)
//         ? CameraLensDirection.front
//         : CameraLensDirection.back;
//
//     await controller?.stopImageStream();
//     await controller?.dispose();
//
//     await _initializeCamera();
//   }
//
//   /// Close resources
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
//
//   /// Face detection on a frame
//   Future<void> doFaceDetectionOnFrame() async {
//     InputImage? inputImage = getInputImage();
//     if (inputImage == null) {
//       setState(() {
//         isBusy = false;
//       });
//       return;
//     }
//
//     List<Face> faces = await faceDetector.processImage(inputImage);
//     performFaceRecognition(faces);
//   }
//
//   img.Image? image;
//   bool register = false;
//
//   /// Perform face recognition
//   performFaceRecognition(List<Face> faces) async {
//     recognitions.clear();
//
//     // Convert CameraImage to usable img.Image
//     image = Platform.isIOS
//         ? Util.convertBGRA8888ToImage(frame!)
//         : Util.convertNV21(frame!);
//
//     // Rotate for portrait
//     image = img.copyRotate(
//       image!,
//       angle: camDirec == CameraLensDirection.front ? 270 : 90,
//     );
//
//     for (Face face in faces) {
//       Rect faceRect = face.boundingBox;
//
//       // Crop face
//       img.Image croppedFace = img.copyCrop(
//         image!,
//         x: faceRect.left.toInt(),
//         y: faceRect.top.toInt(),
//         width: faceRect.width.toInt(),
//         height: faceRect.height.toInt(),
//       );
//
//       // Recognize face
//       Recognition recognition = await recognizer.recognize(
//         croppedFace,
//         faceRect,
//       );
//
//       if (recognition.distance < 0.3) {
//         recognition.name = "Unknown";
//       }
//       recognitions.add(recognition);
//     }
//
//     setState(() {
//       isBusy = false;
//       _scanResults = recognitions;
//     });
//   }
//
//   /// Orientation handling for InputImage
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };
//
//   InputImage? getInputImage() {
//     final sensorOrientation = description.sensorOrientation;
//
//     InputImageRotation? rotation;
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       var rotationCompensation =
//       _orientations[controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//
//       if (description.lensDirection == CameraLensDirection.front) {
//         rotation = InputImageRotationValue.fromRawValue(
//             (sensorOrientation + rotationCompensation) % 360);
//       } else {
//         rotation = InputImageRotationValue.fromRawValue(
//             (sensorOrientation - rotationCompensation + 360) % 360);
//       }
//     }
//     if (rotation == null) return null;
//
//     final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) {
//       return null;
//     }
//
//     if (frame!.planes.length != 1) return null;
//     final plane = frame!.planes.first;
//
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: plane.bytesPerRow,
//       ),
//     );
//   }
//
//   /// Painter for face boxes
//   Widget buildResult() {
//     if (_scanResults == null ||
//         controller == null ||
//         !controller!.value.isInitialized) {
//       return const Center(child: Text('Camera is not initialized'));
//     }
//
//     final Size imageSize = Size(
//       controller!.value.previewSize!.height,
//       controller!.value.previewSize!.width,
//     );
//
//     CustomPainter painter =
//     FaceDetectorPainter(imageSize, _scanResults, camDirec);
//
//     return CustomPaint(painter: painter);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> stackChildren = [];
//     size = MediaQuery.of(context).size;
//
//     if (controller != null) {
//       stackChildren.add(
//         Positioned.fill(
//           child: (controller!.value.isInitialized)
//               ? CameraPreview(controller!)
//               : Container(),
//         ),
//       );
//
//       stackChildren.add(
//         Positioned.fill(child: buildResult()),
//       );
//     }
//
//     stackChildren.add(
//       Positioned(
//         bottom: 40,
//         left: 20,
//         right: 20,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.deepPurple.withAlpha(80),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.white.withOpacity(0.2)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.cached, color: Colors.white),
//                     iconSize: 40,
//                     onPressed: _toggleCameraDirection,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Stack(children: stackChildren),
//       ),
//     );
//   }
// }
//
// class FaceDetectorPainter extends CustomPainter {
//   final Size absoluteImageSize;
//   final List<Recognition> faces;
//   final CameraLensDirection camDirection;
//
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDirection);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double scaleX = size.width / absoluteImageSize.width;
//     final double scaleY = size.height / absoluteImageSize.height;
//
//     final Paint boxPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.5
//       ..color = Colors.deepPurple.shade300;
//
//     final Paint labelBgPaint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.deepPurple.shade300.withAlpha(150);
//
//     for (final face in faces) {
//       final double left = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.right) * scaleX
//           : face.location.left * scaleX;
//       final double top = face.location.top * scaleY;
//       final double right = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.left) * scaleX
//           : face.location.right * scaleX;
//       final double bottom = face.location.bottom * scaleY;
//
//       final rect = Rect.fromLTRB(left, top, right, bottom);
//       final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
//       canvas.drawRRect(rRect, boxPaint);
//
//       final String label = face.name.isNotEmpty
//           ? '${face.name} (${face.distance.toStringAsFixed(2)})'
//           : 'Unknown';
//
//       final textSpan = TextSpan(
//         text: label,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       );
//
//       final textPainter =
//       TextPainter(text: textSpan, textDirection: TextDirection.ltr)
//         ..layout(maxWidth: size.width * 0.6);
//
//       final double labelPadding = 6;
//       final double labelX = left;
//       final double labelY = top - textPainter.height - 8;
//
//       final backgroundRect = Rect.fromLTWH(
//         labelX,
//         labelY < 0 ? top + 4 : labelY,
//         textPainter.width + labelPadding * 2,
//         textPainter.height + labelPadding,
//       );
//
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(backgroundRect, const Radius.circular(8)),
//         labelBgPaint,
//       );
//
//       textPainter.paint(
//         canvas,
//         Offset(
//           backgroundRect.left + labelPadding,
//           backgroundRect.top + labelPadding / 2,
//         ),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) => true;
// }










// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;
// import 'package:objectde/Util.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import '../ML/Recognition.dart';
// import '../ML/Recognizer.dart';
// import 'package:objectde/person_detection.dart';
//
// class RecognitionScreen extends StatefulWidget {
//   const RecognitionScreen({super.key});
//
//   @override
//   State<RecognitionScreen> createState() => _RecognitionScreenState();
// }
//
// class _RecognitionScreenState extends State<RecognitionScreen> {
//   CameraController? controller;
//   bool isBusy = false;
//   late Size size;
//   late CameraDescription description;
//   CameraLensDirection camDirec = CameraLensDirection.front;
//   late List<Recognition> recognitions = [];
//
//   late FaceDetector faceDetector;
//   late Recognizer recognizer;
//   CameraImage? frame;
//   dynamic _scanResults;
//
//   final FlutterTts flutterTts = FlutterTts();
//   final Set<String> _spokenNames = {}; // keep track of already spoken names
//
//   @override
//   void initState() {
//     super.initState();
//
//     var options = FaceDetectorOptions(performanceMode: FaceDetectorMode.fast);
//     faceDetector = FaceDetector(options: options);
//
//     recognizer = Recognizer();
//
//     _initializeCamera();
//
//     flutterTts.setLanguage("en-US");
//     flutterTts.setPitch(1.0);
//     flutterTts.setSpeechRate(0.5);
//   }
//
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//
//     description = cameras.firstWhere(
//           (camera) => camera.lensDirection == camDirec,
//       orElse: () => cameras.first,
//     );
//
//     controller = CameraController(
//       description,
//       ResolutionPreset.medium,
//       imageFormatGroup: Platform.isAndroid
//           ? ImageFormatGroup.nv21
//           : ImageFormatGroup.bgra8888,
//       enableAudio: false,
//     );
//
//     await controller!.initialize();
//
//     controller!.startImageStream((CameraImage image) {
//       if (!isBusy) {
//         isBusy = true;
//         frame = image;
//         doFaceDetectionOnFrame();
//       }
//     });
//
//     setState(() {});
//   }
//
//   Future<void> _toggleCameraDirection() async {
//     camDirec = (camDirec == CameraLensDirection.back)
//         ? CameraLensDirection.front
//         : CameraLensDirection.back;
//
//     await controller?.stopImageStream();
//     await controller?.dispose();
//
//     await _initializeCamera();
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> doFaceDetectionOnFrame() async {
//     InputImage? inputImage = getInputImage();
//     if (inputImage == null) {
//       setState(() {
//         isBusy = false;
//       });
//       return;
//     }
//
//     List<Face> faces = await faceDetector.processImage(inputImage);
//     performFaceRecognition(faces);
//   }
//
//   img.Image? image;
//   bool register = false;
//
//   performFaceRecognition(List<Face> faces) async {
//     recognitions.clear();
//
//     image = Platform.isIOS
//         ? Util.convertBGRA8888ToImage(frame!)
//         : Util.convertNV21(frame!);
//
//     image = img.copyRotate(
//       image!,
//       angle: camDirec == CameraLensDirection.front ? 270 : 90,
//     );
//
//     for (Face face in faces) {
//       Rect faceRect = face.boundingBox;
//
//       img.Image croppedFace = img.copyCrop(
//         image!,
//         x: faceRect.left.toInt(),
//         y: faceRect.top.toInt(),
//         width: faceRect.width.toInt(),
//         height: faceRect.height.toInt(),
//       );
//
//       Recognition recognition = await recognizer.recognize(
//         croppedFace,
//         faceRect,
//       );
//
//       if (recognition.distance < 0.3) {
//         recognition.name = "Unknown";
//       }
//
//       recognitions.add(recognition);
//
//       // 🔊 Speak name only once
//       if (recognition.name.isNotEmpty &&
//           !_spokenNames.contains(recognition.name)) {
//         _spokenNames.add(recognition.name);
//         await flutterTts.speak(recognition.name);
//       }
//     }
//
//     setState(() {
//       isBusy = false;
//       _scanResults = recognitions;
//     });
//   }
//
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };
//
//   InputImage? getInputImage() {
//     final sensorOrientation = description.sensorOrientation;
//
//     InputImageRotation? rotation;
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       var rotationCompensation =
//       _orientations[controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//
//       if (description.lensDirection == CameraLensDirection.front) {
//         rotation = InputImageRotationValue.fromRawValue(
//             (sensorOrientation + rotationCompensation) % 360);
//       } else {
//         rotation = InputImageRotationValue.fromRawValue(
//             (sensorOrientation - rotationCompensation + 360) % 360);
//       }
//     }
//     if (rotation == null) return null;
//
//     final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) {
//       return null;
//     }
//
//     if (frame!.planes.length != 1) return null;
//     final plane = frame!.planes.first;
//
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: plane.bytesPerRow,
//       ),
//     );
//   }
//
//   Widget buildResult() {
//     if (_scanResults == null ||
//         controller == null ||
//         !controller!.value.isInitialized) {
//       return const Center(child: Text('Camera is not initialized'));
//     }
//
//     final Size imageSize = Size(
//       controller!.value.previewSize!.height,
//       controller!.value.previewSize!.width,
//     );
//
//     CustomPainter painter =
//     FaceDetectorPainter(imageSize, _scanResults, camDirec);
//
//     return CustomPaint(painter: painter);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> stackChildren = [];
//     size = MediaQuery.of(context).size;
//
//     if (controller != null) {
//       stackChildren.add(
//         Positioned.fill(
//           child: (controller!.value.isInitialized)
//               ? CameraPreview(controller!)
//               : Container(),
//         ),
//       );
//
//       stackChildren.add(
//         Positioned.fill(child: buildResult()),
//       );
//     }
//
//     stackChildren.add(
//       Positioned(
//         bottom: 40,
//         left: 20,
//         right: 20,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.deepPurple.withAlpha(80),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.white.withOpacity(0.2)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.cached, color: Colors.white),
//                     iconSize: 40,
//                     onPressed: _toggleCameraDirection,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Stack(children: stackChildren),
//       ),
//     );
//   }
// }
//
// class FaceDetectorPainter extends CustomPainter {
//   final Size absoluteImageSize;
//   final List<Recognition> faces;
//   final CameraLensDirection camDirection;
//
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDirection);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double scaleX = size.width / absoluteImageSize.width;
//     final double scaleY = size.height / absoluteImageSize.height;
//
//     final Paint boxPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.5
//       ..color = Colors.deepPurple.shade300;
//
//     final Paint labelBgPaint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.deepPurple.shade300.withAlpha(150);
//
//     for (final face in faces) {
//       final double left = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.right) * scaleX
//           : face.location.left * scaleX;
//       final double top = face.location.top * scaleY;
//       final double right = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.left) * scaleX
//           : face.location.right * scaleX;
//       final double bottom = face.location.bottom * scaleY;
//
//       final rect = Rect.fromLTRB(left, top, right, bottom);
//       final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
//       canvas.drawRRect(rRect, boxPaint);
//
//       final String label = face.name.isNotEmpty
//           ? '${face.name} (${face.distance.toStringAsFixed(2)})'
//           : 'Unknown';
//
//       final textSpan = TextSpan(
//         text: label,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       );
//
//       final textPainter =
//       TextPainter(text: textSpan, textDirection: TextDirection.ltr)
//         ..layout(maxWidth: size.width * 0.6);
//
//       final double labelPadding = 6;
//       final double labelX = left;
//       final double labelY = top - textPainter.height - 8;
//
//       final backgroundRect = Rect.fromLTWH(
//         labelX,
//         labelY < 0 ? top + 4 : labelY,
//         textPainter.width + labelPadding * 2,
//         textPainter.height + labelPadding,
//       );
//
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(backgroundRect, const Radius.circular(8)),
//         labelBgPaint,
//       );
//
//       textPainter.paint(
//         canvas,
//         Offset(
//           backgroundRect.left + labelPadding,
//           backgroundRect.top + labelPadding / 2,
//         ),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) => true;
// }





// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;
// import 'package:objectde/Util.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import '../ML/Recognition.dart';
// import '../ML/Recognizer.dart';
// import 'package:objectde/person_detection.dart';
//
// class RecognitionScreen extends StatefulWidget {
//   const RecognitionScreen({super.key});
//
//   @override
//   State<RecognitionScreen> createState() => _RecognitionScreenState();
// }
//
// class _RecognitionScreenState extends State<RecognitionScreen> {
//   CameraController? controller;
//   bool isBusy = false;
//   late Size size;
//   late CameraDescription description;
//   CameraLensDirection camDirec = CameraLensDirection.front;
//   late List<Recognition> recognitions = [];
//
//   late FaceDetector faceDetector;
//   late Recognizer recognizer;
//   CameraImage? frame;
//   dynamic _scanResults;
//
//   final FlutterTts flutterTts = FlutterTts();
//   Set<String> _spokenNames = {}; // names already spoken
//
//   @override
//   void initState() {
//     super.initState();
//
//     var options = FaceDetectorOptions(performanceMode: FaceDetectorMode.fast);
//     faceDetector = FaceDetector(options: options);
//
//     recognizer = Recognizer();
//
//     _initializeCamera();
//
//     flutterTts.setLanguage("en-US");
//     flutterTts.setPitch(1.0);
//     flutterTts.setSpeechRate(0.5);
//   }
//
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//
//     description = cameras.firstWhere(
//           (camera) => camera.lensDirection == camDirec,
//       orElse: () => cameras.first,
//     );
//
//     controller = CameraController(
//       description,
//       ResolutionPreset.medium,
//       imageFormatGroup: Platform.isAndroid
//           ? ImageFormatGroup.nv21
//           : ImageFormatGroup.bgra8888,
//       enableAudio: false,
//     );
//
//     await controller!.initialize();
//
//     controller!.startImageStream((CameraImage image) {
//       if (!isBusy) {
//         isBusy = true;
//         frame = image;
//         doFaceDetectionOnFrame();
//       }
//     });
//
//     setState(() {});
//   }
//
//   /// Flip camera
//   Future<void> _toggleCameraDirection() async {
//     camDirec = (camDirec == CameraLensDirection.back)
//         ? CameraLensDirection.front
//         : CameraLensDirection.back;
//
//     await controller?.stopImageStream();
//     await controller?.dispose();
//
//     _spokenNames.clear(); // reset spoken names when camera flips
//
//     await _initializeCamera();
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> doFaceDetectionOnFrame() async {
//     InputImage? inputImage = getInputImage();
//     if (inputImage == null) {
//       setState(() {
//         isBusy = false;
//       });
//       return;
//     }
//
//     List<Face> faces = await faceDetector.processImage(inputImage);
//
//     if (faces.isEmpty) {
//       _spokenNames.clear(); // reset if no faces in view
//     }
//
//     performFaceRecognition(faces);
//   }
//
//   img.Image? image;
//   bool register = false;
//
//   performFaceRecognition(List<Face> faces) async {
//     recognitions.clear();
//
//     image = Platform.isIOS
//         ? Util.convertBGRA8888ToImage(frame!)
//         : Util.convertNV21(frame!);
//
//     image = img.copyRotate(
//       image!,
//       angle: camDirec == CameraLensDirection.front ? 270 : 90,
//     );
//
//     for (Face face in faces) {
//       Rect faceRect = face.boundingBox;
//
//       img.Image croppedFace = img.copyCrop(
//         image!,
//         x: faceRect.left.toInt(),
//         y: faceRect.top.toInt(),
//         width: faceRect.width.toInt(),
//         height: faceRect.height.toInt(),
//       );
//
//       Recognition recognition = await recognizer.recognize(
//         croppedFace,
//         faceRect,
//       );
//
//       if (recognition.distance < 0.3) {
//         recognition.name = "Unknown";
//       }
//
//       recognitions.add(recognition);
//
//       // Speak name once while face is in view
//       if (recognition.name.isNotEmpty &&
//           !_spokenNames.contains(recognition.name)) {
//         _spokenNames.add(recognition.name);
//         await flutterTts.speak(recognition.name);
//       }
//     }
//
//     setState(() {
//       isBusy = false;
//       _scanResults = recognitions;
//     });
//   }
//
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };
//
//   InputImage? getInputImage() {
//     final sensorOrientation = description.sensorOrientation;
//
//     InputImageRotation? rotation;
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       var rotationCompensation =
//       _orientations[controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//
//       if (description.lensDirection == CameraLensDirection.front) {
//         rotation = InputImageRotationValue.fromRawValue(
//             (sensorOrientation + rotationCompensation) % 360);
//       } else {
//         rotation = InputImageRotationValue.fromRawValue(
//             (sensorOrientation - rotationCompensation + 360) % 360);
//       }
//     }
//     if (rotation == null) return null;
//
//     final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) {
//       return null;
//     }
//
//     if (frame!.planes.length != 1) return null;
//     final plane = frame!.planes.first;
//
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: plane.bytesPerRow,
//       ),
//     );
//   }
//
//   Widget buildResult() {
//     if (_scanResults == null ||
//         controller == null ||
//         !controller!.value.isInitialized) {
//       return const Center(child: Text('Camera is not initialized'));
//     }
//
//     final Size imageSize = Size(
//       controller!.value.previewSize!.height,
//       controller!.value.previewSize!.width,
//     );
//
//     CustomPainter painter =
//     FaceDetectorPainter(imageSize, _scanResults, camDirec);
//
//     return CustomPaint(painter: painter);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> stackChildren = [];
//     size = MediaQuery.of(context).size;
//
//     if (controller != null) {
//       stackChildren.add(
//         Positioned.fill(
//           child: (controller!.value.isInitialized)
//               ? CameraPreview(controller!)
//               : Container(),
//         ),
//       );
//
//       stackChildren.add(
//         Positioned.fill(child: buildResult()),
//       );
//     }
//
//     stackChildren.add(
//       Positioned(
//         bottom: 40,
//         left: 20,
//         right: 20,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.deepPurple.withAlpha(80),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.white.withOpacity(0.2)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.cached, color: Colors.white),
//                     iconSize: 40,
//                     onPressed: _toggleCameraDirection,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Stack(children: stackChildren),
//       ),
//     );
//   }
// }
//
// class FaceDetectorPainter extends CustomPainter {
//   final Size absoluteImageSize;
//   final List<Recognition> faces;
//   final CameraLensDirection camDirection;
//
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDirection);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double scaleX = size.width / absoluteImageSize.width;
//     final double scaleY = size.height / absoluteImageSize.height;
//
//     final Paint boxPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.5
//       ..color = Colors.deepPurple.shade300;
//
//     final Paint labelBgPaint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.deepPurple.shade300.withAlpha(150);
//
//     for (final face in faces) {
//       final double left = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.right) * scaleX
//           : face.location.left * scaleX;
//       final double top = face.location.top * scaleY;
//       final double right = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.left) * scaleX
//           : face.location.right * scaleX;
//       final double bottom = face.location.bottom * scaleY;
//
//       final rect = Rect.fromLTRB(left, top, right, bottom);
//       final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
//       canvas.drawRRect(rRect, boxPaint);
//
//       final String label = face.name.isNotEmpty
//           ? '${face.name} (${face.distance.toStringAsFixed(2)})'
//           : 'Unknown';
//
//       final textSpan = TextSpan(
//         text: label,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       );
//
//       final textPainter =
//       TextPainter(text: textSpan, textDirection: TextDirection.ltr)
//         ..layout(maxWidth: size.width * 0.6);
//
//       final double labelPadding = 6;
//       final double labelX = left;
//       final double labelY = top - textPainter.height - 8;
//
//       final backgroundRect = Rect.fromLTWH(
//         labelX,
//         labelY < 0 ? top + 4 : labelY,
//         textPainter.width + labelPadding * 2,
//         textPainter.height + labelPadding,
//       );
//
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(backgroundRect, const Radius.circular(8)),
//         labelBgPaint,
//       );
//
//       textPainter.paint(
//         canvas,
//         Offset(
//           backgroundRect.left + labelPadding,
//           backgroundRect.top + labelPadding / 2,
//         ),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) => true;
// }




// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;
// import 'package:objectde/Util.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import '../ML/Recognition.dart';
// import '../ML/Recognizer.dart';
// import 'package:objectde/person_detection.dart';
// import 'HomeScreen.dart'; // import your HomeScreen
//
// class RecognitionScreen extends StatefulWidget {
//   const RecognitionScreen({super.key});
//
//   @override
//   State<RecognitionScreen> createState() => _RecognitionScreenState();
// }
//
// class _RecognitionScreenState extends State<RecognitionScreen> {
//   CameraController? controller;
//   bool isBusy = false;
//   late Size size;
//   late CameraDescription description;
//   CameraLensDirection camDirec = CameraLensDirection.front;
//   late List<Recognition> recognitions = [];
//
//   late FaceDetector faceDetector;
//   late Recognizer recognizer;
//   CameraImage? frame;
//   dynamic _scanResults;
//
//   final FlutterTts flutterTts = FlutterTts();
//   Set<String> _spokenNames = {}; // names already spoken
//
//   @override
//   void initState() {
//     super.initState();
//
//     var options = FaceDetectorOptions(performanceMode: FaceDetectorMode.fast);
//     faceDetector = FaceDetector(options: options);
//
//     recognizer = Recognizer();
//
//     _initializeCamera();
//
//     flutterTts.setLanguage("en-US");
//     flutterTts.setPitch(1.0);
//     flutterTts.setSpeechRate(0.5);
//   }
//
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//
//     description = cameras.firstWhere(
//           (camera) => camera.lensDirection == camDirec,
//       orElse: () => cameras.first,
//     );
//
//     controller = CameraController(
//       description,
//       ResolutionPreset.medium,
//       imageFormatGroup: Platform.isAndroid
//           ? ImageFormatGroup.nv21
//           : ImageFormatGroup.bgra8888,
//       enableAudio: false,
//     );
//
//     await controller!.initialize();
//
//     controller!.startImageStream((CameraImage image) {
//       if (!isBusy) {
//         isBusy = true;
//         frame = image;
//         doFaceDetectionOnFrame();
//       }
//     });
//
//     setState(() {});
//   }
//
//   /// Flip camera
//   Future<void> _toggleCameraDirection() async {
//     camDirec = (camDirec == CameraLensDirection.back)
//         ? CameraLensDirection.front
//         : CameraLensDirection.back;
//
//     await controller?.stopImageStream();
//     await controller?.dispose();
//
//     _spokenNames.clear(); // reset spoken names when camera flips
//
//     await _initializeCamera();
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> doFaceDetectionOnFrame() async {
//     InputImage? inputImage = getInputImage();
//     if (inputImage == null) {
//       setState(() {
//         isBusy = false;
//       });
//       return;
//     }
//
//     List<Face> faces = await faceDetector.processImage(inputImage);
//
//     if (faces.isEmpty) {
//       _spokenNames.clear(); // reset if no faces in view
//     }
//
//     performFaceRecognition(faces);
//   }
//
//   img.Image? image;
//   bool register = false;
//
//   performFaceRecognition(List<Face> faces) async {
//     recognitions.clear();
//
//     image = Platform.isIOS
//         ? Util.convertBGRA8888ToImage(frame!)
//         : Util.convertNV21(frame!);
//
//     image = img.copyRotate(
//       image!,
//       angle: camDirec == CameraLensDirection.front ? 270 : 90,
//     );
//
//     for (Face face in faces) {
//       Rect faceRect = face.boundingBox;
//
//       img.Image croppedFace = img.copyCrop(
//         image!,
//         x: faceRect.left.toInt(),
//         y: faceRect.top.toInt(),
//         width: faceRect.width.toInt(),
//         height: faceRect.height.toInt(),
//       );
//
//       Recognition recognition = await recognizer.recognize(
//         croppedFace,
//         faceRect,
//       );
//
//       if (recognition.distance < 0.3) {
//         recognition.name = "Unknown";
//       }
//
//       recognitions.add(recognition);
//
//       // Speak name once while face is in view
//       if (recognition.name.isNotEmpty &&
//           !_spokenNames.contains(recognition.name)) {
//         _spokenNames.add(recognition.name);
//         await flutterTts.speak(recognition.name);
//       }
//     }
//
//     setState(() {
//       isBusy = false;
//       _scanResults = recognitions;
//     });
//   }
//
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };
//
//   InputImage? getInputImage() {
//     final sensorOrientation = description.sensorOrientation;
//
//     InputImageRotation? rotation;
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       var rotationCompensation =
//       _orientations[controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//
//       if (description.lensDirection == CameraLensDirection.front) {
//         rotation = InputImageRotationValue.fromRawValue(
//             (sensorOrientation + rotationCompensation) % 360);
//       } else {
//         rotation = InputImageRotationValue.fromRawValue(
//             (sensorOrientation - rotationCompensation + 360) % 360);
//       }
//     }
//     if (rotation == null) return null;
//
//     final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) {
//       return null;
//     }
//
//     if (frame!.planes.length != 1) return null;
//     final plane = frame!.planes.first;
//
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: plane.bytesPerRow,
//       ),
//     );
//   }
//
//   Widget buildResult() {
//     if (_scanResults == null ||
//         controller == null ||
//         !controller!.value.isInitialized) {
//       return const Center(child: Text('Camera is not initialized'));
//     }
//
//     final Size imageSize = Size(
//       controller!.value.previewSize!.height,
//       controller!.value.previewSize!.width,
//     );
//
//     CustomPainter painter =
//     FaceDetectorPainter(imageSize, _scanResults, camDirec);
//
//     return CustomPaint(painter: painter);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       // onWillPop: () async {
//       //   // Navigate to HomeScreen on back
//       //   Navigator.pushReplacement(
//       //       context, MaterialPageRoute(builder: (_) => const HomeScreen()));
//       //   return false; // prevent default back
//       // },
//       onWillPop: () async {
//         // Go to HomeScreen and remove all previous routes
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (_) => const HomeScreen()),
//               (route) => false,
//         );
//         return false; // prevent default back
//       },
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.black,
//           body: Stack(
//             children: [
//               if (controller != null)
//                 Positioned.fill(
//                   child: (controller!.value.isInitialized)
//                       ? CameraPreview(controller!)
//                       : Container(),
//                 ),
//               if (controller != null) Positioned.fill(child: buildResult()),
//               Positioned(
//                 bottom: 40,
//                 left: 20,
//                 right: 20,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurple.withAlpha(80),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.white.withOpacity(0.2)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.cached, color: Colors.white),
//                             iconSize: 40,
//                             onPressed: _toggleCameraDirection,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FaceDetectorPainter extends CustomPainter {
//   final Size absoluteImageSize;
//   final List<Recognition> faces;
//   final CameraLensDirection camDirection;
//
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDirection);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double scaleX = size.width / absoluteImageSize.width;
//     final double scaleY = size.height / absoluteImageSize.height;
//
//     final Paint boxPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.5
//       ..color = Colors.deepPurple.shade300;
//
//     final Paint labelBgPaint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.deepPurple.shade300.withAlpha(150);
//
//     for (final face in faces) {
//       final double left = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.right) * scaleX
//           : face.location.left * scaleX;
//       final double top = face.location.top * scaleY;
//       final double right = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.left) * scaleX
//           : face.location.right * scaleX;
//       final double bottom = face.location.bottom * scaleY;
//
//       final rect = Rect.fromLTRB(left, top, right, bottom);
//       final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
//       canvas.drawRRect(rRect, boxPaint);
//
//       final String label = face.name.isNotEmpty
//           ? '${face.name} (${face.distance.toStringAsFixed(2)})'
//           : 'Unknown';
//
//       final textSpan = TextSpan(
//         text: label,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       );
//
//       final textPainter =
//       TextPainter(text: textSpan, textDirection: TextDirection.ltr)
//         ..layout(maxWidth: size.width * 0.6);
//
//       final double labelPadding = 6;
//       final double labelX = left;
//       final double labelY = top - textPainter.height - 8;
//
//       final backgroundRect = Rect.fromLTWH(
//         labelX,
//         labelY < 0 ? top + 4 : labelY,
//         textPainter.width + labelPadding * 2,
//         textPainter.height + labelPadding,
//       );
//
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(backgroundRect, const Radius.circular(8)),
//         labelBgPaint,
//       );
//
//       textPainter.paint(
//         canvas,
//         Offset(
//           backgroundRect.left + labelPadding,
//           backgroundRect.top + labelPadding / 2,
//         ),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) => true;
// }




// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;
// import 'package:objectde/Util.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import '../ML/Recognition.dart';
// import '../ML/Recognizer.dart';
// import 'package:objectde/person_detection.dart';
// import 'HomeScreen.dart'; // Make sure this import exists
//
// class RecognitionScreen extends StatefulWidget {
//   const RecognitionScreen({super.key});
//
//   @override
//   State<RecognitionScreen> createState() => _RecognitionScreenState();
// }
//
// class _RecognitionScreenState extends State<RecognitionScreen> {
//   CameraController? controller;
//   bool isBusy = false;
//   late Size size;
//   late CameraDescription description;
//   CameraLensDirection camDirec = CameraLensDirection.front;
//   late List<Recognition> recognitions = [];
//
//   late FaceDetector faceDetector;
//   late Recognizer recognizer;
//   CameraImage? frame;
//   dynamic _scanResults;
//
//   final FlutterTts flutterTts = FlutterTts();
//   Set<String> _spokenNames = {};
//
//   @override
//   void initState() {
//     super.initState();
//     var options = FaceDetectorOptions(performanceMode: FaceDetectorMode.fast);
//     faceDetector = FaceDetector(options: options);
//     recognizer = Recognizer();
//     _initializeCamera();
//
//     flutterTts.setLanguage("en-US");
//     flutterTts.setPitch(1.0);
//     flutterTts.setSpeechRate(0.5);
//   }
//
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//
//     description = cameras.firstWhere(
//           (camera) => camera.lensDirection == camDirec,
//       orElse: () => cameras.first,
//     );
//
//     controller = CameraController(
//       description,
//       ResolutionPreset.medium,
//       imageFormatGroup: Platform.isAndroid
//           ? ImageFormatGroup.nv21
//           : ImageFormatGroup.bgra8888,
//       enableAudio: false,
//     );
//
//     await controller!.initialize();
//
//     controller!.startImageStream((CameraImage image) {
//       if (!isBusy) {
//         isBusy = true;
//         frame = image;
//         doFaceDetectionOnFrame();
//       }
//     });
//
//     setState(() {});
//   }
//
//   Future<void> _toggleCameraDirection() async {
//     camDirec = (camDirec == CameraLensDirection.back)
//         ? CameraLensDirection.front
//         : CameraLensDirection.back;
//
//     await controller?.stopImageStream();
//     await controller?.dispose();
//     _spokenNames.clear();
//     await _initializeCamera();
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> doFaceDetectionOnFrame() async {
//     InputImage? inputImage = getInputImage();
//     if (inputImage == null) {
//       setState(() {
//         isBusy = false;
//       });
//       return;
//     }
//
//     List<Face> faces = await faceDetector.processImage(inputImage);
//     if (faces.isEmpty) _spokenNames.clear();
//     performFaceRecognition(faces);
//   }
//
//   img.Image? image;
//   bool register = false;
//
//   performFaceRecognition(List<Face> faces) async {
//     recognitions.clear();
//
//     image = Platform.isIOS
//         ? Util.convertBGRA8888ToImage(frame!)
//         : Util.convertNV21(frame!);
//
//     image = img.copyRotate(
//       image!,
//       angle: camDirec == CameraLensDirection.front ? 270 : 90,
//     );
//
//     for (Face face in faces) {
//       Rect faceRect = face.boundingBox;
//
//       img.Image croppedFace = img.copyCrop(
//         image!,
//         x: faceRect.left.toInt(),
//         y: faceRect.top.toInt(),
//         width: faceRect.width.toInt(),
//         height: faceRect.height.toInt(),
//       );
//
//       Recognition recognition = await recognizer.recognize(
//         croppedFace,
//         faceRect,
//       );
//
//       if (recognition.distance < 0.3) recognition.name = "Unknown";
//       recognitions.add(recognition);
//
//       if (recognition.name.isNotEmpty &&
//           !_spokenNames.contains(recognition.name)) {
//         _spokenNames.add(recognition.name);
//         await flutterTts.speak(recognition.name);
//       }
//     }
//
//     setState(() {
//       isBusy = false;
//       _scanResults = recognitions;
//     });
//   }
//
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };
//
//   InputImage? getInputImage() {
//     final sensorOrientation = description.sensorOrientation;
//
//     InputImageRotation? rotation;
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       var rotationCompensation =
//       _orientations[controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//
//       rotation = InputImageRotationValue.fromRawValue(
//         description.lensDirection == CameraLensDirection.front
//             ? (sensorOrientation + rotationCompensation) % 360
//             : (sensorOrientation - rotationCompensation + 360) % 360,
//       );
//     }
//
//     if (rotation == null) return null;
//     final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;
//
//     if (frame!.planes.length != 1) return null;
//     final plane = frame!.planes.first;
//
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: plane.bytesPerRow,
//       ),
//     );
//   }
//
//   Widget buildResult() {
//     if (_scanResults == null ||
//         controller == null ||
//         !controller!.value.isInitialized) {
//       return const Center(child: Text('Camera is not initialized'));
//     }
//
//     final Size imageSize = Size(
//       controller!.value.previewSize!.height,
//       controller!.value.previewSize!.width,
//     );
//
//     CustomPainter painter =
//     FaceDetectorPainter(imageSize, _scanResults, camDirec);
//
//     return CustomPaint(painter: painter);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (_) => const HomeScreen()),
//               (route) => false,
//         );
//         return false;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.black,
//           body: Stack(
//             children: [
//               if (controller != null)
//                 Positioned.fill(
//                   child: (controller!.value.isInitialized)
//                       ? CameraPreview(controller!)
//                       : Container(),
//                 ),
//               if (controller != null) Positioned.fill(child: buildResult()),
//               Positioned(
//                 bottom: 40,
//                 left: 20,
//                 right: 20,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurple.withAlpha(80),
//                         borderRadius: BorderRadius.circular(20),
//                         border:
//                         Border.all(color: Colors.white.withOpacity(0.2)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.cached,
//                                 color: Colors.white),
//                             iconSize: 40,
//                             onPressed: _toggleCameraDirection,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FaceDetectorPainter extends CustomPainter {
//   final Size absoluteImageSize;
//   final List<Recognition> faces;
//   final CameraLensDirection camDirection;
//
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDirection);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double scaleX = size.width / absoluteImageSize.width;
//     final double scaleY = size.height / absoluteImageSize.height;
//
//     final Paint boxPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.5
//       ..color = Colors.deepPurple.shade300;
//
//     final Paint labelBgPaint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.deepPurple.shade300.withAlpha(150);
//
//     for (final face in faces) {
//       final double left = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.right) * scaleX
//           : face.location.left * scaleX;
//       final double top = face.location.top * scaleY;
//       final double right = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.left) * scaleX
//           : face.location.right * scaleX;
//       final double bottom = face.location.bottom * scaleY;
//
//       final rect = Rect.fromLTRB(left, top, right, bottom);
//       final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
//       canvas.drawRRect(rRect, boxPaint);
//
//       final String label = face.name.isNotEmpty
//           ? '${face.name} (${face.distance.toStringAsFixed(2)})'
//           : 'Unknown';
//
//       final textSpan = TextSpan(
//         text: label,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       );
//
//       final textPainter =
//       TextPainter(text: textSpan, textDirection: TextDirection.ltr)
//         ..layout(maxWidth: size.width * 0.6);
//
//       final double labelPadding = 6;
//       final double labelX = left;
//       final double labelY = top - textPainter.height - 8;
//
//       final backgroundRect = Rect.fromLTWH(
//         labelX,
//         labelY < 0 ? top + 4 : labelY,
//         textPainter.width + labelPadding * 2,
//         textPainter.height + labelPadding,
//       );
//
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(backgroundRect, const Radius.circular(8)),
//         labelBgPaint,
//       );
//
//       textPainter.paint(
//         canvas,
//         Offset(
//           backgroundRect.left + labelPadding,
//           backgroundRect.top + labelPadding / 2,
//         ),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) => true;
// }



// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;
// import 'package:objectde/Util.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import '../ML/Recognition.dart';
// import '../ML/Recognizer.dart';
// import 'package:objectde/person_detection.dart';
// import 'HomeScreen.dart'; // Make sure this import exists
//
// class RecognitionScreen extends StatefulWidget {
//   const RecognitionScreen({super.key});
//
//   @override
//   State<RecognitionScreen> createState() => _RecognitionScreenState();
// }
//
// class _RecognitionScreenState extends State<RecognitionScreen> {
//   CameraController? controller;
//   bool isBusy = false;
//   late Size size;
//   late CameraDescription description;
//   CameraLensDirection camDirec = CameraLensDirection.front;
//   late List<Recognition> recognitions = [];
//
//   late FaceDetector faceDetector;
//   late Recognizer recognizer;
//   CameraImage? frame;
//   dynamic _scanResults;
//
//   final FlutterTts flutterTts = FlutterTts();
//   Set<String> _spokenNames = {};
//
//   @override
//   void initState() {
//     super.initState();
//     var options = FaceDetectorOptions(performanceMode: FaceDetectorMode.fast);
//     faceDetector = FaceDetector(options: options);
//     recognizer = Recognizer();
//     _initializeCamera();
//
//     flutterTts.setLanguage("en-US");
//     flutterTts.setPitch(1.0);
//     flutterTts.setSpeechRate(0.5);
//   }
//
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//
//     description = cameras.firstWhere(
//           (camera) => camera.lensDirection == camDirec,
//       orElse: () => cameras.first,
//     );
//
//     controller = CameraController(
//       description,
//       ResolutionPreset.medium,
//       imageFormatGroup: Platform.isAndroid
//           ? ImageFormatGroup.nv21
//           : ImageFormatGroup.bgra8888,
//       enableAudio: false,
//     );
//
//     await controller!.initialize();
//
//     controller!.startImageStream((CameraImage image) {
//       if (!isBusy) {
//         isBusy = true;
//         frame = image;
//         doFaceDetectionOnFrame();
//       }
//     });
//
//     setState(() {});
//   }
//
//   Future<void> _toggleCameraDirection() async {
//     camDirec = (camDirec == CameraLensDirection.back)
//         ? CameraLensDirection.front
//         : CameraLensDirection.back;
//
//     await controller?.stopImageStream();
//     await controller?.dispose();
//     _spokenNames.clear();
//     await _initializeCamera();
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> doFaceDetectionOnFrame() async {
//     InputImage? inputImage = getInputImage();
//     if (inputImage == null) {
//       setState(() {
//         isBusy = false;
//       });
//       return;
//     }
//
//     List<Face> faces = await faceDetector.processImage(inputImage);
//     if (faces.isEmpty) _spokenNames.clear();
//     performFaceRecognition(faces);
//   }
//
//   img.Image? image;
//   bool register = false;
//
//   performFaceRecognition(List<Face> faces) async {
//     recognitions.clear();
//
//     image = Platform.isIOS
//         ? Util.convertBGRA8888ToImage(frame!)
//         : Util.convertNV21(frame!);
//
//     image = img.copyRotate(
//       image!,
//       angle: camDirec == CameraLensDirection.front ? 270 : 90,
//     );
//
//     for (Face face in faces) {
//       Rect faceRect = face.boundingBox;
//
//       img.Image croppedFace = img.copyCrop(
//         image!,
//         x: faceRect.left.toInt(),
//         y: faceRect.top.toInt(),
//         width: faceRect.width.toInt(),
//         height: faceRect.height.toInt(),
//       );
//
//       Recognition recognition = await recognizer.recognize(
//         croppedFace,
//         faceRect,
//       );
//
//       if (recognition.distance < 0.3) recognition.name = "Unknown";
//       recognitions.add(recognition);
//
//       if (recognition.name.isNotEmpty &&
//           !_spokenNames.contains(recognition.name)) {
//         _spokenNames.add(recognition.name);
//         await flutterTts.speak(recognition.name);
//       }
//     }
//
//     setState(() {
//       isBusy = false;
//       _scanResults = recognitions;
//     });
//   }
//
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };
//
//   InputImage? getInputImage() {
//     final sensorOrientation = description.sensorOrientation;
//
//     InputImageRotation? rotation;
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       var rotationCompensation =
//       _orientations[controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//
//       rotation = InputImageRotationValue.fromRawValue(
//         description.lensDirection == CameraLensDirection.front
//             ? (sensorOrientation + rotationCompensation) % 360
//             : (sensorOrientation - rotationCompensation + 360) % 360,
//       );
//     }
//
//     if (rotation == null) return null;
//     final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;
//
//     if (frame!.planes.length != 1) return null;
//     final plane = frame!.planes.first;
//
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: plane.bytesPerRow,
//       ),
//     );
//   }
//
//   Widget buildResult() {
//     if (_scanResults == null ||
//         controller == null ||
//         !controller!.value.isInitialized) {
//       return const Center(child: Text('Camera is not initialized'));
//     }
//
//     final Size imageSize = Size(
//       controller!.value.previewSize!.height,
//       controller!.value.previewSize!.width,
//     );
//
//     CustomPainter painter =
//     FaceDetectorPainter(imageSize, _scanResults, camDirec);
//
//     return CustomPaint(painter: painter);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Go back to previous screen
//         Navigator.pop(context);
//         return true;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.black,
//           body: Stack(
//             children: [
//               if (controller != null)
//                 Positioned.fill(
//                   child: (controller!.value.isInitialized)
//                       ? CameraPreview(controller!)
//                       : Container(),
//                 ),
//               if (controller != null) Positioned.fill(child: buildResult()),
//               Positioned(
//                 bottom: 40,
//                 left: 20,
//                 right: 20,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurple.withAlpha(80),
//                         borderRadius: BorderRadius.circular(20),
//                         border:
//                         Border.all(color: Colors.white.withOpacity(0.2)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.cached, color: Colors.white),
//                             iconSize: 40,
//                             onPressed: _toggleCameraDirection,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FaceDetectorPainter extends CustomPainter {
//   final Size absoluteImageSize;
//   final List<Recognition> faces;
//   final CameraLensDirection camDirection;
//
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDirection);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double scaleX = size.width / absoluteImageSize.width;
//     final double scaleY = size.height / absoluteImageSize.height;
//
//     final Paint boxPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.5
//       ..color = Colors.deepPurple.shade300;
//
//     final Paint labelBgPaint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.deepPurple.shade300.withAlpha(150);
//
//     for (final face in faces) {
//       final double left = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.right) * scaleX
//           : face.location.left * scaleX;
//       final double top = face.location.top * scaleY;
//       final double right = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.left) * scaleX
//           : face.location.right * scaleX;
//       final double bottom = face.location.bottom * scaleY;
//
//       final rect = Rect.fromLTRB(left, top, right, bottom);
//       final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
//       canvas.drawRRect(rRect, boxPaint);
//
//       final String label = face.name.isNotEmpty
//           ? '${face.name} (${face.distance.toStringAsFixed(2)})'
//           : 'Unknown';
//
//       final textSpan = TextSpan(
//         text: label,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       );
//
//       final textPainter =
//       TextPainter(text: textSpan, textDirection: TextDirection.ltr)
//         ..layout(maxWidth: size.width * 0.6);
//
//       final double labelPadding = 6;
//       final double labelX = left;
//       final double labelY = top - textPainter.height - 8;
//
//       final backgroundRect = Rect.fromLTWH(
//         labelX,
//         labelY < 0 ? top + 4 : labelY,
//         textPainter.width + labelPadding * 2,
//         textPainter.height + labelPadding,
//       );
//
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(backgroundRect, const Radius.circular(8)),
//         labelBgPaint,
//       );
//
//       textPainter.paint(
//         canvas,
//         Offset(
//           backgroundRect.left + labelPadding,
//           backgroundRect.top + labelPadding / 2,
//         ),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) => true;
// }


















// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'dart:ui';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;
// import 'package:flutter_tts/flutter_tts.dart';
// import '../ML/Recognition.dart';
// import '../ML/Recognizer.dart';
// import 'package:flutter/services.dart';
// import 'package:objectde/Util.dart'; // or correct path in your project
//
//
// class RecognitionScreen extends StatefulWidget {
//   const RecognitionScreen({super.key});
//
//   @override
//   State<RecognitionScreen> createState() => _RecognitionScreenState();
// }
//
// class _RecognitionScreenState extends State<RecognitionScreen> {
//   CameraController? controller;
//   bool isBusy = false;
//   bool _isSwitchingCamera = false; // ✅ new flag to prevent rebuild during switch
//   late Size size;
//   late CameraDescription description;
//   CameraLensDirection camDirec = CameraLensDirection.front;
//   late List<Recognition> recognitions = [];
//
//   late FaceDetector faceDetector;
//   late Recognizer recognizer;
//   CameraImage? frame;
//   dynamic _scanResults;
//
//   final FlutterTts flutterTts = FlutterTts();
//   Set<String> _spokenNames = {};
//
//   @override
//   void initState() {
//     super.initState();
//     var options = FaceDetectorOptions(performanceMode: FaceDetectorMode.fast);
//     faceDetector = FaceDetector(options: options);
//     recognizer = Recognizer();
//     _initializeCamera();
//
//     flutterTts.setLanguage("en-US");
//     flutterTts.setPitch(1.0);
//     flutterTts.setSpeechRate(0.5);
//   }
//
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//
//     description = cameras.firstWhere(
//           (camera) => camera.lensDirection == camDirec,
//       orElse: () => cameras.first,
//     );
//
//     controller = CameraController(
//       description,
//       ResolutionPreset.medium,
//       imageFormatGroup:
//       Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
//       enableAudio: false,
//     );
//
//     try {
//       await controller!.initialize();
//
//       controller!.startImageStream((CameraImage image) {
//         if (!isBusy) {
//           isBusy = true;
//           frame = image;
//           doFaceDetectionOnFrame();
//         }
//       });
//
//       if (mounted) setState(() {});
//     } catch (e) {
//       debugPrint("Camera initialization error: $e");
//     }
//   }
//
//   Future<void> _toggleCameraDirection() async {
//     if (_isSwitchingCamera) return;
//     _isSwitchingCamera = true;
//
//     camDirec = camDirec == CameraLensDirection.back
//         ? CameraLensDirection.front
//         : CameraLensDirection.back;
//
//     _spokenNames.clear();
//
//     // Dispose safely
//     if (controller != null) {
//       await controller!.stopImageStream();
//       await controller!.dispose();
//       controller = null;
//       if (mounted) setState(() {}); // Update UI after disposal
//     }
//
//     await _initializeCamera();
//     _isSwitchingCamera = false;
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> doFaceDetectionOnFrame() async {
//     InputImage? inputImage = getInputImage();
//     if (inputImage == null) {
//       setState(() {
//         isBusy = false;
//       });
//       return;
//     }
//
//     List<Face> faces = await faceDetector.processImage(inputImage);
//     if (faces.isEmpty) _spokenNames.clear();
//     performFaceRecognition(faces);
//   }
//
//   img.Image? image;
//
//   performFaceRecognition(List<Face> faces) async {
//     recognitions.clear();
//
//     if (frame == null) {
//       isBusy = false;
//       return;
//     }
//
//     image = Platform.isIOS
//         ? Util.convertBGRA8888ToImage(frame!)
//         : Util.convertNV21(frame!);
//
//     image = img.copyRotate(
//       image!,
//       angle: camDirec == CameraLensDirection.front ? 270 : 90,
//     );
//
//     for (Face face in faces) {
//       Rect faceRect = face.boundingBox;
//
//       img.Image croppedFace = img.copyCrop(
//         image!,
//         x: faceRect.left.toInt(),
//         y: faceRect.top.toInt(),
//         width: faceRect.width.toInt(),
//         height: faceRect.height.toInt(),
//       );
//
//       Recognition recognition = await recognizer.recognize(
//         croppedFace,
//         faceRect,
//       );
//
//       if (recognition.distance < 0.3) recognition.name = "Unknown";
//       recognitions.add(recognition);
//
//       if (recognition.name.isNotEmpty &&
//           !_spokenNames.contains(recognition.name)) {
//         _spokenNames.add(recognition.name);
//         await flutterTts.speak(recognition.name);
//       }
//     }
//
//     if (mounted) {
//       setState(() {
//         isBusy = false;
//         _scanResults = recognitions;
//       });
//     } else {
//       isBusy = false;
//     }
//   }
//
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };
//
//   InputImage? getInputImage() {
//     if (controller == null || frame == null || !controller!.value.isInitialized) {
//       return null;
//     }
//
//     final sensorOrientation = description.sensorOrientation;
//     InputImageRotation? rotation;
//
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       var rotationCompensation =
//       _orientations[controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//
//       rotation = InputImageRotationValue.fromRawValue(
//         description.lensDirection == CameraLensDirection.front
//             ? (sensorOrientation + rotationCompensation) % 360
//             : (sensorOrientation - rotationCompensation + 360) % 360,
//       );
//     }
//
//     if (rotation == null) return null;
//     final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;
//
//     if (frame!.planes.length != 1) return null;
//     final plane = frame!.planes.first;
//
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: plane.bytesPerRow,
//       ),
//     );
//   }
//
//   Widget buildResult() {
//     if (_scanResults == null ||
//         controller == null ||
//         !controller!.value.isInitialized) {
//       return const SizedBox.shrink();
//     }
//
//     final Size imageSize = Size(
//       controller!.value.previewSize!.height,
//       controller!.value.previewSize!.width,
//     );
//
//     return CustomPaint(
//       painter: FaceDetectorPainter(imageSize, _scanResults, camDirec),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pop(context);
//         return true;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.black,
//           body: Stack(
//             children: [
//               if (controller != null && controller!.value.isInitialized)
//                 Positioned.fill(child: CameraPreview(controller!)),
//               if (controller != null && controller!.value.isInitialized)
//                 Positioned.fill(child: buildResult()),
//               Positioned(
//                 bottom: 40,
//                 left: 20,
//                 right: 20,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurple.withAlpha(80),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.white.withOpacity(0.2)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.cached, color: Colors.white),
//                             iconSize: 40,
//                             onPressed: _toggleCameraDirection,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FaceDetectorPainter extends CustomPainter {
//   final Size absoluteImageSize;
//   final List<Recognition> faces;
//   final CameraLensDirection camDirection;
//
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDirection);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double scaleX = size.width / absoluteImageSize.width;
//     final double scaleY = size.height / absoluteImageSize.height;
//
//     final Paint boxPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.5
//       ..color = Colors.deepPurple.shade300;
//
//     final Paint labelBgPaint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.deepPurple.shade300.withAlpha(150);
//
//     for (final face in faces) {
//       final double left = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.right) * scaleX
//           : face.location.left * scaleX;
//       final double top = face.location.top * scaleY;
//       final double right = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.left) * scaleX
//           : face.location.right * scaleX;
//       final double bottom = face.location.bottom * scaleY;
//
//       final rect = Rect.fromLTRB(left, top, right, bottom);
//       final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
//       canvas.drawRRect(rRect, boxPaint);
//
//       final String label = face.name.isNotEmpty
//           ? '${face.name} (${face.distance.toStringAsFixed(2)})'
//           : 'Unknown';
//
//       final textSpan = TextSpan(
//         text: label,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       );
//
//       final textPainter =
//       TextPainter(text: textSpan, textDirection: TextDirection.ltr)
//         ..layout(maxWidth: size.width * 0.6);
//
//       final double labelPadding = 6;
//       final double labelX = left;
//       final double labelY = top - textPainter.height - 8;
//
//       final backgroundRect = Rect.fromLTWH(
//         labelX,
//         labelY < 0 ? top + 4 : labelY,
//         textPainter.width + labelPadding * 2,
//         textPainter.height + labelPadding,
//       );
//
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(backgroundRect, const Radius.circular(8)),
//         labelBgPaint,
//       );
//
//       textPainter.paint(
//         canvas,
//         Offset(
//           backgroundRect.left + labelPadding,
//           backgroundRect.top + labelPadding / 2,
//         ),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) => true;
// }


















//
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;
// import 'package:flutter_tts/flutter_tts.dart';
// import '../ML/Recognition.dart';
// import '../ML/Recognizer.dart';
// import 'package:objectde/Util.dart';
//
// class RecognitionScreen extends StatefulWidget {
//   const RecognitionScreen({super.key});
//
//   @override
//   State<RecognitionScreen> createState() => _RecognitionScreenState();
// }
//
// class _RecognitionScreenState extends State<RecognitionScreen> {
//   CameraController? controller;
//   bool isBusy = false;
//   bool _isSwitchingCamera = false;
//   bool _isCameraInitialized = false;
//
//   late CameraDescription description;
//   CameraLensDirection camDirec = CameraLensDirection.front;
//   late List<Recognition> recognitions = [];
//
//   late FaceDetector faceDetector;
//   late Recognizer recognizer;
//   CameraImage? frame;
//   dynamic _scanResults;
//
//   final FlutterTts flutterTts = FlutterTts();
//   Set<String> _spokenNames = {};
//
//   @override
//   void initState() {
//     super.initState();
//     faceDetector =
//         FaceDetector(options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast));
//     recognizer = Recognizer();
//     _initializeCamera();
//
//     flutterTts.setLanguage("en-US");
//     flutterTts.setPitch(1.0);
//     flutterTts.setSpeechRate(0.5);
//   }
//
//   Future<void> _initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//
//       description = cameras.firstWhere(
//             (camera) => camera.lensDirection == camDirec,
//         orElse: () => cameras.first,
//       );
//
//       final newController = CameraController(
//         description,
//         ResolutionPreset.medium,
//         imageFormatGroup:
//         Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
//         enableAudio: false,
//       );
//
//       await newController.initialize();
//
//       // Stop old controller safely
//       if (controller != null) {
//         await controller!.dispose();
//       }
//
//       controller = newController;
//       _isCameraInitialized = true;
//
//       controller!.startImageStream((CameraImage image) {
//         if (!isBusy && mounted && !_isSwitchingCamera) {
//           isBusy = true;
//           frame = image;
//           doFaceDetectionOnFrame();
//         }
//       });
//
//       if (mounted) setState(() {});
//     } catch (e) {
//       debugPrint("Camera initialization error: $e");
//     }
//   }
//
//   Future<void> _toggleCameraDirection() async {
//     if (_isSwitchingCamera) return;
//     _isSwitchingCamera = true;
//     _isCameraInitialized = false;
//
//     try {
//       camDirec = camDirec == CameraLensDirection.back
//           ? CameraLensDirection.front
//           : CameraLensDirection.back;
//
//       _spokenNames.clear();
//
//       // Stop and dispose safely
//       if (controller != null) {
//         try {
//           await controller!.stopImageStream();
//         } catch (_) {}
//         await controller!.dispose();
//         controller = null;
//       }
//
//       if (mounted) setState(() {});
//
//       // Small delay to ensure camera resources released
//       await Future.delayed(const Duration(milliseconds: 400));
//
//       await _initializeCamera();
//     } catch (e) {
//       debugPrint("Error toggling camera: $e");
//     } finally {
//       _isSwitchingCamera = false;
//       if (mounted) setState(() {});
//     }
//   }
//
//   @override
//   void dispose() {
//     try {
//       controller?.dispose();
//     } catch (_) {}
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> doFaceDetectionOnFrame() async {
//     final inputImage = getInputImage();
//     if (inputImage == null) {
//       isBusy = false;
//       return;
//     }
//
//     try {
//       final faces = await faceDetector.processImage(inputImage);
//       if (faces.isEmpty) _spokenNames.clear();
//       await performFaceRecognition(faces);
//     } catch (e) {
//       debugPrint("Face detection error: $e");
//     } finally {
//       isBusy = false;
//     }
//   }
//
//   img.Image? image;
//
//   Future<void> performFaceRecognition(List<Face> faces) async {
//     recognitions.clear();
//
//     if (frame == null) return;
//
//     image = Platform.isIOS
//         ? Util.convertBGRA8888ToImage(frame!)
//         : Util.convertNV21(frame!);
//
//     image = img.copyRotate(
//       image!,
//       angle: camDirec == CameraLensDirection.front ? 270 : 90,
//     );
//
//     for (final face in faces) {
//       final faceRect = face.boundingBox;
//       if (faceRect.width <= 0 || faceRect.height <= 0) continue;
//
//       final croppedFace = img.copyCrop(
//         image!,
//         x: faceRect.left.clamp(0, image!.width - 1).toInt(),
//         y: faceRect.top.clamp(0, image!.height - 1).toInt(),
//         width: faceRect.width.clamp(1, image!.width - faceRect.left).toInt(),
//         height: faceRect.height.clamp(1, image!.height - faceRect.top).toInt(),
//       );
//
//       final recognition = await recognizer.recognize(croppedFace, faceRect);
//
//       if (recognition.distance < 0.3) recognition.name = "Unknown";
//       recognitions.add(recognition);
//
//       if (recognition.name.isNotEmpty && !_spokenNames.contains(recognition.name)) {
//         _spokenNames.add(recognition.name);
//         await flutterTts.speak(recognition.name);
//       }
//     }
//
//     if (mounted) {
//       setState(() {
//         _scanResults = recognitions;
//       });
//     }
//   }
//
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };
//
//   InputImage? getInputImage() {
//     if (controller == null || frame == null || !controller!.value.isInitialized) {
//       return null;
//     }
//
//     final sensorOrientation = description.sensorOrientation;
//     InputImageRotation? rotation;
//
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else {
//       final rotationCompensation = _orientations[controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//
//       rotation = InputImageRotationValue.fromRawValue(
//         description.lensDirection == CameraLensDirection.front
//             ? (sensorOrientation + rotationCompensation) % 360
//             : (sensorOrientation - rotationCompensation + 360) % 360,
//       );
//     }
//
//     if (rotation == null) return null;
//     final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;
//
//     if (frame!.planes.length != 1) return null;
//     final plane = frame!.planes.first;
//
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: plane.bytesPerRow,
//       ),
//     );
//   }
//
//   Widget buildResult() {
//     if (_scanResults == null ||
//         controller == null ||
//         !controller!.value.isInitialized) {
//       return const SizedBox.shrink();
//     }
//
//     final Size imageSize = Size(
//       controller!.value.previewSize!.height,
//       controller!.value.previewSize!.width,
//     );
//
//     return CustomPaint(
//       painter: FaceDetectorPainter(imageSize, _scanResults, camDirec),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final showPreview = controller != null &&
//         controller!.value.isInitialized &&
//         !_isSwitchingCamera &&
//         _isCameraInitialized;
//
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pop(context);
//         return true;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.black,
//           body: Stack(
//             children: [
//               if (showPreview) Positioned.fill(child: CameraPreview(controller!)),
//               if (showPreview) Positioned.fill(child: buildResult()),
//
//               // Overlay for camera switching
//               if (_isSwitchingCamera || !_isCameraInitialized)
//                 const Center(
//                   child: CircularProgressIndicator(color: Colors.deepPurple),
//                 ),
//
//               Positioned(
//                 bottom: 40,
//                 left: 20,
//                 right: 20,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurple.withAlpha(80),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.white.withOpacity(0.2)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.cached, color: Colors.white),
//                             iconSize: 40,
//                             onPressed: _toggleCameraDirection,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FaceDetectorPainter extends CustomPainter {
//   final Size absoluteImageSize;
//   final List<Recognition> faces;
//   final CameraLensDirection camDirection;
//
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDirection);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final scaleX = size.width / absoluteImageSize.width;
//     final scaleY = size.height / absoluteImageSize.height;
//
//     final boxPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.5
//       ..color = Colors.deepPurple.shade300;
//
//     final labelBgPaint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.deepPurple.shade300.withAlpha(150);
//
//     for (final face in faces) {
//       final left = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.right) * scaleX
//           : face.location.left * scaleX;
//       final top = face.location.top * scaleY;
//       final right = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.left) * scaleX
//           : face.location.right * scaleX;
//       final bottom = face.location.bottom * scaleY;
//
//       final rect = Rect.fromLTRB(left, top, right, bottom);
//       final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
//       canvas.drawRRect(rRect, boxPaint);
//
//       final label = face.name.isNotEmpty
//           ? '${face.name} (${face.distance.toStringAsFixed(2)})'
//           : 'Unknown';
//
//       final textSpan = TextSpan(
//         text: label,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       );
//
//       final textPainter =
//       TextPainter(text: textSpan, textDirection: TextDirection.ltr)
//         ..layout(maxWidth: size.width * 0.6);
//
//       final labelPadding = 6;
//       final labelX = left;
//       final labelY = top - textPainter.height - 8;
//
//       final backgroundRect = Rect.fromLTWH(
//         labelX,
//         labelY < 0 ? top + 4 : labelY,
//         textPainter.width + labelPadding * 2,
//         textPainter.height + labelPadding,
//       );
//
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(backgroundRect, const Radius.circular(8)),
//         labelBgPaint,
//       );
//
//       textPainter.paint(
//         canvas,
//         Offset(backgroundRect.left + labelPadding,
//             backgroundRect.top + labelPadding / 2),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) => true;
// }




// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;
// import 'package:flutter_tts/flutter_tts.dart';
// import '../ML/Recognition.dart';
// import '../ML/Recognizer.dart';
// import 'package:objectde/Util.dart';
//
// class RecognitionScreen extends StatefulWidget {
//   const RecognitionScreen({super.key});
//
//   @override
//   State<RecognitionScreen> createState() => _RecognitionScreenState();
// }
//
// class _RecognitionScreenState extends State<RecognitionScreen> {
//   CameraController? controller;
//   bool isBusy = false;
//   bool _isSwitchingCamera = false;
//   bool _isCameraInitialized = false;
//
//   late CameraDescription description;
//   CameraLensDirection camDirec = CameraLensDirection.front;
//   late List<Recognition> recognitions = [];
//
//   late FaceDetector faceDetector;
//   late Recognizer recognizer;
//   CameraImage? frame;
//   dynamic _scanResults;
//
//   final FlutterTts flutterTts = FlutterTts();
//   Set<String> _spokenNames = {};
//
//   @override
//   void initState() {
//     super.initState();
//     faceDetector = FaceDetector(
//       options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
//     );
//     recognizer = Recognizer();
//     _initializeCamera();
//
//     flutterTts.setLanguage("en-US");
//     flutterTts.setPitch(1.0);
//     flutterTts.setSpeechRate(0.5);
//   }
//
//   Future<void> _initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//       description = cameras.firstWhere(
//             (camera) => camera.lensDirection == camDirec,
//         orElse: () => cameras.first,
//       );
//
//       final newController = CameraController(
//         description,
//         ResolutionPreset.medium,
//         imageFormatGroup:
//         Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
//         enableAudio: false,
//       );
//
//       await newController.initialize();
//
//       // safely dispose old controller
//       if (controller != null) {
//         await controller!.dispose();
//       }
//
//       controller = newController;
//       _isCameraInitialized = true;
//
//       controller!.startImageStream((CameraImage image) {
//         if (!isBusy && mounted && !_isSwitchingCamera) {
//           isBusy = true;
//           frame = image;
//           doFaceDetectionOnFrame();
//         }
//       });
//
//       if (mounted) setState(() {});
//     } catch (e) {
//       debugPrint("Camera initialization error: $e");
//     }
//   }
//
//   Future<void> _toggleCameraDirection() async {
//     if (_isSwitchingCamera) return;
//     _isSwitchingCamera = true;
//     _isCameraInitialized = false;
//
//     try {
//       camDirec = camDirec == CameraLensDirection.back
//           ? CameraLensDirection.front
//           : CameraLensDirection.back;
//
//       _spokenNames.clear();
//
//       // stop and dispose current controller safely
//       if (controller != null) {
//         try {
//           await controller!.stopImageStream();
//         } catch (_) {}
//         await controller!.dispose();
//         controller = null;
//       }
//
//       if (mounted) setState(() {});
//
//       await Future.delayed(const Duration(milliseconds: 400));
//
//       await _initializeCamera();
//     } catch (e) {
//       debugPrint("Error toggling camera: $e");
//     } finally {
//       _isSwitchingCamera = false;
//       if (mounted) setState(() {});
//     }
//   }
//
//   @override
//   void dispose() {
//     try {
//       controller?.dispose();
//     } catch (_) {}
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> doFaceDetectionOnFrame() async {
//     final inputImage = getInputImage();
//     if (inputImage == null) {
//       isBusy = false;
//       return;
//     }
//
//     try {
//       final faces = await faceDetector.processImage(inputImage);
//       if (faces.isEmpty) _spokenNames.clear();
//       await performFaceRecognition(faces);
//     } catch (e) {
//       debugPrint("Face detection error: $e");
//     } finally {
//       isBusy = false;
//     }
//   }
//
//   img.Image? image;
//
//   Future<void> performFaceRecognition(List<Face> faces) async {
//     recognitions.clear();
//
//     if (frame == null) return;
//
//     image = Platform.isIOS
//         ? Util.convertBGRA8888ToImage(frame!)
//         : Util.convertNV21(frame!);
//
//     image = img.copyRotate(
//       image!,
//       angle: camDirec == CameraLensDirection.front ? 270 : 90,
//     );
//
//     for (final face in faces) {
//       final faceRect = face.boundingBox;
//       if (faceRect.width <= 0 || faceRect.height <= 0) continue;
//
//       final croppedFace = img.copyCrop(
//         image!,
//         x: faceRect.left.clamp(0, image!.width - 1).toInt(),
//         y: faceRect.top.clamp(0, image!.height - 1).toInt(),
//         width: faceRect.width.clamp(1, image!.width - faceRect.left).toInt(),
//         height: faceRect.height.clamp(1, image!.height - faceRect.top).toInt(),
//       );
//
//       final recognition = await recognizer.recognize(croppedFace, faceRect);
//
//       if (recognition.distance < 0.3) recognition.name = "Unknown";
//       recognitions.add(recognition);
//
//       if (recognition.name.isNotEmpty && !_spokenNames.contains(recognition.name)) {
//         _spokenNames.add(recognition.name);
//         await flutterTts.speak(recognition.name);
//       }
//     }
//
//     if (mounted) {
//       setState(() {
//         _scanResults = recognitions;
//       });
//     }
//   }
//
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };
//
//   InputImage? getInputImage() {
//     if (controller == null || frame == null || !controller!.value.isInitialized) {
//       return null;
//     }
//
//     final sensorOrientation = description.sensorOrientation;
//     InputImageRotation? rotation;
//
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else {
//       final rotationCompensation = _orientations[controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//
//       rotation = InputImageRotationValue.fromRawValue(
//         description.lensDirection == CameraLensDirection.front
//             ? (sensorOrientation + rotationCompensation) % 360
//             : (sensorOrientation - rotationCompensation + 360) % 360,
//       );
//     }
//
//     if (rotation == null) return null;
//     final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;
//
//     if (frame!.planes.length != 1) return null;
//     final plane = frame!.planes.first;
//
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: plane.bytesPerRow,
//       ),
//     );
//   }
//
//   Widget buildResult() {
//     if (_scanResults == null ||
//         controller == null ||
//         !controller!.value.isInitialized) {
//       return const SizedBox.shrink();
//     }
//
//     final Size imageSize = Size(
//       controller!.value.previewSize!.height,
//       controller!.value.previewSize!.width,
//     );
//
//     return CustomPaint(
//       painter: FaceDetectorPainter(imageSize, _scanResults, camDirec),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final showPreview = controller != null &&
//         controller!.value.isInitialized &&
//         !_isSwitchingCamera &&
//         _isCameraInitialized;
//
//     return WillPopScope(
//       // ✅ Added change: safely dispose camera and speak message on back
//       onWillPop: () async {
//         try {
//           await controller?.stopImageStream();
//         } catch (_) {}
//         await controller?.dispose();
//         controller = null;
//
//         Navigator.pop(context);
//
//         // Speak after returning to home screen
//         Future.delayed(const Duration(milliseconds: 500), () async {
//           await flutterTts.speak(
//             "You are in the Face Recognition module. You can say: Register face, Recognize face, or Manage faces. Which one would you like to open?",
//           );
//         });
//         return true;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.black,
//           body: Stack(
//             children: [
//               if (showPreview) Positioned.fill(child: CameraPreview(controller!)),
//               if (showPreview) Positioned.fill(child: buildResult()),
//
//               if (_isSwitchingCamera || !_isCameraInitialized)
//                 const Center(
//                   child: CircularProgressIndicator(color: Colors.deepPurple),
//                 ),
//
//               Positioned(
//                 bottom: 40,
//                 left: 20,
//                 right: 20,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurple.withAlpha(80),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.white.withOpacity(0.2)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.cached, color: Colors.white),
//                             iconSize: 40,
//                             onPressed: _toggleCameraDirection,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FaceDetectorPainter extends CustomPainter {
//   final Size absoluteImageSize;
//   final List<Recognition> faces;
//   final CameraLensDirection camDirection;
//
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDirection);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final scaleX = size.width / absoluteImageSize.width;
//     final scaleY = size.height / absoluteImageSize.height;
//
//     final boxPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.5
//       ..color = Colors.deepPurple.shade300;
//
//     final labelBgPaint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.deepPurple.shade300.withAlpha(150);
//
//     for (final face in faces) {
//       final left = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.right) * scaleX
//           : face.location.left * scaleX;
//       final top = face.location.top * scaleY;
//       final right = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.left) * scaleX
//           : face.location.right * scaleX;
//       final bottom = face.location.bottom * scaleY;
//
//       final rect = Rect.fromLTRB(left, top, right, bottom);
//       final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
//       canvas.drawRRect(rRect, boxPaint);
//
//       final label = face.name.isNotEmpty
//           ? '${face.name} (${face.distance.toStringAsFixed(2)})'
//           : 'Unknown';
//
//       final textSpan = TextSpan(
//         text: label,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       );
//
//       final textPainter =
//       TextPainter(text: textSpan, textDirection: TextDirection.ltr)
//         ..layout(maxWidth: size.width * 0.6);
//
//       final labelPadding = 6;
//       final labelX = left;
//       final labelY = top - textPainter.height - 8;
//
//       final backgroundRect = Rect.fromLTWH(
//         labelX,
//         labelY < 0 ? top + 4 : labelY,
//         textPainter.width + labelPadding * 2,
//         textPainter.height + labelPadding,
//       );
//
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(backgroundRect, const Radius.circular(8)),
//         labelBgPaint,
//       );
//
//       textPainter.paint(
//         canvas,
//         Offset(backgroundRect.left + labelPadding,
//             backgroundRect.top + labelPadding / 2),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) => true;
// }







// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;
// import 'package:flutter_tts/flutter_tts.dart';
// import '../ML/Recognition.dart';
// import '../ML/Recognizer.dart';
// import 'package:objectde/Util.dart';
//
// class RecognitionScreen extends StatefulWidget {
//   const RecognitionScreen({super.key});
//
//   @override
//   State<RecognitionScreen> createState() => _RecognitionScreenState();
// }
//
// class _RecognitionScreenState extends State<RecognitionScreen> {
//   CameraController? controller;
//   bool isBusy = false;
//   bool _isSwitchingCamera = false;
//   bool _isCameraInitialized = false;
//
//   late CameraDescription description;
//   CameraLensDirection camDirec = CameraLensDirection.front;
//   late List<Recognition> recognitions = [];
//
//   late FaceDetector faceDetector;
//   late Recognizer recognizer;
//   CameraImage? frame;
//   dynamic _scanResults;
//
//   final FlutterTts flutterTts = FlutterTts();
//   Set<String> _spokenNames = {};
//
//   @override
//   void initState() {
//     super.initState();
//     faceDetector = FaceDetector(
//       options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
//     );
//     recognizer = Recognizer();
//     _initializeCamera();
//
//     flutterTts.setLanguage("en-US");
//     flutterTts.setPitch(1.0);
//     flutterTts.setSpeechRate(0.5);
//   }
//
//   Future<void> _initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//       description = cameras.firstWhere(
//             (camera) => camera.lensDirection == camDirec,
//         orElse: () => cameras.first,
//       );
//
//       final newController = CameraController(
//         description,
//         ResolutionPreset.medium,
//         imageFormatGroup:
//         Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
//         enableAudio: false,
//       );
//
//       await newController.initialize();
//
//       // ✅ Safely dispose old controller if any
//       if (controller != null) {
//         await controller!.dispose();
//       }
//
//       controller = newController;
//       _isCameraInitialized = true;
//
//       controller!.startImageStream((CameraImage image) {
//         if (!isBusy && mounted && !_isSwitchingCamera) {
//           isBusy = true;
//           frame = image;
//           doFaceDetectionOnFrame();
//         }
//       });
//
//       if (mounted) setState(() {});
//     } catch (e) {
//       debugPrint("Camera initialization error: $e");
//     }
//   }
//
//   Future<void> _toggleCameraDirection() async {
//     if (_isSwitchingCamera) return;
//     _isSwitchingCamera = true;
//     _isCameraInitialized = false;
//
//     try {
//       camDirec = camDirec == CameraLensDirection.back
//           ? CameraLensDirection.front
//           : CameraLensDirection.back;
//
//       _spokenNames.clear();
//
//       // ✅ Stop and safely dispose current controller
//       if (controller != null) {
//         try {
//           await controller!.stopImageStream();
//         } catch (_) {}
//         await controller!.dispose();
//         controller = null;
//       }
//
//       if (mounted) setState(() {});
//
//       await Future.delayed(const Duration(milliseconds: 400));
//
//       await _initializeCamera();
//     } catch (e) {
//       debugPrint("Error toggling camera: $e");
//     } finally {
//       _isSwitchingCamera = false;
//       if (mounted) setState(() {});
//     }
//   }
//
//   @override
//   void dispose() {
//     try {
//       controller?.dispose();
//     } catch (_) {}
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> doFaceDetectionOnFrame() async {
//     final inputImage = getInputImage();
//     if (inputImage == null) {
//       isBusy = false;
//       return;
//     }
//
//     try {
//       final faces = await faceDetector.processImage(inputImage);
//       if (faces.isEmpty) _spokenNames.clear();
//       await performFaceRecognition(faces);
//     } catch (e) {
//       debugPrint("Face detection error: $e");
//     } finally {
//       isBusy = false;
//     }
//   }
//
//   img.Image? image;
//
//   Future<void> performFaceRecognition(List<Face> faces) async {
//     recognitions.clear();
//
//     if (frame == null) return;
//
//     image = Platform.isIOS
//         ? Util.convertBGRA8888ToImage(frame!)
//         : Util.convertNV21(frame!);
//
//     image = img.copyRotate(
//       image!,
//       angle: camDirec == CameraLensDirection.front ? 270 : 90,
//     );
//
//     for (final face in faces) {
//       final faceRect = face.boundingBox;
//       if (faceRect.width <= 0 || faceRect.height <= 0) continue;
//
//       final croppedFace = img.copyCrop(
//         image!,
//         x: faceRect.left.clamp(0, image!.width - 1).toInt(),
//         y: faceRect.top.clamp(0, image!.height - 1).toInt(),
//         width: faceRect.width.clamp(1, image!.width - faceRect.left).toInt(),
//         height: faceRect.height.clamp(1, image!.height - faceRect.top).toInt(),
//       );
//
//       final recognition = await recognizer.recognize(croppedFace, faceRect);
//
//       if (recognition.distance < 0.3) recognition.name = "Unknown";
//       recognitions.add(recognition);
//
//       if (recognition.name.isNotEmpty && !_spokenNames.contains(recognition.name)) {
//         _spokenNames.add(recognition.name);
//         await flutterTts.speak(recognition.name);
//       }
//     }
//
//     if (mounted) {
//       setState(() {
//         _scanResults = recognitions;
//       });
//     }
//   }
//
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };
//
//   InputImage? getInputImage() {
//     if (controller == null || frame == null || !controller!.value.isInitialized) {
//       return null;
//     }
//
//     final sensorOrientation = description.sensorOrientation;
//     InputImageRotation? rotation;
//
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else {
//       final rotationCompensation = _orientations[controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//
//       rotation = InputImageRotationValue.fromRawValue(
//         description.lensDirection == CameraLensDirection.front
//             ? (sensorOrientation + rotationCompensation) % 360
//             : (sensorOrientation - rotationCompensation + 360) % 360,
//       );
//     }
//
//     if (rotation == null) return null;
//     final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;
//
//     if (frame!.planes.length != 1) return null;
//     final plane = frame!.planes.first;
//
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: plane.bytesPerRow,
//       ),
//     );
//   }
//
//   Widget buildResult() {
//     if (_scanResults == null ||
//         controller == null ||
//         !controller!.value.isInitialized) {
//       return const SizedBox.shrink();
//     }
//
//     final Size imageSize = Size(
//       controller!.value.previewSize!.height,
//       controller!.value.previewSize!.width,
//     );
//
//     return CustomPaint(
//       painter: FaceDetectorPainter(imageSize, _scanResults, camDirec),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final showPreview = controller != null &&
//         controller!.value.isInitialized &&
//         !_isSwitchingCamera &&
//         _isCameraInitialized;
//
//     return WillPopScope(
//       // ✅ Updated: only safely dispose, no TTS
//       onWillPop: () async {
//         try {
//           await controller?.stopImageStream();
//         } catch (_) {}
//         await controller?.dispose();
//         controller = null;
//
//         Navigator.pop(context);
//         return true; // ✅ only dispose safely, no speech
//       },
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.black,
//           body: Stack(
//             children: [
//               if (showPreview) Positioned.fill(child: CameraPreview(controller!)),
//               if (showPreview) Positioned.fill(child: buildResult()),
//
//               if (_isSwitchingCamera || !_isCameraInitialized)
//                 const Center(
//                   child: CircularProgressIndicator(color: Colors.deepPurple),
//                 ),
//
//               Positioned(
//                 bottom: 40,
//                 left: 20,
//                 right: 20,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurple.withAlpha(80),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.white.withOpacity(0.2)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.cached, color: Colors.white),
//                             iconSize: 40,
//                             onPressed: _toggleCameraDirection,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FaceDetectorPainter extends CustomPainter {
//   final Size absoluteImageSize;
//   final List<Recognition> faces;
//   final CameraLensDirection camDirection;
//
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDirection);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final scaleX = size.width / absoluteImageSize.width;
//     final scaleY = size.height / absoluteImageSize.height;
//
//     final boxPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.5
//       ..color = Colors.deepPurple.shade300;
//
//     final labelBgPaint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.deepPurple.shade300.withAlpha(150);
//
//     for (final face in faces) {
//       final left = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.right) * scaleX
//           : face.location.left * scaleX;
//       final top = face.location.top * scaleY;
//       final right = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.left) * scaleX
//           : face.location.right * scaleX;
//       final bottom = face.location.bottom * scaleY;
//
//       final rect = Rect.fromLTRB(left, top, right, bottom);
//       final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
//       canvas.drawRRect(rRect, boxPaint);
//
//       final label = face.name.isNotEmpty
//           ? '${face.name} (${face.distance.toStringAsFixed(2)})'
//           : 'Unknown';
//
//       final textSpan = TextSpan(
//         text: label,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       );
//
//       final textPainter =
//       TextPainter(text: textSpan, textDirection: TextDirection.ltr)
//         ..layout(maxWidth: size.width * 0.6);
//
//       final labelPadding = 6;
//       final labelX = left;
//       final labelY = top - textPainter.height - 8;
//
//       final backgroundRect = Rect.fromLTWH(
//         labelX,
//         labelY < 0 ? top + 4 : labelY,
//         textPainter.width + labelPadding * 2,
//         textPainter.height + labelPadding,
//       );
//
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(backgroundRect, const Radius.circular(8)),
//         labelBgPaint,
//       );
//
//       textPainter.paint(
//         canvas,
//         Offset(backgroundRect.left + labelPadding,
//             backgroundRect.top + labelPadding / 2),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) => true;
// }




// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;
// import 'package:flutter_tts/flutter_tts.dart';
// import '../ML/Recognition.dart';
// import '../ML/Recognizer.dart';
// import 'package:objectde/Util.dart';
// import 'package:flutter/services.dart';
// class RecognitionScreen extends StatefulWidget {
//   const RecognitionScreen({super.key});
//
//   @override
//   State<RecognitionScreen> createState() => _RecognitionScreenState();
// }
//
// class _RecognitionScreenState extends State<RecognitionScreen> {
//   CameraController? controller;
//   bool isBusy = false;
//   bool _isSwitchingCamera = false;
//   bool _isCameraInitialized = false;
//   bool _disposed = false; // ✅ Track if widget is disposed
//
//   late CameraDescription description;
//   CameraLensDirection camDirec = CameraLensDirection.front;
//   late List<Recognition> recognitions = [];
//
//   late FaceDetector faceDetector;
//   late Recognizer recognizer;
//   CameraImage? frame;
//   dynamic _scanResults;
//
//   final FlutterTts flutterTts = FlutterTts();
//   Set<String> _spokenNames = {};
//
//   @override
//   void initState() {
//     super.initState();
//     faceDetector = FaceDetector(
//       options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
//     );
//     recognizer = Recognizer();
//     _initializeCamera();
//
//     flutterTts.setLanguage("en-US");
//     flutterTts.setPitch(1.0);
//     flutterTts.setSpeechRate(0.5);
//   }
//
//   Future<void> _initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//       description = cameras.firstWhere(
//             (camera) => camera.lensDirection == camDirec,
//         orElse: () => cameras.first,
//       );
//
//       final newController = CameraController(
//         description,
//         ResolutionPreset.medium,
//         imageFormatGroup:
//         Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
//         enableAudio: false,
//       );
//
//       await newController.initialize();
//
//       if (_disposed) return;
//
//       await _disposeCamera(); // Dispose old controller if any
//
//       controller = newController;
//       _isCameraInitialized = true;
//
//       controller!.startImageStream((CameraImage image) {
//         if (!isBusy && mounted && !_isSwitchingCamera && !_disposed) {
//           isBusy = true;
//           frame = image;
//           doFaceDetectionOnFrame();
//         }
//       });
//
//       if (mounted && !_disposed) setState(() {});
//     } catch (e) {
//       debugPrint("Camera initialization error: $e");
//     }
//   }
//
//   Future<void> _toggleCameraDirection() async {
//     if (_isSwitchingCamera || _disposed) return;
//     _isSwitchingCamera = true;
//     _isCameraInitialized = false;
//
//     try {
//       camDirec = camDirec == CameraLensDirection.back
//           ? CameraLensDirection.front
//           : CameraLensDirection.back;
//
//       _spokenNames.clear();
//
//       await _disposeCamera();
//
//       if (mounted && !_disposed) setState(() {});
//
//       await Future.delayed(const Duration(milliseconds: 400));
//
//       await _initializeCamera();
//     } catch (e) {
//       debugPrint("Error toggling camera: $e");
//     } finally {
//       _isSwitchingCamera = false;
//       if (mounted && !_disposed) setState(() {});
//     }
//   }
//
//   /// ✅ Safely stop camera stream and dispose
//   Future<void> _disposeCamera() async {
//     if (controller != null) {
//       try {
//         await controller!.stopImageStream();
//       } catch (_) {}
//       try {
//         await controller!.dispose();
//       } catch (_) {}
//       controller = null;
//       _isCameraInitialized = false;
//     }
//   }
//
//   @override
//   void dispose() {
//     _disposed = true;
//     _disposeCamera();
//     flutterTts.stop();
//     super.dispose();
//   }
//
//   Future<void> doFaceDetectionOnFrame() async {
//     if (_disposed) return;
//
//     final inputImage = getInputImage();
//     if (inputImage == null) {
//       isBusy = false;
//       return;
//     }
//
//     try {
//       final faces = await faceDetector.processImage(inputImage);
//       if (faces.isEmpty) _spokenNames.clear();
//       await performFaceRecognition(faces);
//     } catch (e) {
//       debugPrint("Face detection error: $e");
//     } finally {
//       isBusy = false;
//     }
//   }
//
//   img.Image? image;
//
//   Future<void> performFaceRecognition(List<Face> faces) async {
//     if (_disposed) return;
//
//     recognitions.clear();
//     if (frame == null) return;
//
//     image = Platform.isIOS
//         ? Util.convertBGRA8888ToImage(frame!)
//         : Util.convertNV21(frame!);
//
//     image = img.copyRotate(
//       image!,
//       angle: camDirec == CameraLensDirection.front ? 270 : 90,
//     );
//
//     for (final face in faces) {
//       final faceRect = face.boundingBox;
//       if (faceRect.width <= 0 || faceRect.height <= 0) continue;
//
//       final croppedFace = img.copyCrop(
//         image!,
//         x: faceRect.left.clamp(0, image!.width - 1).toInt(),
//         y: faceRect.top.clamp(0, image!.height - 1).toInt(),
//         width: faceRect.width.clamp(1, image!.width - faceRect.left).toInt(),
//         height: faceRect.height.clamp(1, image!.height - faceRect.top).toInt(),
//       );
//
//       final recognition = await recognizer.recognize(croppedFace, faceRect);
//
//       if (recognition.distance < 0.3) recognition.name = "Unknown";
//       recognitions.add(recognition);
//
//       if (!_disposed &&
//           recognition.name.isNotEmpty &&
//           !_spokenNames.contains(recognition.name)) {
//         _spokenNames.add(recognition.name);
//         await flutterTts.speak(recognition.name);
//       }
//     }
//
//     if (mounted && !_disposed) {
//       setState(() {
//         _scanResults = recognitions;
//       });
//     }
//   }
//
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };
//
//   InputImage? getInputImage() {
//     if (_disposed || controller == null || frame == null || !controller!.value.isInitialized) {
//       return null;
//     }
//
//     final sensorOrientation = description.sensorOrientation;
//     InputImageRotation? rotation;
//
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else {
//       final rotationCompensation = _orientations[controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//
//       rotation = InputImageRotationValue.fromRawValue(
//         description.lensDirection == CameraLensDirection.front
//             ? (sensorOrientation + rotationCompensation) % 360
//             : (sensorOrientation - rotationCompensation + 360) % 360,
//       );
//     }
//
//     if (rotation == null) return null;
//     final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;
//
//     if (frame!.planes.length != 1) return null;
//     final plane = frame!.planes.first;
//
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: plane.bytesPerRow,
//       ),
//     );
//   }
//
//   Widget buildResult() {
//     if (_disposed ||
//         _scanResults == null ||
//         controller == null ||
//         !controller!.value.isInitialized) {
//       return const SizedBox.shrink();
//     }
//
//     final Size imageSize = Size(
//       controller!.value.previewSize!.height,
//       controller!.value.previewSize!.width,
//     );
//
//     return CustomPaint(
//       painter: FaceDetectorPainter(imageSize, _scanResults, camDirec),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_disposed) return const SizedBox.shrink();
//
//     final showPreview = controller != null &&
//         controller!.value.isInitialized &&
//         !_isSwitchingCamera &&
//         _isCameraInitialized;
//
//     return WillPopScope(
//       onWillPop: () async {
//         _disposed = true;
//         await _disposeCamera();
//         await flutterTts.stop();
//         return true;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.black,
//           body: Stack(
//             children: [
//               if (showPreview && controller != null)
//                 Positioned.fill(child: CameraPreview(controller!)),
//               if (showPreview) Positioned.fill(child: buildResult()),
//
//               if (_isSwitchingCamera || !_isCameraInitialized)
//                 const Center(
//                   child: CircularProgressIndicator(color: Colors.deepPurple),
//                 ),
//
//               Positioned(
//                 bottom: 40,
//                 left: 20,
//                 right: 20,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurple.withAlpha(80),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.white.withOpacity(0.2)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.cached, color: Colors.white),
//                             iconSize: 40,
//                             onPressed: _toggleCameraDirection,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FaceDetectorPainter extends CustomPainter {
//   final Size absoluteImageSize;
//   final List<Recognition> faces;
//   final CameraLensDirection camDirection;
//
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDirection);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final scaleX = size.width / absoluteImageSize.width;
//     final scaleY = size.height / absoluteImageSize.height;
//
//     final boxPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.5
//       ..color = Colors.deepPurple.shade300;
//
//     final labelBgPaint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.deepPurple.shade300.withAlpha(150);
//
//     for (final face in faces) {
//       final left = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.right) * scaleX
//           : face.location.left * scaleX;
//       final top = face.location.top * scaleY;
//       final right = camDirection == CameraLensDirection.front
//           ? (absoluteImageSize.width - face.location.left) * scaleX
//           : face.location.right * scaleX;
//       final bottom = face.location.bottom * scaleY;
//
//       final rect = Rect.fromLTRB(left, top, right, bottom);
//       final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
//       canvas.drawRRect(rRect, boxPaint);
//
//       final label = face.name.isNotEmpty
//           ? '${face.name} (${face.distance.toStringAsFixed(2)})'
//           : 'Unknown';
//
//       final textSpan = TextSpan(
//         text: label,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       );
//
//       final textPainter =
//       TextPainter(text: textSpan, textDirection: TextDirection.ltr)
//         ..layout(maxWidth: size.width * 0.6);
//
//       final labelPadding = 6;
//       final labelX = left;
//       final labelY = top - textPainter.height - 8;
//
//       final backgroundRect = Rect.fromLTWH(
//         labelX,
//         labelY < 0 ? top + 4 : labelY,
//         textPainter.width + labelPadding * 2,
//         textPainter.height + labelPadding,
//       );
//
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(backgroundRect, const Radius.circular(8)),
//         labelBgPaint,
//       );
//
//       textPainter.paint(
//         canvas,
//         Offset(backgroundRect.left + labelPadding,
//             backgroundRect.top + labelPadding / 2),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) => true;
// }






import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_tts/flutter_tts.dart';
import '../ML/Recognition.dart';
import '../ML/Recognizer.dart';
import 'package:objectde/Util.dart';
import 'package:flutter/services.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  CameraController? controller;
  bool isBusy = false;
  bool _isSwitchingCamera = false;
  bool _isCameraInitialized = false;
  bool _disposed = false;

  late CameraDescription description;
  CameraLensDirection camDirec = CameraLensDirection.front;
  late List<Recognition> recognitions = [];

  late FaceDetector faceDetector;
  late Recognizer recognizer;
  CameraImage? frame;
  dynamic _scanResults;

  final FlutterTts flutterTts = FlutterTts();
  Set<String> _spokenNames = {};

  @override
  void initState() {
    super.initState();

    faceDetector = FaceDetector(
      options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
    );
    recognizer = Recognizer();

    flutterTts.setLanguage("en-US");
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.5);

    /// ✅ NEW: Announce screen on entry
    flutterTts.speak("You are in the face detection screen");

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      description = cameras.firstWhere(
            (camera) => camera.lensDirection == camDirec,
        orElse: () => cameras.first,
      );

      final newController = CameraController(
        description,
        ResolutionPreset.medium,
        imageFormatGroup:
        Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
        enableAudio: false,
      );

      await newController.initialize();

      if (_disposed) return;

      await _disposeCamera();

      controller = newController;
      _isCameraInitialized = true;

      controller!.startImageStream((CameraImage image) {
        if (!isBusy && mounted && !_isSwitchingCamera && !_disposed) {
          isBusy = true;
          frame = image;
          doFaceDetectionOnFrame();
        }
      });

      if (mounted && !_disposed) setState(() {});
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    }
  }

  Future<void> _toggleCameraDirection() async {
    if (_isSwitchingCamera || _disposed) return;
    _isSwitchingCamera = true;
    _isCameraInitialized = false;

    try {
      camDirec = camDirec == CameraLensDirection.back
          ? CameraLensDirection.front
          : CameraLensDirection.back;

      _spokenNames.clear();

      await _disposeCamera();

      if (mounted && !_disposed) setState(() {});

      await Future.delayed(const Duration(milliseconds: 400));

      await _initializeCamera();
    } catch (e) {
      debugPrint("Error toggling camera: $e");
    } finally {
      _isSwitchingCamera = false;
      if (mounted && !_disposed) setState(() {});
    }
  }

  Future<void> _disposeCamera() async {
    if (controller != null) {
      try {
        await controller!.stopImageStream();
      } catch (_) {}
      try {
        await controller!.dispose();
      } catch (_) {}
      controller = null;
      _isCameraInitialized = false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _disposeCamera();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> doFaceDetectionOnFrame() async {
    if (_disposed) return;

    final inputImage = getInputImage();
    if (inputImage == null) {
      isBusy = false;
      return;
    }

    try {
      final faces = await faceDetector.processImage(inputImage);
      if (faces.isEmpty) _spokenNames.clear();
      await performFaceRecognition(faces);
    } catch (e) {
      debugPrint("Face detection error: $e");
    } finally {
      isBusy = false;
    }
  }

  img.Image? image;

  Future<void> performFaceRecognition(List<Face> faces) async {
    if (_disposed) return;

    recognitions.clear();
    if (frame == null) return;

    image = Platform.isIOS
        ? Util.convertBGRA8888ToImage(frame!)
        : Util.convertNV21(frame!);

    image = img.copyRotate(
      image!,
      angle: camDirec == CameraLensDirection.front ? 270 : 90,
    );

    for (final face in faces) {
      final faceRect = face.boundingBox;
      if (faceRect.width <= 0 || faceRect.height <= 0) continue;

      final croppedFace = img.copyCrop(
        image!,
        x: faceRect.left.clamp(0, image!.width - 1).toInt(),
        y: faceRect.top.clamp(0, image!.height - 1).toInt(),
        width: faceRect.width.clamp(1, image!.width - faceRect.left).toInt(),
        height: faceRect.height.clamp(1, image!.height - faceRect.top).toInt(),
      );

      final recognition = await recognizer.recognize(croppedFace, faceRect);

      if (recognition.distance < 0.3) {
        recognition.name = "Unknown";
      }

      recognitions.add(recognition);

      if (!_disposed &&
          recognition.name.isNotEmpty &&
          !_spokenNames.contains(recognition.name)) {
        _spokenNames.add(recognition.name);
        await flutterTts.speak(recognition.name);
      }
    }

    if (mounted && !_disposed) {
      setState(() {
        _scanResults = recognitions;
      });
    }
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? getInputImage() {
    if (_disposed ||
        controller == null ||
        frame == null ||
        !controller!.value.isInitialized) {
      return null;
    }

    final sensorOrientation = description.sensorOrientation;
    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else {
      final rotationCompensation =
      _orientations[controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;

      rotation = InputImageRotationValue.fromRawValue(
        description.lensDirection == CameraLensDirection.front
            ? (sensorOrientation + rotationCompensation) % 360
            : (sensorOrientation - rotationCompensation + 360) % 360,
      );
    }

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    if (frame!.planes.length != 1) return null;

    final plane = frame!.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  Widget buildResult() {
    if (_disposed ||
        _scanResults == null ||
        controller == null ||
        !controller!.value.isInitialized) {
      return const SizedBox.shrink();
    }

    final Size imageSize = Size(
      controller!.value.previewSize!.height,
      controller!.value.previewSize!.width,
    );

    return CustomPaint(
      painter: FaceDetectorPainter(imageSize, _scanResults, camDirec),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_disposed) return const SizedBox.shrink();

    final showPreview = controller != null &&
        controller!.value.isInitialized &&
        !_isSwitchingCamera &&
        _isCameraInitialized;

    return WillPopScope(
      onWillPop: () async {
        _disposed = true;
        await _disposeCamera();
        await flutterTts.stop();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              if (showPreview && controller != null)
                Positioned.fill(child: CameraPreview(controller!)),
              if (showPreview) Positioned.fill(child: buildResult()),

              if (_isSwitchingCamera || !_isCameraInitialized)
                const Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple),
                ),

              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withAlpha(80),
                        borderRadius: BorderRadius.circular(20),
                        border:
                        Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon:
                            const Icon(Icons.cached, color: Colors.white),
                            iconSize: 40,
                            onPressed: _toggleCameraDirection,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FaceDetectorPainter extends CustomPainter {
  final Size absoluteImageSize;
  final List<Recognition> faces;
  final CameraLensDirection camDirection;

  FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDirection);

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / absoluteImageSize.width;
    final scaleY = size.height / absoluteImageSize.height;

    final boxPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = Colors.deepPurple.shade300;

    final labelBgPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.deepPurple.shade300.withAlpha(150);

    for (final face in faces) {
      final left = camDirection == CameraLensDirection.front
          ? (absoluteImageSize.width - face.location.right) * scaleX
          : face.location.left * scaleX;
      final top = face.location.top * scaleY;
      final right = camDirection == CameraLensDirection.front
          ? (absoluteImageSize.width - face.location.left) * scaleX
          : face.location.right * scaleX;
      final bottom = face.location.bottom * scaleY;

      final rect = Rect.fromLTRB(left, top, right, bottom);
      final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
      canvas.drawRRect(rRect, boxPaint);

      final label = face.name.isNotEmpty
          ? '${face.name} (${face.distance.toStringAsFixed(2)})'
          : 'Unknown';

      final textSpan = TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );

      final textPainter =
      TextPainter(text: textSpan, textDirection: TextDirection.ltr)
        ..layout(maxWidth: size.width * 0.6);

      final labelPadding = 6;
      final labelX = left;
      final labelY = top - textPainter.height - 8;

      final backgroundRect = Rect.fromLTWH(
        labelX,
        labelY < 0 ? top + 4 : labelY,
        textPainter.width + labelPadding * 2,
        textPainter.height + labelPadding,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(backgroundRect, const Radius.circular(8)),
        labelBgPaint,
      );

      textPainter.paint(
        canvas,
        Offset(backgroundRect.left + labelPadding,
            backgroundRect.top + labelPadding / 2),
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) => true;
}
