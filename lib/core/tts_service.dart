import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _flutterTts = FlutterTts();

  static Future<void> speakTime(int hour) async {
    await _flutterTts.speak('$hour 시');
  }
}