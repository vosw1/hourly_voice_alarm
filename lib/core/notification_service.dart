import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_tts/flutter_tts.dart'; // 음성 합성 추가

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final FlutterTts flutterTts = FlutterTts(); // 음성 합성 객체 추가

  // 앱 초기화 시 호출되는 함수
  static Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: android);

    // 알림 클릭 시 호출되는 함수 설정
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: onSelect, // 여기서 알림 클릭을 처리
    );
  }

  // 정해진 시간대에 알림을 예약하는 함수
  static Future<void> scheduleHourlyAlarms(int startHour, int endHour) async {
    for (int hour = startHour; hour <= endHour; hour++) {
      final now = tz.TZDateTime.now(tz.local);
      final scheduled = tz.TZDateTime.local(
        now.year,
        now.month,
        now.day,
        hour,
        0,
      );

      // 알림을 시간마다 예약
      await _notifications.zonedSchedule(
        hour, // id
        '정시 알림',
        '$hour시',
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'hourly_channel',
            '정시 알림',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: '$hour', // 알림 클릭 시 payload로 넘길 데이터
      );
    }
  }

  // 알림 클릭 시 호출되는 함수
  static Future<void> onSelect(NotificationResponse response) async {
    if (response.payload != null) {
      int hour = int.parse(response.payload!);
      await TtsService.speakTime(hour);
    }
  }
}

class TtsService {
  static final FlutterTts _flutterTts = FlutterTts();

  // 시간에 맞는 음성 알림을 발송하는 함수
  static Future<void> speakTime(int hour) async {
    await _flutterTts.speak('$hour 시');
  }
}