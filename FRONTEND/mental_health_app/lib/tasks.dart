import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: Center(
        child: Text(
          'This is the Tasks Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
