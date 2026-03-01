import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_strings.dart';
import 'child_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String currentLanguage = "en";
  String selectedLanguage = "en";
  String selectedAge = "0-3";
  List<Map<String, dynamic>> words = [];

  @override
  void initState() {
    super.initState();
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? saved = prefs.getString("saved_language");
    if (saved != null) {
      setState(() {
        currentLanguage = saved;
        selectedLanguage = saved;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appStrings[currentLanguage]!["profile"]!)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: selectedAge,
              decoration: InputDecoration(
                labelText: appStrings[currentLanguage]!["age"]!,
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: "0-3", child: Text("0-3")),
                DropdownMenuItem(value: "4-6", child: Text("4-6")),
                DropdownMenuItem(value: "7-9", child: Text("7-9")),
                DropdownMenuItem(value: "10-13",child:Text("10-13")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedAge = value!;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              decoration: InputDecoration(
                labelText: appStrings[currentLanguage]!["language"]!,
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: "en", child: Text("English")),
                DropdownMenuItem(value: "fr", child: Text("French")),
                DropdownMenuItem(value: "es", child: Text("Spanish")),
                DropdownMenuItem(value: "de", child: Text("German")),
                DropdownMenuItem(value: "it", child: Text("Italian")),
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
                      ageRange: selectedAge,
                    ),
                  ),
                );
              },
              child: Text(appStrings[currentLanguage]!["save"]!),
            ),
          ],
        ),
      ),
    );
  }
}
