import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'settings.dart';
import 'tasks.dart';
import 'mood_tracker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static int curIndex = 0;

  final List<Widget> pages = [
    HomePage(),
    TasksPage(),
    MoodTrackerPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[curIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: curIndex,
        onTap: (index) {
          setState(() {
            curIndex = index;
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
