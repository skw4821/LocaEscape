import 'dart:math';

class MotivationService {
  final List<String> messages = [
    "오늘도 화이팅!",
    "잘 하고 있어요!",
    "5분만 더 해봐요!",
  ];

  String getRandomMessage() {
    return messages[Random().nextInt(messages.length)];
  }
}
