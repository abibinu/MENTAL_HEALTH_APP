import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class QuotesSection extends StatefulWidget {
  @override
  _QuotesSectionState createState() => _QuotesSectionState();
}

class _QuotesSectionState extends State<QuotesSection> {
  final List<String> quotes = [
    "Dream big and dare to fail. Success is one step at a time.",
    "Every moment is a chance to shine and make a difference today.",
    "Happiness comes when you appreciate the beauty of simplicity.",
    "Life is better when you smile through all the ups and downs.",
    "Courage begins with taking one small step toward your dreams.",
    "Be the reason someone smiles and feels inspired every day.",
    "Strength grows when you keep moving forward, no matter what.",
    "Kindness costs nothing but means everything to those who need it.",
    "Success is earned by consistency, focus, and endless patience.",
    "Your potential is endless; keep pushing toward the stars above.",
  ];

  String currentQuote = ""; // To hold the current quote
  late Timer timer; // Timer for periodically changing quotes

  @override
  void initState() {
    super.initState();
    generateRandomQuote(); // Generate an initial quote
    startTimer(); // Start the timer to update quotes periodically
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void generateRandomQuote() {
    final random = Random();
    setState(() {
      currentQuote = quotes[random.nextInt(quotes.length)];
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      generateRandomQuote(); // Update the quote every 10 seconds
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Text(
            currentQuote, // Display the current quote
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Color(0xFF6A11CB), // Text color
            ),
          ),
        ),
      ),
    );
  }
}
