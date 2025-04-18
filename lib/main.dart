import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hourly_voice_alarm/ui/AlarmPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'core/notification_service.dart';

// Background Task 실행을 위한 콜백 디스패처
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final prefs = await SharedPreferences.getInstance();
    final start = prefs.getInt('startHour') ?? 9; // 기본값 9시
    final end = prefs.getInt('endHour') ?? 21;  // 기본값 21시
    await NotificationService.scheduleHourlyAlarms(start, end);
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // NotificationService 초기화
  await NotificationService.init();

  // Workmanager 초기화 및 작업 등록
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask("dailyAlarmTask", "rescheduleAlarms", frequency: const Duration(hours: 12));

  runApp(const MyApp());
}

// MyApp: 기본 앱 UI 설정
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hourly Voice Alarm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AlarmPage(), // AlarmPage로 이동
    );
  }
}