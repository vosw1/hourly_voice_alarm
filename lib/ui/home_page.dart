import 'package:flutter/material.dart';
import 'alarm_page.dart'; // 알림 설정 페이지 import

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈 화면'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 알림 설정 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AlarmPage()),
            );
          },
          child: const Text('알림 설정'),
        ),
      ),
    );
  }
}