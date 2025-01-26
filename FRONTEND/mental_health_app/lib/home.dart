import 'package:flutter/material.dart';
import 'package:mental_health_app/explore_more.dart';
import 'quotes_section.dart'; // Import the QuotesSection class
import 'profile.dart'; // Import the ProfilePage class
import 'settings.dart'; // Import the SettingsPage class

class HomePage extends StatelessWidget {
  final String username; // Declare a variable to hold the username

  // Constructor to accept the username
  HomePage({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        shadowColor: Colors.grey[400],
        toolbarHeight: 70,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6A11CB), // Purple
                Color(0xFF2575FC), // Blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text('  Hi there, $username!',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25)),
        automaticallyImplyLeading: false, // No back button
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Featured Section (Motivational Quote or Highlight)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      78, 177, 225, 255), // Inverse primary color
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb,
                        color: const Color.fromARGB(255, 238, 255, 0),
                        size: 40), // Bulb icon color

                    Expanded(
                      child:
                          QuotesSection(), // Correctly use the QuotesSection widget
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Navigation Cards (Quick Actions)
              Text(
                'Quick Actions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickAction(
                    context,
                    icon: Icons.task,
                    label: 'Tasks',
                    onTap: () {
                      Navigator.pushNamed(context, '/tasks');
                    },
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.mood,
                    label: 'Mood Tracker',
                    onTap: () {
                      Navigator.pushNamed(context, '/mood_tracker');
                    },
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              ExploreMore(),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Update dynamically based on the selected tab
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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

  // Quick Action Widget
  Widget _buildQuickAction(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    Color backgroundColor;

    // Set background color based on the label
    if (label == 'Tasks') {
      backgroundColor = Colors.green; // Change to green
    } else if (label == 'Mood Tracker') {
      backgroundColor = Color(0xFF2575FC); // No change
    } else if (label == 'Settings') {
      backgroundColor = Colors.grey; // Change to grey
    } else {
      backgroundColor = Color(0xFF2575FC); // Default color
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: backgroundColor,
            radius: 30,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
