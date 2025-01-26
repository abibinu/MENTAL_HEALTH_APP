import 'package:flutter/material.dart';

class MoodTrackerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Tracker'),
      ),
      body: Center(
        child: Text(
          'This is the Mood Tracker Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
