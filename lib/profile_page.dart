import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'app_strings.dart';
import 'child_page.dart';
import 'design_page.dart';

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

  InputDecoration _styledInput(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Color(0xFF4A90E2)),
      filled: true,
      fillColor: Colors.white,
      labelStyle: GoogleFonts.poppins(color: Color(0xFFA3AED0)),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF2D3B89).withOpacity(0.08),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(Icons.arrow_back_ios_new,
                          color: Color(0xFF2D3B89), size: 18),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    appStrings[currentLanguage]!["profile"]!,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3B89),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Profile avatar section
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2D3B89), Color(0xFF4A90E2)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4A90E2).withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(Icons.person, size: 45, color: Colors.white),
                ),
              ),
              SizedBox(height: 32),

              // Settings card
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF2D3B89).withOpacity(0.08),
                      blurRadius: 30,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Settings",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3B89),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedAge,
                      decoration: _styledInput(
                          appStrings[currentLanguage]!["age"]!, Icons.cake),
                      dropdownColor: Colors.white,
                      items: [
                        DropdownMenuItem(value: "0-3", child: Text("0-3", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                        DropdownMenuItem(value: "4-6", child: Text("4-6", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                        DropdownMenuItem(value: "7-9", child: Text("7-9", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                        DropdownMenuItem(value: "10-13", child: Text("10-13", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                        DropdownMenuItem(value: "14-16", child: Text("14-16", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedAge = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedLanguage,
                      decoration: _styledInput(
                          appStrings[currentLanguage]!["language"]!,
                          Icons.language),
                      dropdownColor: Colors.white,
                      items: [
                        DropdownMenuItem(value: "en", child: Text("English", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                        DropdownMenuItem(value: "fr", child: Text("French", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                        DropdownMenuItem(value: "es", child: Text("Spanish", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                        DropdownMenuItem(value: "de", child: Text("German", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                        DropdownMenuItem(value: "it", child: Text("Italian", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2D3B89),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                    shadowColor: Color(0xFF2D3B89).withOpacity(0.4),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    String oldLang = prefs.getString("saved_language") ?? "en";
                    String oldAge = prefs.getString("ageRange") ?? "0-3";
                    
                    bool changed = (oldLang != selectedLanguage || oldAge != selectedAge);

                    await prefs.setString("saved_language", selectedLanguage);
                    await prefs.setString("selectedLanguage", selectedLanguage); // keep consistent
                    await prefs.setString("ageRange", selectedAge);

                    if (changed) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DesignPage(
                            childName: 'Profile',
                            selectedLanguage: selectedLanguage,
                            ageRange: selectedAge,
                          ),
                        ),
                      );
                    } else {
                      String? savedVocab = prefs.getString('vocab');
                      Map<String, List<Map<String, dynamic>>>? categories;
                      if (savedVocab != null) {
                        final Map<String, dynamic> decoded = jsonDecode(savedVocab);
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

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChildPage(
                            categories: categories,
                            childName: 'Profile',
                            ageRange: selectedAge,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    appStrings[currentLanguage]!["save"]!,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
