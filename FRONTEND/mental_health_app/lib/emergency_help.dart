import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyHelpPage extends StatefulWidget {
  @override
  _EmergencyHelpPageState createState() => _EmergencyHelpPageState();
}

class _EmergencyHelpPageState extends State<EmergencyHelpPage> {
  List<String> emergencyContacts = [];

  @override
  void initState() {
    super.initState();
    _loadEmergencyContacts();
  }

  // ✅ Load Saved Emergency Contacts
  Future<void> _loadEmergencyContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      emergencyContacts = prefs.getStringList("emergency_contacts") ?? [];
    });
  }

  // ✅ Save Emergency Contacts
  Future<void> _saveEmergencyContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("emergency_contacts", emergencyContacts);
  }

  // ✅ Add a New Emergency Contact
  void _addEmergencyContact() {
    TextEditingController contactController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Emergency Contact"),
        content: TextField(
          controller: contactController,
          decoration: InputDecoration(labelText: "Phone Number"),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Save"),
            onPressed: () {
              setState(() {
                emergencyContacts.add(contactController.text.trim());
              });
              _saveEmergencyContacts();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ✅ Call a Number
  Future<void> _callNumber(String number) async {
    final Uri callUri = Uri.parse("tel:$number");
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch call")),
      );
    }
  }

  // ✅ Send SMS
  Future<void> _sendSMS(String number) async {
    final Uri smsUri = Uri.parse("sms:$number");
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not send SMS")),
      );
    }
  }

  // ✅ Open Mental Health Resources

  Future<void> _openResource(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open $url")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emergency Help & Resources")),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text("Emergency Hotlines",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.red),
            title: Text("Vandrevala Foundation Helpline"),
            subtitle: Text("1860 266 2345"),
            trailing: IconButton(
              icon: Icon(Icons.call, color: Colors.green),
              onPressed: () => _callNumber("18602662345"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.red),
            title: Text("Snehi Mental Health Helpline"),
            subtitle: Text("+91 95822 16800"),
            trailing: IconButton(
              icon: Icon(Icons.call, color: Colors.green),
              onPressed: () => _callNumber("+919582216800"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.red),
            title: Text("iCall Mental Health Support"),
            subtitle: Text("+91 91529 87821"),
            trailing: IconButton(
              icon: Icon(Icons.call, color: Colors.green),
              onPressed: () => _callNumber("+919152987821"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.red),
            title: Text("AASRA Suicide Prevention"),
            subtitle: Text("91-9820466726"),
            trailing: IconButton(
              icon: Icon(Icons.call, color: Colors.green),
              onPressed: () => _callNumber("919820466726"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.red),
            title: Text("Kiran Mental Health Helpline"),
            subtitle: Text("1800 599 0019"),
            trailing: IconButton(
              icon: Icon(Icons.call, color: Colors.green),
              onPressed: () => _callNumber("18005990019"),
            ),
          ),
          SizedBox(height: 20),
          Text("Your Emergency Contacts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          emergencyContacts.isEmpty
              ? Text("No emergency contacts saved.")
              : Column(
                  children: emergencyContacts.map((contact) {
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.person, color: Colors.blue),
                        title: Text(contact),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.call, color: Colors.green),
                              onPressed: () => _callNumber(contact),
                            ),
                            IconButton(
                              icon: Icon(Icons.message, color: Colors.orange),
                              onPressed: () => _sendSMS(contact),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addEmergencyContact,
            child: Text("Add Emergency Contact"),
          ),
          SizedBox(height: 20),
          Text("Mental Health Resources",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            leading: Icon(Icons.web, color: Colors.purple),
            title: Text("Mindful.org"),
            subtitle: Text("Articles & guided meditation"),
            onTap: () => _openResource("https://www.mindful.org"),
          ),
          ListTile(
            leading: Icon(Icons.web, color: Colors.purple),
            title: Text("Headspace"),
            subtitle: Text("Guided meditation & sleep"),
            onTap: () => _openResource("https://www.headspace.com"),
          ),
          ListTile(
            leading: Icon(Icons.web, color: Colors.purple),
            title: Text("BetterHelp"),
            subtitle: Text("Find online therapy"),
            onTap: () => _openResource("https://www.betterhelp.com"),
          ),
        ],
      ),
    );
  }
}
