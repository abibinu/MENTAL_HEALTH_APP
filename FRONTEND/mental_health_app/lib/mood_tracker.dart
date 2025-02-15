import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MoodTrackerPage extends StatefulWidget {
  @override
  _MoodTrackerPageState createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  final TextEditingController _noteController = TextEditingController();
  String? _selectedMood;
  int _userId = 0;
  bool _isLoading = false;
  List<Map<String, dynamic>> _moodLogs = [];
  Map<String, double> _moodAnalytics = {};

  final List<String> _moods = ["Happy", "Sad", "Angry", "Calm", "Anxious"];

  @override
  void initState() {
    super.initState();
    _loadUserid();
  }

  Future<void> _loadUserid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = sharedPreferences.getInt('user_id') ?? 0;
    });
    _fetchMoodLogs();
    _fetchMoodAnalytics();
  }

  Future<void> _fetchMoodLogs() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.150.233:5000/api/mood-logs?user_id=$_userId'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _moodLogs =
              List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to fetch mood logs: ${response.statusCode}'),
        ));
      }
    } catch (e) {
      print('Error in _fetchMoodLogs: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching mood logs: $e'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMoodAnalytics() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt("user_id");

      print('Fetching analytics for user: $userId');

      final response = await http.get(Uri.parse(
          'http://192.168.150.233:5000/api/mood-logs/analytics?user_id=$userId'));

      print('Analytics Response status: ${response.statusCode}');
      print('Analytics Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> rawData = json.decode(response.body);
        print('Raw analytics data: $rawData');

        final Map<String, double> convertedData = {};

        rawData.forEach((key, value) {
          try {
            if (value is int) {
              convertedData[key] = value.toDouble();
            } else if (value is double) {
              convertedData[key] = value;
            } else {
              convertedData[key] = double.parse(value.toString());
            }
            print('Converted $key: ${convertedData[key]}');
          } catch (e) {
            print('Error converting value for $key: $e');
          }
        });

        setState(() {
          _moodAnalytics = convertedData;
        });

        print('Final analytics data: $_moodAnalytics');
      }
    } catch (e, stackTrace) {
      print('Error in _fetchMoodAnalytics: $e');
      print('Stack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching mood analytics: $e'),
      ));
    }
  }

  Future<void> _saveMoodLog() async {
    if (_selectedMood == null || _noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a mood and add a note.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.150.233:5000/api/mood-logs'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": _userId,
          "mood": _selectedMood,
          "note": _noteController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mood logged successfully!')),
        );
        _fetchMoodLogs();
        _fetchMoodAnalytics();
        _noteController.clear();
        setState(() {
          _selectedMood = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to save mood: ${response.statusCode} ${response.body}')),
        );
      }
    } catch (e) {
      print('Error in _saveMoodLog: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Tracker'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Log Your Mood',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedMood,
                items: _moods
                    .map((mood) =>
                        DropdownMenuItem(value: mood, child: Text(mood)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMood = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Mood',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Add a Note',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: _isLoading ? null : _saveMoodLog,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Save Mood'),
              ),
              SizedBox(height: 20),
              Text(
                'Mood History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _moodLogs.isEmpty
                      ? Text('No logs yet.')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _moodLogs.length,
                          itemBuilder: (context, index) {
                            final log = _moodLogs[index];
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: Icon(Icons.mood),
                                title: Text(log['mood']),
                                subtitle: Text(log['note'] ?? ''),
                                trailing: Text(log['logged_at']),
                              ),
                            );
                          },
                        ),
              SizedBox(height: 20),
              Text(
                'Mood Analytics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _moodAnalytics.isEmpty
                  ? Text('No analytics available yet.')
                  : SizedBox(
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sections: _moodAnalytics.entries
                              .map(
                                (entry) => PieChartSectionData(
                                  value: entry.value,
                                  title:
                                      '${entry.key}\n(${entry.value.toStringAsFixed(1)})',
                                  titleStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  radius: 100,
                                  color: Colors.primaries[_moodAnalytics.keys
                                          .toList()
                                          .indexOf(entry.key) %
                                      Colors.primaries.length],
                                ),
                              )
                              .toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
