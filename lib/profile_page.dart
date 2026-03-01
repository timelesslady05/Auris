import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'child_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedLanguage = "en-US";
  List<Map<String, dynamic>> words = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              decoration: InputDecoration(
                labelText: "Language",
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: "en-US", child: Text("English")),
                DropdownMenuItem(value: "hi-IN", child: Text("Hindi")),
                DropdownMenuItem(value: "ta-IN", child: Text("Tamil")),
                DropdownMenuItem(value: "fr-FR", child: Text("French")),
                DropdownMenuItem(value: "es-ES", child: Text("Spanish")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString("saved_language", selectedLanguage);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChildPage(
                      categories: {'General': words},
                      childName: 'Profile',
                      ageRange: '0-3',
                    ),
                  ),
                );
              },
              child: Text('Go to Child Page'),
            ),
          ],
        ),
      ),
    );
  }
}
