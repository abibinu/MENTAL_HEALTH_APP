import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Privacy Policy")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Privacy Policy",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "We value your privacy and are committed to protecting your personal data. This policy outlines how we collect, use, and safeguard your information.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            _buildPolicySection("1. Information We Collect",
                "We collect your name, email, and mood logs to improve your experience. Your data is encrypted and stored securely."),
            _buildPolicySection("2. How We Use Your Data",
                "Your data is used to personalize your experience and provide insights into your mental health trends."),
            _buildPolicySection("3. Data Security",
                "We use encryption and secure servers to store your information safely."),
            _buildPolicySection("4. Third-Party Sharing",
                "We do not share your personal data with third parties without your consent."),
            _buildPolicySection("5. Contact Us",
                "If you have any questions, reach out to support@mentalhealthapp.com."),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(content, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
