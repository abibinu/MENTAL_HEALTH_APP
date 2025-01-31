import 'package:flutter/material.dart';
import 'package:mental_health_app/chatbot.dart';
import 'package:mental_health_app/home.dart';
import 'package:mental_health_app/mood_tracker.dart';
import 'package:mental_health_app/tasks.dart';
import 'main_screen.dart';
import 'splash_screen.dart'; // Import your SplashScreen file
import 'login.dart'; // Import your Login file
import 'register.dart'; // Import your Register file
import 'profile.dart'; // Import your Profile page

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    print("App started");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mental Health Companion',
      theme: ThemeData(
        primaryColor: Color(0xFF2575FC),
        colorScheme: ColorScheme(
          primary: Color(0xFF2575FC),
          secondary: Color(0xFF6A11CB),
          surface: Colors.white,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      // Set initial route based on userToken
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => MainScreen(),
        '/login': (context) => LoginPage(), // login page
        '/register': (context) => RegisterPage(), // register page
        '/home': (context) => HomePage(), // home page
        '/profile': (context) => ProfilePage(), // profile route
        '/tasks': (context) => TasksPage(), // tasks route
        '/mood_tracker': (context) => MoodTrackerPage(),
        '/chat': (context) => ChatBotPage(),
      },
    );
  }
}
