import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  factory TextToSpeechService() => _instance;
  TextToSpeechService._internal();

  final FlutterTts _flutterTts = FlutterTts();

  Future<void> speak(
      String text, {
        String language = "en-US",
        double pitch = 1.0,
        double rate = 0.5,
      }) async {
    if (text.isEmpty) return;
    await _flutterTts.setLanguage(language);
    await _flutterTts.setPitch(pitch);
    await _flutterTts.setSpeechRate(rate);
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
