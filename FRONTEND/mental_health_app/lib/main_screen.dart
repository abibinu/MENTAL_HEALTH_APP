import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'tasks.dart';
import 'mood_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int curIndex = 0; // Define curIndex

  @override
  void initState() {
    super.initState();
    _loadIndex();
  }

  Future<void> _loadIndex() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      curIndex = sharedPreferences.getInt('curIndex') ?? 0; // Retrieve curIndex
    });
  }

  final List<Widget> pages = [
    HomePage(),
    TasksPage(),
    MoodTrackerPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[curIndex], // Use curIndex to display the correct page

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: curIndex,
        onTap: (index) {
          setState(() {
            curIndex = index;
            SharedPreferences.getInstance().then((prefs) {
              prefs.setInt('curIndex', curIndex); // Save curIndex
            });
          });
        },
        showUnselectedLabels: false,
        selectedItemColor: Color(0xFF6A11CB),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: 'Mood Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
