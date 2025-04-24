import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz; // 시간대 데이터 초기화
import 'package:timezone/timezone.dart' as tz; // 시간대 관련 패키지
import 'package:permission_handler/permission_handler.dart';
import 'package:hourly_voice_alarm/ui/alarm_page.dart'; // 알림 설정 페이지

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 권한 요청
  await requestExactAlarmPermission();

  // 로컬 알림 플러그인 초기화
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  tz.initializeTimeZones(); // 시간대 초기화

  final prefs = await SharedPreferences.getInstance();
  final startHour = prefs.getInt('startHour') ?? 9;
  final endHour = prefs.getInt('endHour') ?? 20;

  // 알림 예약
  for (int hour = startHour; hour <= endHour; hour++) {
    int id = 100 + hour;
    await scheduleNotification(
      flutterLocalNotificationsPlugin,
      id,
      hour,
    );
  }

  runApp(const MyApp());
}

Future<void> scheduleNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    int id,
    int hour,
    ) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    '정시 알람',
    '$hour시 알람',
    _nextInstanceOfHour(hour),
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

tz.TZDateTime _nextInstanceOfHour(int hour) {
  final now = tz.TZDateTime.now(tz.local); // tz.local 사용
  final targetTime = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    hour,
    0,
  );
  if (targetTime.isBefore(now)) {
    return targetTime.add(const Duration(days: 1));
  }
  return targetTime;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '정시 알람',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AlarmPage(),
    );
  }
}

Future<void> requestExactAlarmPermission() async {
  if (await Permission.scheduleExactAlarm.isDenied) {
    // 권한 요청
    await Permission.scheduleExactAlarm.request();
  }
}