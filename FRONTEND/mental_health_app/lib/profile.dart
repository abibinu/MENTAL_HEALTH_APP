import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mental_health_app/config.dart'; // Import Config for baseUrl
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId =
        prefs.getInt("user_id"); // ✅ Get user ID from SharedPreferences

    if (userId == null) {
      print("User ID not found in SharedPreferences");
      return;
    }

    try {
      final response = await http
          .get(Uri.parse('${Config.baseUrl}/api/users?user_id=$userId'));

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          username = data["name"] ?? "User"; // ✅ Assign fetched name
          email =
              data["email"] ?? "example@email.com"; // ✅ Assign fetched email
        });
      } else {
        print("Failed to load user data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

// ✅ Reload data when returning from Edit Profile page
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  // ✅ Logout Function
  void _logout() async {
    bool confirmLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Logout"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text("Logout"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmLogout == true) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.remove('user_id');
      await sharedPreferences.remove('name');
      await sharedPreferences.remove('email');
      int? userId = sharedPreferences.getInt('user_id');
      String? name = sharedPreferences.getString('name');
      print(
          'session cleared: ${userId ?? 'no user ID'} and ${name ?? 'no name'}');

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  // ✅ Edit Profile (Future Implementation)
  void _editProfile() {
    // Implement the edit profile logic here
    Navigator.pushNamed(context, '/edit_profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile & Settings"),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // ✅ User Profile Section
          Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 40,
                ),
              ),
              title: Text(username ?? 'No Name'), // Updated line
              subtitle: Text(email ?? 'No Email'), // Updated line
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: _editProfile, // Edit Profile Action
              ),
            ),
          ),
          SizedBox(height: 16),

          // ✅ Settings Section
          Text("Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notification Preferences"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Notification settings coming soon!")),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Change Password"),
            onTap: () {
              Navigator.pushNamed(context, '/edit_profile');
            },
          ),
          SizedBox(height: 16),

          // ✅ Mood & Tasks Section
          Text("Your Progress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            leading: Icon(Icons.insert_chart),
            title: Text("Mood & Task Progress"),
            subtitle: Text("Check your emotional & productivity trends"),
            onTap: () {
              Navigator.pushNamed(context, '/mood_tracker');
            },
          ),
          SizedBox(height: 16),

          // ✅ Account Management Section
          Text("Account",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text("Logout"),
            onTap: _logout,
          ),
          ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text("Delete Account"),
              onTap: () {
                Navigator.pushNamed(context, '/delete_account');
              }),
          SizedBox(height: 16),

          // ✅ Help & Support Section
          Text("Support",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            leading: Icon(Icons.sos, color: Colors.red),
            title: Text("Emergency Help & Resources"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/emergency_help');
            },
          ),

          ListTile(
            leading: Icon(Icons.help),
            title: Text("Help & FAQs"),
            onTap: () {
              Navigator.pushNamed(context, '/help');
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text("Privacy Policy"),
            onTap: () {
              Navigator.pushNamed(context, '/privacy_policy');
            },
          ),
        ],
      ),
    );
  }
}
