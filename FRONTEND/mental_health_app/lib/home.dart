import 'package:flutter/material.dart';
import 'package:mental_health_app/explore_more.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quotes_section.dart';
import 'main_screen.dart'; // Import MainScreen
import 'login.dart'; // Import LoginPage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      username = sharedPreferences.getString('name') ?? '';
    });
  }

  Future<void> _confirmLogout() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancels
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirms
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Handle logout logic here
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.clear(); // Clear user data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()), // Navigate to LoginPage
      );
    }
  }

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
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _confirmLogout, // Call the confirmation dialog
          ),
        ],
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
                  color: const Color.fromARGB(78, 177, 225, 255),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb,
                        color: Color.fromARGB(255, 132, 69, 199),
                        size: 40), // Bulb icon color

                    Expanded(
                      child: QuotesSection(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: .0, vertical: 8.0),
                child: Text(
                  "Quick Actions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  QuickActionCard(
                    icon: Icons.mood,
                    title: "Log Your Mood",
                    onTap: () async {
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.setInt('curIndex', 2);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MainScreen()), // Navigate to MainScreen
                      );
                    },
                  ),
                  QuickActionCard(
                    icon: Icons.chat_bubble,
                    title: "Talk to AI",
                    onTap: () {
                      Navigator.pushNamed(context, '/chat');
                    },
                  ),
                  QuickActionCard(
                    icon: Icons.music_note,
                    title: "Calm Sounds",
                    onTap: () {
                      Navigator.pushNamed(context, '/calm_sounds');
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
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const QuickActionCard(
      {required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color:
                  Colors.blueAccent.withOpacity(0.2), // Soft background color
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 32, color: Colors.blueAccent),
          ),
          SizedBox(height: 6),
          Text(title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
