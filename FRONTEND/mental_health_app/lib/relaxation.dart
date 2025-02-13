import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class RelaxationPage extends StatefulWidget {
  @override
  _RelaxationPageState createState() => _RelaxationPageState();
}

class _RelaxationPageState extends State<RelaxationPage> {
  String selectedCategory = "Stress Relief"; // ✅ Default category
  List<Map<String, String>> suggestions = []; // ✅ Corrected type

  final List<String> categories = [
    "Stress Relief",
    "Anxiety Management",
    "Focus Improvement",
    "Sleep Aid"
  ];

  final Map<String, List<Map<String, String>>> exercises = {
    "Stress Relief": [
      {"title": "Do a 5-minute deep breathing exercise.", "url": ""},
      {"title": "Write down 3 things you're grateful for today.", "url": ""},
      {"title": "Try progressive muscle relaxation for 10 minutes.", "url": ""}
    ],
    "Anxiety Management": [
      {"title": "Hold a warm cup of tea and focus on its warmth.", "url": ""},
      {
        "title": "Write down your worries and then tear up the paper.",
        "url": ""
      },
      {"title": "Practice the 4-7-8 breathing technique.", "url": ""}
    ],
    "Focus Improvement": [
      {"title": "Do a quick 1-minute mindful meditation.", "url": ""},
      {"title": "Set a small goal and focus on completing it.", "url": ""},
      {"title": "Try the Pomodoro technique.", "url": ""}
    ],
    "Sleep Aid": [
      {"title": "Turn off screens 30 minutes before bed.", "url": ""},
      {
        "title": "Read a relaxing book or listen to a calming story.",
        "url": ""
      },
      {"title": "Try a 10-minute body scan meditation.", "url": ""}
    ]
  };

  @override
  void initState() {
    super.initState();
    _fetchUserMood(); // ✅ Fetch user mood
  }

  // ✅ Fetch User Mood (Latest or Most Frequent)
  Future<void> _fetchUserMood() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");

    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.143.233:5000/api/mood-logs/latest?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String userMood =
            data["mood"] ?? "Neutral"; // Default value if not found

        setState(() {
          selectedCategory = _getCategoryForMood(userMood);
          suggestions = exercises[selectedCategory] ?? [];
        });
      } else {
        _fetchMostFrequentMood();
      }
    } catch (e) {
      print("Error fetching mood: $e");
    }
  }

  Future<void> _fetchMostFrequentMood() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");

    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.143.233:5000/api/mood-logs/analytics?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            selectedCategory = _getCategoryForMood(data.keys.first);
            suggestions = exercises[selectedCategory] ?? [];
          });
        }
      }
    } catch (e) {
      print("Error fetching mood analytics: $e");
    }
  }

  // ✅ Map Mood to Relaxation Category
  String _getCategoryForMood(String mood) {
    switch (mood) {
      case "Happy":
        return "Focus Improvement";
      case "Sad":
      case "Anxious":
        return "Anxiety Management";
      case "Angry":
        return "Stress Relief";
      case "Calm":
        return "Sleep Aid";
      default:
        return "Stress Relief";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // ✅ Soothing background
      body: Stack(
        children: [
          // ✅ Top Wave Effect
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipperOne(),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade200],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          // ✅ Main Content
          Padding(
            padding: EdgeInsets.only(top: 100), // Avoid overlapping with wave
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Mindfulness & Relaxation",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),

                // ✅ Category Selection
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Select a Category:",
                      style: TextStyle(fontSize: 18)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                        suggestions = exercises[selectedCategory] ?? [];
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),

                // ✅ Recommended Exercises (Without Audio)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Recommended for You:",
                      style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(suggestions[index]["title"]!),
                          leading: Icon(Icons.spa,
                              color: Colors.blue), // Meditation icon
                          onTap: () {
                            _showExerciseDetails(suggestions[index]["title"]!);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ✅ Bottom Wave Effect
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade200, Colors.blue.shade400],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Show Exercise Details in Popup
  void _showExerciseDetails(String exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Relaxation Exercise"),
        content: Text(exercise),
        actions: [
          TextButton(
            child: Text("Got it!"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
