import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class ProgressTrackingPage extends StatefulWidget {
  @override
  _ProgressTrackingPageState createState() => _ProgressTrackingPageState();
}

class _ProgressTrackingPageState extends State<ProgressTrackingPage> {
  List<Map<String, dynamic>> tasks = [];
  Map<String, int> moodLogs = {}; // Stores mood history (mood: count)
  double completionRate = 0.0; // Task completion rate

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ✅ Load Tasks & Mood Logs from SharedPreferences
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTasks = prefs.getString("tasks");

    // ✅ Load tasks (still from SharedPreferences)
    if (savedTasks != null) {
      setState(() {
        tasks = List<Map<String, dynamic>>.from(jsonDecode(savedTasks));
        _calculateCompletionRate();
      });
    }

    // ✅ Fetch mood logs from database instead of SharedPreferences
    _fetchMoodLogsFromDatabase();
  }

  Future<void> _fetchMoodLogsFromDatabase() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt("user_id");

      if (userId == null) {
        print("User ID not found in SharedPreferences.");
        return;
      }

      final response = await http.get(
        Uri.parse(
            'http://192.168.150.233:5000/api/mood-logs/analytics?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          moodLogs = Map<String, int>.from(jsonDecode(response.body));
        });
      } else {
        print("Failed to fetch mood logs: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching mood logs: $e");
    }
  }

  // ✅ Calculate Task Completion Rate
  void _calculateCompletionRate() {
    int completedTasks = tasks.where((task) => task["completed"]).length;
    completionRate = tasks.isEmpty ? 0 : completedTasks / tasks.length;
  }

  // ✅ Generate Mood Pie Chart Data
  List<PieChartSectionData> _generateMoodChartData() {
    return moodLogs.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${entry.key} (${entry.value})',
        color: Colors.primaries[moodLogs.keys.toList().indexOf(entry.key) %
            Colors.primaries.length],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Progress & Reports")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Task Completion Progress
            Text("Task Completion Rate",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: completionRate,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 10,
            ),
            SizedBox(height: 20),

            // ✅ Mood Progress Report
            Text("Mood Trends",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: moodLogs.isEmpty
                  ? Center(child: Text("No mood data available."))
                  : PieChart(
                      PieChartData(
                        sections: _generateMoodChartData(),
                        sectionsSpace: 5,
                        centerSpaceRadius: 80,
                      ),
                    ),
            ),

            SizedBox(height: 20),

            // ✅ Achievements
            Text("Achievements",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildAchievementWidget(),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => _resetProgress(),
              child: Text("Reset Progress"),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Display Achievements Based on Progress
  Widget _buildAchievementWidget() {
    if (completionRate == 1.0) {
      return _achievementCard("Goal Master", "Completed all tasks!");
    } else if (completionRate > 0.5) {
      return _achievementCard("Halfway There", "You're making great progress!");
    } else {
      return _achievementCard("Getting Started", "Keep going, you got this!");
    }
  }

  Widget _achievementCard(String title, String description) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.emoji_events, color: Colors.amber),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }

  // ✅ Reset Progress Data
  Future<void> _resetProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("tasks");
    await prefs.remove("mood_logs");

    setState(() {
      tasks.clear();
      moodLogs.clear();
      completionRate = 0.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Progress reset successfully!")),
    );
  }
}
