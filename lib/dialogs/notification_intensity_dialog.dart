import 'package:flutter/material.dart';

class NotificationIntensityDialog extends StatefulWidget {
  const NotificationIntensityDialog({super.key});

  @override
  State<NotificationIntensityDialog> createState() =>
      _NotificationIntensityDialogState();
}

class _NotificationIntensityDialogState
    extends State<NotificationIntensityDialog> {
  int _selectedIntensity = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('알림 강도 설정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [1, 2, 3].map((intensity) => RadioListTile(
          title: Text(_getIntensityLabel(intensity)),
          value: intensity,
          groupValue: _selectedIntensity,
          onChanged: (value) => setState(() => _selectedIntensity = value!),
        )).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _selectedIntensity),
          child: const Text('확인'),
        ),
      ],
    );
  }

  String _getIntensityLabel(int level) {
    switch (level) {
      case 1: return '약함 (1시간 간격)';
      case 2: return '중간 (30분 간격)';
      case 3: return '강함 (15분 간격)';
      default: return '';
    }
  }
}
