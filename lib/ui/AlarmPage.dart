import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  late int startHour;
  late int endHour;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // SharedPreferences에서 시간 설정값 로드
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      startHour = prefs.getInt('startHour') ?? 9;
      endHour = prefs.getInt('endHour') ?? 21;
    });
  }

  // 시간 설정을 SharedPreferences에 저장
  _savePreferences(int start, int end) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('startHour', start);
    await prefs.setInt('endHour', end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hourly Voice Alarm')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Start Hour: $startHour', style: TextStyle(fontSize: 20)),
            Text('End Hour: $endHour', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      startHour = 9;  // 예시로 9시로 설정
                      endHour = 21;   // 예시로 21시로 설정
                    });
                    _savePreferences(startHour, endHour);
                  },
                  child: const Text('Reset to Default'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // startHour, endHour을 사용자가 설정하는 로직을 추가할 수 있습니다
                  },
                  child: const Text('Custom Settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}