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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      username = sharedPreferences.getString('name') ?? '';
      email = sharedPreferences.getString('email') ?? '';
    });
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

  // ✅ Delete Account (Confirmation Dialog)
  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Account"),
        content: Text(
            "Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () {
              // Implement actual delete logic
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ✅ Edit Profile (Future Implementation)
  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Edit Profile feature coming soon!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile & Settings")),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Change password feature coming soon!")),
              );
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
            onTap: _deleteAccount,
          ),
          SizedBox(height: 16),

          // ✅ Help & Support Section
          Text("Support",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
