import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_page.dart';

class RegistrationPage extends StatefulWidget {
  final String? initialSelectedLanguage;
  final String? initialAgeRange;
  final Map<String, List<Map<String, dynamic>>>? initialCategories;

  RegistrationPage({this.initialSelectedLanguage, this.initialAgeRange, this.initialCategories});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String ageRange = '0-3';
  String phone = '';
  String email = '';
  String selectedLanguage = "en";

  Map<String, List<Map<String, dynamic>>>? initialCategories;

  final List<String> validLanguages = ["en", "fr", "es", "de", "it"];

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedLanguage != null &&
        validLanguages.contains(widget.initialSelectedLanguage)) {
      selectedLanguage = widget.initialSelectedLanguage!;
    }
    if (widget.initialAgeRange != null) ageRange = widget.initialAgeRange!;
    initialCategories = widget.initialCategories;
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                // Header
                Text(
                  "Welcome! 👋",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3B89),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Let's set up your child's profile",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Color(0xFFA3AED0),
                  ),
                ),
                SizedBox(height: 32),

                // Main card
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
                    children: [
                      TextFormField(
                        decoration: _styledInput("Child Name", Icons.child_care),
                        style: GoogleFonts.poppins(color: Color(0xFF2D3B89)),
                        onSaved: (value) => name = value ?? '',
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField(
                        value: ageRange,
                        items: ["0-3", "4-6", "7-9", "10-13", "14-16"]
                            .map((age) => DropdownMenuItem(
                                  value: age,
                                  child: Text(age, style: GoogleFonts.poppins(color: Color(0xFF2D3B89))),
                                ))
                            .toList(),
                        onChanged: (value) => ageRange = value.toString(),
                        decoration: _styledInput("Age Range", Icons.cake),
                        dropdownColor: Colors.white,
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedLanguage,
                        decoration: _styledInput("Select Language", Icons.language),
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
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: _styledInput("Phone Number", Icons.phone),
                        style: GoogleFonts.poppins(color: Color(0xFF2D3B89)),
                        keyboardType: TextInputType.phone,
                        onSaved: (value) => phone = value ?? '',
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: _styledInput("Email", Icons.email_outlined),
                        style: GoogleFonts.poppins(color: Color(0xFF2D3B89)),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) => email = value ?? '',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28),

                // Continue button
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
                    child: Text(
                      "Continue",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () async {
                      _formKey.currentState!.save();
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('selectedLanguage', selectedLanguage);
                      await prefs.setString('saved_language', selectedLanguage);
                      await prefs.setString('ageRange', ageRange);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DesignPage(childName: name, selectedLanguage: selectedLanguage, ageRange: ageRange, initialCategories: initialCategories),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}