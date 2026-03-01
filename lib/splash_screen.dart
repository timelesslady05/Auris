import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    loadAndNavigate();
  }

  Future<void> loadAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? saved = prefs.getString('vocab');
    Map<String, List<Map<String, dynamic>>>? categories;
    if (saved != null) {
      final Map<String, dynamic> decoded = jsonDecode(saved);
      final Map<String, List<Map<String, dynamic>>> loaded = {};
      decoded.forEach((cat, list) {
        final items = (list as List).map((e) {
          return {
            'text': e['text'],
            'icon': IconData(e['icon'] as int, fontFamily: 'MaterialIcons')
          };
        }).toList();
        loaded[cat] = List<Map<String, dynamic>>.from(items);
      });
      categories = loaded;
    }

    final selLang = prefs.getString('selectedLanguage') ?? 'en-IN';
    final age = prefs.getString('ageRange') ?? '0-3';

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => RegistrationPage(
                  initialSelectedLanguage: selLang,
                  initialAgeRange: age,
                  initialCategories: categories,
                )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.record_voice_over, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'AURIS',
                  textStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  speed: Duration(milliseconds: 200),
                ),
              ],
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}