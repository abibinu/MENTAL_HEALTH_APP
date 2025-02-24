import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class MalayalamChatBotPage extends StatefulWidget {
  @override
  _MalayalamChatBotPageState createState() => _MalayalamChatBotPageState();
}

class _MalayalamChatBotPageState extends State<MalayalamChatBotPage> {
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
        "You are a compassionate virtual therapist. Your role is to provide emotional support, mental health advice, and motivation to users. Address the user by their name ($userName) in a warm and empathetic manner in Malayalam language. Keep responses brief, supportive, and professional. Your reply should be - 'നമസ്കാരം $userName, ഞാൻ നിങ്ങളുടെ വെർച്വൽ തെറാപ്പിസ്റ്റ് ആണ്. നിങ്ങളുടെ ദിവസം എങ്ങനെ ആയിരുന്നു?'";
    if (userId == null) {
      setState(() {
        messages
            .add({"role": "bot", "content": "യൂസർ ഐഡി സെറ്റ് ചെയ്തിട്ടില്ല."});
      });
      return;
    }

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/api/chatbot'),
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
          "content":
              "ക്ഷമിക്കണം, എനിക്ക് ആ അഭ്യർത്ഥന പ്രോസസ്സ് ചെയ്യാൻ കഴിഞ്ഞില്ല."
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
        messages
            .add({"role": "bot", "content": "യൂസർ ഐഡി സെറ്റ് ചെയ്തിട്ടില്ല."});
      });
      return;
    }

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/api/chatbot'),
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
          "content":
              "ക്ഷമിക്കണം, എനിക്ക് ആ അഭ്യർത്ഥന പ്രോസസ്സ് ചെയ്യാൻ കഴിഞ്ഞില്ല."
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'മൂഡ് അസിസ്റ്റന്റ്',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 15,
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
                      color: isUser ? Color(0xFF2575FC) : Color(0xFF6A11CB),
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
                          fontSize: 16,
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
                      hintText: "നിങ്ങൾക്ക് എങ്ങനെ തോന്നുന്നു?",
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
