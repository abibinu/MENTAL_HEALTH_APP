import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  late SharedPreferences sharedPreferences;
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      sharedPreferences = prefs;
      welcomeMessage();
    });
  }

  void welcomeMessage() async {
    int? userId = sharedPreferences.getInt('user_id');
    String? userName = sharedPreferences.getString('name');
    String? userMessage =
        "You are a compassionate virtual therapist. Your role is to provide emotional support, mental health advice, and motivation to users. Address the user by their name ($userName) in a warm and empathetic manner. Keep responses brief, supportive, and professional. Your reply should be - 'Hi $userName, I am your virtual therapist. How was your day?'";
    if (userId == null) {
      setState(() {
        messages.add({"role": "bot", "content": "User ID is not set."});
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.150.233:5000/api/chatbot'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "user_id": userId,
        "message": userMessage,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        messages.add({"role": "bot", "content": responseData['reply']});
      });
    } else {
      setState(() {
        messages.add({
          "role": "bot",
          "content": "I'm sorry, I couldn't process that request."
        });
      });
    }
  }

  Future<void> sendMessage(String userMessage) async {
    setState(() {
      messages.add({"role": "user", "content": userMessage});
    });

    int? userId = sharedPreferences.getInt('user_id');
    if (userId == null) {
      setState(() {
        messages.add({"role": "bot", "content": "User ID is not set."});
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.150.233:5000/api/chatbot'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "user_id": userId,
        "message": userMessage,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        messages.add({"role": "bot", "content": responseData['reply']});
      });
    } else {
      setState(() {
        messages.add({
          "role": "bot",
          "content": "I'm sorry, I couldn't process that request."
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mood Assistant',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
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
        ), // Primary color
        iconTheme: IconThemeData(
            color: Colors.white), // Set back button color to white
        centerTitle: true,
        elevation: 15, // Increased elevation for a more pronounced shadow
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isUser = message['role'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 300),
                    margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Color(0xFF2575FC)
                          : Color(0xFF6A11CB), // Theme colors
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      message['content']!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "  How are you feeling?",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Color(0xFF6A11CB),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
