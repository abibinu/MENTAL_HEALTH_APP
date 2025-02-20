import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class DeleteAccountPage extends StatefulWidget {
  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool isDeleting = false; // Loading state

  // ✅ Delete account function
  Future<void> _deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: User ID not found.")),
      );
      return;
    }

    setState(() {
      isDeleting = true;
    });

    try {
      final response = await http.delete(
        Uri.parse('${Config.baseUrl}/api/delete-account/$userId'),
      );

      if (response.statusCode == 200) {
        await prefs.remove("userToken"); // ✅ Remove login session
        await prefs.remove("user_id");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account deleted successfully.")),
        );

        // ✅ Redirect to Login Page
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Error: ${error['message'] ?? 'Unknown error occurred.'}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Network error: Failed to delete account. Please try again later.")),
      );
    } finally {
      setState(() {
        isDeleting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Delete Account")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Are you sure you want to delete your account?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "This action cannot be undone. Your account and all associated data will be permanently deleted.",
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            SizedBox(height: 20),
            isDeleting
                ? Center(
                    child: CircularProgressIndicator()) // Show loading spinner
                : Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: _deleteAccount,
                        child: Text("Delete My Account",
                            style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Go back to Profile
                        },
                        child: Text("Cancel"),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
