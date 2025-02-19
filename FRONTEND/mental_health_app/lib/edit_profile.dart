import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _userId = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ✅ Load User Data from SharedPreferences & Database
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not found. Please log in again.')),
      );
      return;
    }

    print("Fetching user details for user_id: $userId"); // ✅ Debug print

    setState(() {
      _userId = userId;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.150.233:5000/api/users?user_id=$_userId'),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        setState(() {
          _nameController.text = userData["name"];
          _emailController.text = userData["email"];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch user details.')),
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // ✅ Update User Data
  Future<void> _updateUserDetails() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name and email cannot be empty.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final requestBody = {
      "user_id": _userId,
      "name": _nameController.text,
      "email": _emailController.text,
      "password":
          _passwordController.text.isNotEmpty ? _passwordController.text : null,
    };

    print("Sending update request: $requestBody"); // ✅ Debug print

    try {
      final response = await http.put(
        Uri.parse('http://192.168.150.233:5000/api/users/update'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // ✅ Update SharedPreferences with new name & email
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("username", _nameController.text);
        await prefs.setString("user_email", _emailController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );

        Navigator.pop(context); // ✅ Go back after update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error updating user details: $e'); // ✅ Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
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
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText:
                    "New Password (Leave blank to keep current password)",
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _updateUserDetails,
                    child: Text("Save Changes"),
                  ),
          ],
        ),
      ),
    );
  }
}
