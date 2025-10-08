import 'package:flutter/material.dart';
import 'package:calender_project/services/mysql_service.dart';

class AddEventPage extends StatelessWidget {
  const AddEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('일정 추가')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await MySQLService.addEvent(
              "플러터 회의",  // 일정 제목
              "온라인",      // 위치
              2,            // 알림 강도
              "2025-06-02", // 날짜 (YYYY-MM-DD)
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('일정이 추가되었습니다!')),
            );
          },
          child: const Text('일정 추가 테스트'),
        ),
      ),
    );
  }
}
