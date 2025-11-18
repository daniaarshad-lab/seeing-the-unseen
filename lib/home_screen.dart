import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:objectde/realtime_detectionScreen.dart';
import 'package:objectde/video_detection.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key,});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  late CameraDescription _camera;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _camera = cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'),
      centerTitle: true,
      ),
      body: Column(
        children: [

          

          SizedBox(
            height: 52,
            width: MediaQuery.of(context).size.width*.7,
            child: ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> RealTimeDetecion(camera: _camera,)));},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Realtime Detection', style: TextStyle(color: Colors.white, fontSize: 20),),),
          ),

          const SizedBox(height: 30,),
          SizedBox(
            height: 52,
            width: MediaQuery.of(context).size.width*.7,
            child: ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> const VideoDetection()));},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Video Detection', style: TextStyle(color: Colors.white, fontSize: 20)),),
          )
        ],
      )
    );
  }
}