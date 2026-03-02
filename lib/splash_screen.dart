import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'registration_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
    loadAndNavigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

    final selLang = prefs.getString('selectedLanguage') ?? 'en';
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2D3B89),
              Color(0xFF4A90E2),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.record_voice_over,
                        size: 70, color: Colors.white),
                  ),
                  SizedBox(height: 30),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'AURIS',
                        textStyle: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 8,
                        ),
                        speed: Duration(milliseconds: 200),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Communication Made Simple',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.7)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}