import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final List<String> affirmations = [
    "I am capable of achieving great things.",
    "I choose to focus on the positive.",
    "I am worthy of love and happiness.",
    "Every day is a fresh start.",
    "I have the strength to overcome challenges.",
  ];

  final List<String> moodBoostingActivities = [
    "Take a 10-minute walk.",
    "Listen to your favorite song.",
    "Write down 3 things you're grateful for.",
    "Call a friend or loved one.",
    "Drink a glass of water.",
  ];

  final List<Map<String, String>> mentalHealthFAQs = [
    {
      "question": "What is anxiety?",
      "answer":
          "Anxiety is a feeling of worry or fear that can affect your daily life. It’s normal in small amounts but can become overwhelming.",
    },
    {
      "question": "How can I practice mindfulness?",
      "answer":
          "Mindfulness involves focusing on the present moment through meditation, breathing exercises, or journaling.",
    },
    {
      "question": "What are some signs of stress?",
      "answer":
          "Common signs of stress include irritability, difficulty sleeping, and feeling overwhelmed.",
    },
  ];

  final List<Map<String, String>> resources = [
    {"name": "Mindfulness Guide", "link": "https://www.mindful.org/"},
    {"name": "Meditation App", "link": "https://www.headspace.com/"},
    {"name": "Mental Health Hotline", "link": "https://www.mentalhealth.gov/"}
  ];

  final List<String> randomActsOfKindness = [
    "Compliment a stranger.",
    "Help a friend with a task.",
    "Write a thank-you note.",
    "Donate something you no longer use.",
    "Offer to babysit or pet-sit for free.",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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

          // Affirmation Section
          _buildCard(
            title: "Daily Affirmation",
            content: _getRandomItem(affirmations),
            icon: Icons.favorite,
            backgroundColor: Colors.pink[100],
          ),
          SizedBox(height: 16),

          // Mood Boosting Activity Section
          _buildCard(
            title: "Mood Boosting Activity",
            content: _getRandomItem(moodBoostingActivities),
            icon: Icons.mood,
            backgroundColor: Colors.blue[100],
          ),
          SizedBox(height: 16),

          // Random Act of Kindness Section
          _buildCard(
            title: "Random Act of Kindness",
            content: _getRandomItem(randomActsOfKindness),
            icon: Icons.volunteer_activism,
            backgroundColor: Colors.green[100],
          ),
          SizedBox(height: 16),
          // Mental Health FAQs
          _buildSectionTitle("Mental Health FAQs"),
          _buildFAQSection(),
          SizedBox(height: 16),

          // Resource Library Section
          _buildSectionTitle("Resource Library"),
          _buildResourceSection(context),
        ],
      ),
    );
  }

  // Helper to build reusable cards
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

  // Section Title Builder
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Build FAQ Section
  Widget _buildFAQSection() {
    return Column(
      children: mentalHealthFAQs.map((faq) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq["question"]!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  faq["answer"]!,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Build Resource Section
  Widget _buildResourceSection(BuildContext context) {
    return Column(
      children: resources.map((resource) {
        return ListTile(
          leading: Icon(Icons.link, color: Colors.purple),
          title: Text(resource["name"]!),
          subtitle: Text(resource["link"]!),
          onTap: () => _launchURL(context, resource["link"]!), // Open the URL
        );
      }).toList(),
    );
  }

  // Helper function to launch URLs
  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      final Uri uri = Uri.parse(url);
      print("Attempting to launch URL: $uri"); // Debug print statement
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cannot launch $url")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error launching URL: $e")),
      );
    }
  }

  // Helper to get random item
  String _getRandomItem(List<String> items) {
    items.shuffle();
    return items.first;
  }
}
