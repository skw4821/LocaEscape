import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event_model.dart';
import '../dialogs/schedule_input_dialog.dart'; // 알림 강도 다이얼로그는 여기서 처리

class CalendarWidget extends StatefulWidget {
  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  final DateTime _firstDay = DateTime(2020);
  final DateTime _lastDay = DateTime(2030);
  DateTime? _selectedDay;
  final Map<DateTime, List<Event>> _events = {};

  Future<void> _handleDateClick(DateTime selectedDay) async {
    final bool? addSchedule = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일정을 추가하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('예'),
          ),
        ],
      ),
    );

    if (addSchedule ?? false) {
      // 일정 입력 다이얼로그에서 모든 정보(알림 강도 포함) 수집
      final Map<String, dynamic>? scheduleData =
      await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => ScheduleInputDialog(selectedDate: selectedDay),
      );

      if (scheduleData != null) {
        setState(() {
          _events[selectedDay] = [
            ..._events[selectedDay] ?? [],
            Event(
              title: scheduleData['title']!, // 키 이름 확인!
              location: scheduleData['location']!,
              notificationIntensity: scheduleData['intensity']!,
              date: selectedDay,
              startTime: scheduleData['start_time'],
              endTime: scheduleData['end_time'],
            ),
          ];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: _firstDay,
        lastDay: _lastDay,
        locale: 'ko_KR',
        calendarFormat: CalendarFormat.month,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
        eventLoader: (day) => _events[day] ?? [],
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          _handleDateClick(selectedDay);
        },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {
              return Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${events.length}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
