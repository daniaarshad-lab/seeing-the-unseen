// class MyRoutes {
//   static String uploadpage = '/upload';
//   static String home = '/';
// }

// import 'package:flutter/material.dart';
// import '../pages/upload.dart';
// import '../pages/ocr.dart';
//
// class MyRoutes {
//   static String home = '/';               // now points to OCR
//   static String uploadpage = '/upload';
//   static String ocrpage = '/ocr';
//
//   static Map<String, WidgetBuilder> getRoutes() {
//     return {
//       home: (context) => OCRPage(),       // 👈 set OCR as the home page
//       uploadpage: (context) => UploadPage(),
//       ocrpage: (context) => OCRPage(),
//     };
//   }
// }


import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/ocr.dart';
import '../pages/upload.dart';
import '../helpers/scan.dart'; // Assuming it's in helpers
// import '../objectde/objectdetection.dart';
import '../objectdetection.dart';

class MyRoutes {
  static String home = '/'; // opens HomePage
  static String objectDetection = '/object';
  static String ocrpage = '/ocr';
  static String uploadpage = '/upload';
  static String scanpage = '/scan';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => HomePage(),
      objectDetection: (context) => ObjectDetectionScreen(),
      ocrpage: (context) => OCRPage(),
      uploadpage: (context) => UploadPage(),
      scanpage: (context) => ScanPage(),
    };
  }
}
