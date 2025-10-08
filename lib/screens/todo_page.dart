import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoPage extends StatelessWidget {
  final Todo todo;
  TodoPage({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('할일 상세')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(todo.title),
      ),
    );
  }
}
