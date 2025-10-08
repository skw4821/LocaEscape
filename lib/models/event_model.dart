class Event {
  final String title;
  final String location;
  final int notificationIntensity;
  final DateTime date;
  final String? startTime; // 추가
  final String? endTime;   // 추가

  Event({
    required this.title,
    required this.location,
    required this.notificationIntensity,
    required this.date,
    this.startTime, // 추가 (선택적 필드면 required 제거)
    this.endTime,   // 추가 (선택적 필드면 required 제거)
  });
}
