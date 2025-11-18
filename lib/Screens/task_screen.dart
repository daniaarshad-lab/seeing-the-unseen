// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_tts/flutter_tts.dart';
//
// class TaskScreen extends StatefulWidget {
//   const TaskScreen({super.key});
//
//   @override
//   State<TaskScreen> createState() => _TaskScreenState();
// }
//
// class _TaskScreenState extends State<TaskScreen> {
//   final SpeechToText _speech = SpeechToText();
//   final FlutterTts _tts = FlutterTts();
//
//   bool _isListening = false;
//   bool _isLoading = false;
//   String _recognizedText = '';
//   String _responseText = 'Say something like "add a task" or "delete a task"';
//   List tasks = [];
//   String? _pendingAction;
//   final String _baseUrl = 'http://127.0.0.1:8000'; // your backend IP
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchTasks();
//   }
//
//   Future<void> _fetchTasks() async {
//     try {
//       final res = await http.get(Uri.parse('$_baseUrl/api/tasks'));
//       if (res.statusCode == 200) {
//         final data = json.decode(res.body);
//         setState(() => tasks = data['tasks'] ?? []);
//       }
//     } catch (e) {
//       setState(() => _responseText = '⚠️ Could not load tasks: $e');
//     }
//   }
//
//   Future<void> _toggleMic() async {
//     if (!_isListening) {
//       bool available = await _speech.initialize();
//       if (available) {
//         setState(() {
//           _isListening = true;
//           _responseText = "Listening...";
//         });
//         _speech.listen(onResult: (result) {
//           setState(() => _recognizedText = result.recognizedWords);
//         });
//       } else {
//         setState(() => _responseText = "Speech not available.");
//       }
//     } else {
//       _speech.stop();
//       setState(() => _isListening = false);
//
//       if (_recognizedText.trim().isEmpty) {
//         setState(() => _responseText = "No speech detected.");
//         return;
//       }
//
//       if (_pendingAction == 'add') {
//         await _addTaskByVoice(_recognizedText);
//         _pendingAction = null;
//       } else if (_pendingAction == 'delete') {
//         await _deleteTaskByVoice(_recognizedText);
//         _pendingAction = null;
//       } else {
//         await _processCommand(_recognizedText);
//       }
//     }
//   }
//
//   Future<void> _processCommand(String command) async {
//     setState(() => _isLoading = true);
//     try {
//       final response = await http.post(
//         Uri.parse('$_baseUrl/api/tasks/command'),
//         body: {'command': command},
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         String msg = data['response'] ?? 'No response.';
//         String? cmd = data['command'];
//
//         setState(() => _responseText = msg);
//         await _tts.speak(msg);
//
//         if (cmd == 'add') {
//           _pendingAction = 'add';
//         } else if (cmd == 'delete') {
//           _pendingAction = 'delete';
//         }
//
//         await _fetchTasks();
//       } else {
//         setState(() => _responseText = 'Error ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() => _responseText = '⚠️ Error: $e');
//     }
//     setState(() => _isLoading = false);
//   }
//
//   Future<void> _addTaskByVoice(String title) async {
//     setState(() => _isLoading = true);
//     try {
//       final res = await http.post(
//         Uri.parse('$_baseUrl/api/tasks/command/add'),
//         body: {'task_title': title},
//       );
//       final data = json.decode(res.body);
//       String msg = data['response'] ?? 'Task added.';
//       setState(() => _responseText = msg);
//       await _tts.speak(msg);
//       await _fetchTasks();
//     } catch (e) {
//       setState(() => _responseText = '⚠️ Error adding: $e');
//     }
//     setState(() => _isLoading = false);
//   }
//
//   Future<void> _deleteTaskByVoice(String name) async {
//     setState(() => _isLoading = true);
//     try {
//       final res = await http.post(
//         Uri.parse('$_baseUrl/api/tasks/command/delete'),
//         body: {'task_name': name},
//       );
//       final data = json.decode(res.body);
//       String msg = data['response'] ?? 'Task deleted.';
//       setState(() => _responseText = msg);
//       await _tts.speak(msg);
//       await _fetchTasks();
//     } catch (e) {
//       setState(() => _responseText = '⚠️ Error deleting: $e');
//     }
//     setState(() => _isLoading = false);
//   }
//
//   @override
//   void dispose() {
//     _speech.stop();
//     _tts.stop();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double micSize = 90;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Task Voice Assistant'),
//         // backgroundColor: Colors.blueAccent,
//         backgroundColor: Colors.deepPurple,
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Main column layout
//             Column(
//               children: [
//                 // Response text
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Text(
//                     _responseText,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       color: Colors.black87,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//
//                 // Task list (cards from top)
//                 Expanded(
//                   child: ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     itemCount: tasks.length,
//                     itemBuilder: (context, idx) {
//                       final task = tasks[idx];
//                       return Card(
//                         elevation: 4,
//                         margin: const EdgeInsets.symmetric(vertical: 6),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ListTile(
//                           title: Text(
//                             task['title'] ?? '',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.redAccent),
//                             onPressed: () => _deleteTaskByVoice(task['title']),
//                           ),
//                           onTap: () => _tts.speak(task['title']),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 120), // space for mic
//               ],
//             ),
//
//             // Mic button bottom center
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 30),
//                 child: GestureDetector(
//                   onTap: _toggleMic,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     height: micSize,
//                     width: micSize,
//                     decoration: BoxDecoration(
//                       color: _isListening ? Colors.redAccent : Colors.blueAccent,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: _isListening
//                               ? Colors.redAccent.withOpacity(0.4)
//                               : Colors.blueAccent.withOpacity(0.4),
//                           blurRadius: 20,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       _isListening ? Icons.mic : Icons.mic_none,
//                       color: Colors.white,
//                       size: 45,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             if (_isLoading)
//               const Center(
//                 child: CircularProgressIndicator(color: Colors.blueAccent),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool _isListening = false;
  bool _isLoading = false;
  String _recognizedText = '';
  String _responseText = 'Say something like "add a task" or "delete a task"';
  List tasks = [];
  String? _pendingAction;
  final String _baseUrl = 'http://127.0.0.1:8000'; // your backend IP

  @override
  void initState() {
    super.initState();
    _announceScreenEntry(); // ✅ Added: speak when entering Task Management screen
    _fetchTasks();
  }

  // ✅ Added: Announces when user enters this screen
  Future<void> _announceScreenEntry() async {
    await _tts.setLanguage("en-US");
    await _tts.setPitch(1.0);
    await _tts.speak("You are in the Task Management screen");
  }

  Future<void> _fetchTasks() async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/api/tasks'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() => tasks = data['tasks'] ?? []);
      }
    } catch (e) {
      setState(() => _responseText = '⚠️ Could not load tasks: $e');
    }
  }

  Future<void> _toggleMic() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _responseText = "Listening...";
        });
        _speech.listen(onResult: (result) {
          setState(() => _recognizedText = result.recognizedWords);
        });
      } else {
        setState(() => _responseText = "Speech not available.");
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);

      if (_recognizedText.trim().isEmpty) {
        setState(() => _responseText = "No speech detected.");
        return;
      }

      if (_pendingAction == 'add') {
        await _addTaskByVoice(_recognizedText);
        _pendingAction = null;
      } else if (_pendingAction == 'delete') {
        await _deleteTaskByVoice(_recognizedText);
        _pendingAction = null;
      } else {
        await _processCommand(_recognizedText);
      }
    }
  }

  Future<void> _processCommand(String command) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/tasks/command'),
        body: {'command': command},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String msg = data['response'] ?? 'No response.';
        String? cmd = data['command'];

        setState(() => _responseText = msg);
        await _tts.speak(msg);

        if (cmd == 'add') {
          _pendingAction = 'add';
        } else if (cmd == 'delete') {
          _pendingAction = 'delete';
        }

        await _fetchTasks();
      } else {
        setState(() => _responseText = 'Error ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _responseText = '⚠️ Error: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _addTaskByVoice(String title) async {
    setState(() => _isLoading = true);
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/api/tasks/command/add'),
        body: {'task_title': title},
      );
      final data = json.decode(res.body);
      String msg = data['response'] ?? 'Task added.';
      setState(() => _responseText = msg);
      await _tts.speak(msg);
      await _fetchTasks();
    } catch (e) {
      setState(() => _responseText = '⚠️ Error adding: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _deleteTaskByVoice(String name) async {
    setState(() => _isLoading = true);
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/api/tasks/command/delete'),
        body: {'task_name': name},
      );
      final data = json.decode(res.body);
      String msg = data['response'] ?? 'Task deleted.';
      setState(() => _responseText = msg);
      await _tts.speak(msg);
      await _fetchTasks();
    } catch (e) {
      setState(() => _responseText = '⚠️ Error deleting: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop(); // ✅ Added: Stop any ongoing TTS when leaving
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double micSize = 90;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Task Voice Assistant'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _responseText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    itemCount: tasks.length,
                    itemBuilder: (context, idx) {
                      final task = tasks[idx];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            task['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _deleteTaskByVoice(task['title']),
                          ),
                          onTap: () => _tts.speak(task['title']),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTap: _toggleMic,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: micSize,
                    width: micSize,
                    decoration: BoxDecoration(
                      color: _isListening ? Colors.redAccent : Colors.blueAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _isListening
                              ? Colors.redAccent.withOpacity(0.4)
                              : Colors.blueAccent.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                      size: 45,
                    ),
                  ),
                ),
              ),
            ),

            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              ),
          ],
        ),
      ),
    );
  }
}
