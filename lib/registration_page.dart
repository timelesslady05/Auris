import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'design_page.dart';
import 'login_page.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'app_strings.dart';

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
  final AuthService _auth = AuthService();

  String name = '';
  String ageRange = '0-3';
  String phone = '';
  String email = '';
  String password = '';
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

  InputDecoration _styledInput(String label, IconData icon, {bool isPassword = false}) {
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

  bool _isLoading = false;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  String _getStr(String key) {
    return appStrings[selectedLanguage]?[key] ?? appStrings["en"]![key]!;
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
                   _getStr("welcome"),
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3B89),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _getStr("login_msg"),
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
                        enabled: !_isLoading,
                        decoration: _styledInput(_getStr("name"), Icons.child_care),
                        style: GoogleFonts.poppins(color: Color(0xFF2D3B89)),
                        validator: (val) => val!.isEmpty ? 'Enter a name' : null,
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
                        onChanged: _isLoading ? null : (value) => setState(() => ageRange = value.toString()),
                        decoration: _styledInput(_getStr("age"), Icons.cake),
                        dropdownColor: Colors.white,
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedLanguage,
                        decoration: _styledInput(_getStr("language"), Icons.language),
                        dropdownColor: Colors.white,
                        items: [
                          DropdownMenuItem(value: "en", child: Text("English", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                          DropdownMenuItem(value: "fr", child: Text("French", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                          DropdownMenuItem(value: "es", child: Text("Spanish", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                          DropdownMenuItem(value: "de", child: Text("German", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                          DropdownMenuItem(value: "it", child: Text("Italian", style: GoogleFonts.poppins(color: Color(0xFF2D3B89)))),
                        ],
                        onChanged: _isLoading ? null : (value) {
                          setState(() {
                            selectedLanguage = value!;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        enabled: !_isLoading,
                        decoration: _styledInput(_getStr("email"), Icons.email_outlined),
                        style: GoogleFonts.poppins(color: Color(0xFF2D3B89)),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                        onSaved: (value) => email = value ?? '',
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        enabled: !_isLoading,
                        decoration: _styledInput("Password", Icons.lock_outline),
                        style: GoogleFonts.poppins(color: Color(0xFF2D3B89)),
                        obscureText: true,
                        validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                        onSaved: (value) => password = value ?? '',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2D3B89),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: _isLoading ? null : () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() => _isLoading = true);
                        
                        dynamic result = await _auth.signUpWithEmail(email, password);
                        
                        if (result is UserCredential) {
                          String uid = result.user!.uid;
                          await DatabaseService(uid: uid).updateUserData(
                            name: name,
                            ageRange: ageRange,
                            language: selectedLanguage,
                          );

                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setString('selectedLanguage', selectedLanguage);
                          await prefs.setString('saved_language', selectedLanguage);
                          await prefs.setString('ageRange', ageRange);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DesignPage(
                                childName: name, 
                                selectedLanguage: selectedLanguage, 
                                ageRange: ageRange, 
                                initialCategories: initialCategories
                              ),
                            ),
                            (route) => false,
                          );
                        } else {
                          setState(() => _isLoading = false);
                          _showError(result.toString());
                        }
                      }
                    },
                    child: _isLoading 
                      ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                        _getStr("register"),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: _isLoading ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: GoogleFonts.poppins(color: Color(0xFFA3AED0)),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: GoogleFonts.poppins(
                              color: Color(0xFF4A90E2),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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