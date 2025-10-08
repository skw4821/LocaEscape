import 'package:flutter/material.dart';
import 'package:calender_project/widgets/calendar_widget.dart';


class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('캘린더')),
      body: CalendarWidget(),
    );
  }
}
