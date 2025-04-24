import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _flutterTts = FlutterTts();

  // 24시간 -> 오전/오후 변환
  static String formatHourToKorean(int hour) {
    final period = hour < 12 ? '오전' : '오후';
    final displayHour = hour == 0
        ? 12
        : hour > 12
        ? hour - 12
        : hour;
    return '$period $displayHour시';
  }

  // 시간에 맞는 음성 안내
  static Future<void> speakTime(int hour) async {
    String text = formatHourToKorean(hour);
    await _flutterTts.setLanguage('ko-KR');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak('$text');
  }
}