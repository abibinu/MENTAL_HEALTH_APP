import 'package:flutter/material.dart';

class HelpFAQsPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      "question": "How does this app help with mental health?",
      "answer":
          "This app provides tools like mood tracking, meditation, AI chat support, and calming music to improve mental well-being."
    },
    {
      "question": "How can I track my mood?",
      "answer":
          "Go to the 'Mood Tracker' section, select how you're feeling, and log your emotions daily."
    },
    {
      "question": "Is my data secure?",
      "answer":
          "Yes, we take your privacy seriously. Your data is stored securely and is never shared without your consent."
    },
    {
      "question": "Can I change my profile information?",
      "answer":
          "Yes, you can update your name and profile picture in the 'Profile' section."
    },
    {
      "question": "How do I contact support?",
      "answer":
          "If you need assistance, you can email our support team at support@mentalhealthapp.com."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Help & FAQs")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...faqs.map((faq) {
              return Card(
                child: ExpansionTile(
                  title: Text(faq["question"]!,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(faq["answer"]!),
                    ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            TextButton.icon(
              icon: Icon(Icons.email),
              label: Text("Contact Support"),
              onPressed: () {
                // Open email app
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text("Support email: support@mentalhealthapp.com")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
