import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  late int startHour;
  late int startMinute;
  late int endHour;
  late int endMinute;

  @override
  void initState() {
    super.initState();
    startHour = 9; // 초기값 설정
    startMinute = 0; // 초기값 설정
    endHour = 20; // 초기값 설정
    endMinute = 0; // 초기값 설정
    _loadPreferences();
  }

  // SharedPreferences에서 시간 설정값 로드
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      startHour = prefs.getInt('startHour') ?? 9;
      startMinute = prefs.getInt('startMinute') ?? 0;
      endHour = prefs.getInt('endHour') ?? 21;
      endMinute = prefs.getInt('endMinute') ?? 0;
    });
  }

  // 시간 설정을 SharedPreferences에 저장
  _savePreferences(int startH, int startM, int endH, int endM) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('startHour', startH);
    await prefs.setInt('startMinute', startM);
    await prefs.setInt('endHour', endH);
    await prefs.setInt('endMinute', endM);
  }

  // 시간 선택기 (TimePicker)
  _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: isStart ? startHour : endHour, minute: isStart ? startMinute : endMinute),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startHour = picked.hour;
          startMinute = picked.minute;
        } else {
          endHour = picked.hour;
          endMinute = picked.minute;
        }
      });
      _savePreferences(startHour, startMinute, endHour, endMinute);
    }
  }

  // 시간 포맷팅 (HH:mm 형식으로 표시)
  String _formatTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정시 알람'),
        backgroundColor: Colors.blueAccent, // AppBar 색상 변경
      ),
      body: Center( // Center 위젯으로 전체 가로, 세로 중앙 정렬
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 세로 가운데 정렬
            crossAxisAlignment: CrossAxisAlignment.center, // 가로 가운데 정렬
            children: [
              // 시작과 종료 시간 표시 (HH:mm 형식으로 표시)
              Text('시작 : ${_formatTime(startHour, startMinute)}', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
              Text('종료 : ${_formatTime(endHour, endMinute)}', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
              SizedBox(height: 40), // 상단과 버튼들 간격

              // 버튼들을 세로로 배치
              Column(
                mainAxisAlignment: MainAxisAlignment.center, // 버튼들 세로로 가운데 정렬
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        startHour = 9;  // 예시로 9시로 설정
                        startMinute = 0; // 0분으로 설정
                        endHour = 21;   // 예시로 21시로 설정
                        endMinute = 0;   // 0분으로 설정
                      });
                      _savePreferences(startHour, startMinute, endHour, endMinute);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                      textStyle: TextStyle(fontSize: 24),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('초기화'),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      _selectTime(context, true); // 시작 시간 선택
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                      textStyle: TextStyle(fontSize: 24),
                    ),
                    child: const Text('시작 시간'),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      _selectTime(context, false); // 종료 시간 선택
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                      textStyle: TextStyle(fontSize: 24),
                    ),
                    child: const Text('종료 시간'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}