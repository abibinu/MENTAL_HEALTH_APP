import 'package:flutter/material.dart';
import 'mood_tracker.dart'; // Import the MoodTrackerPage class

class ExploreMore extends StatelessWidget {
  final List<String> dailyChallenges = [
    "Drink 8 glasses of water today.",
    "Take a 10-minute mindful walk.",
    "Write down 3 things you're grateful for.",
    "Reach out to a friend you haven’t talked to in a while.",
    "Spend 15 minutes meditating or breathing deeply."
  ];

  final List<String> motivationalQuotes = [
    "Believe you can, and you're halfway there.",
    "Every day may not be good, but there is something good in every day.",
    "You are braver than you believe, stronger than you seem, and smarter than you think.",
    "Happiness is not something ready-made. It comes from your own actions.",
    "The only limit to our realization of tomorrow is our doubts of today."
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore More',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),

        // Daily Challenge Section
        _buildCard(
          title: "Today's Challenge",
          content: _getRandomItem(dailyChallenges),
          icon: Icons.flag,
          backgroundColor: Colors.teal[100],
        ),
        SizedBox(height: 16),

        // Motivational Quote Section
        _buildCard(
          title: "Motivational Quote",
          content: _getRandomItem(motivationalQuotes),
          icon: Icons.format_quote,
          backgroundColor: Colors.amber[100],
        ),
        SizedBox(height: 16),

        // Mood Graph Placeholder with GestureDetector
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MoodTrackerPage()),
            );
          },
          child: _buildCard(
            title: "Mood Tracker Graph",
            content: "Track your mood over time with a visual graph.",
            icon: Icons.bar_chart,
            backgroundColor: Colors.purple[100],
          ),
        ),
      ],
    );
  }

  // Helper method to build reusable cards
  Widget _buildCard({
    required String title,
    required String content,
    required IconData icon,
    required Color? backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: Colors.black54),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get a random item from a list
  String _getRandomItem(List<String> items) {
    items.shuffle(); // Randomize the order of the list
    return items.first; // Return the first item
  }
}
