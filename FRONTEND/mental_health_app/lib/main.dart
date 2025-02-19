import 'package:flutter/material.dart';
import 'calm_music.dart';
import 'chatbot.dart';
import 'home.dart';
import 'mood_tracker.dart';
import 'tasks.dart';
import 'main_screen.dart';
import 'splash_screen.dart';
import 'login.dart';
import 'register.dart';
import 'profile.dart';
import 'help_faqs.dart';
import 'privacy_policy.dart';
import 'delete_account.dart';
import 'relaxation.dart';
import 'edit_profile.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => MainScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/tasks': (context) => TasksPage(),
        '/mood_tracker': (context) => MoodTrackerPage(),
        '/chat': (context) => ChatBotPage(),
        '/calm_music': (context) => CalmMusicPage(),
        '/help': (context) => HelpFAQsPage(),
        '/privacy_policy': (context) => PrivacyPolicyPage(),
        '/delete_account': (context) => DeleteAccountPage(),
        '/relaxation': (context) => RelaxationPage(),
        '/edit_profile': (context) => EditProfilePage(),
      },
    );
  }
}
