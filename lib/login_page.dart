import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'design_page.dart';
import 'registration_page.dart';
import 'app_strings.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  bool _isLoading = false;
  String selectedLanguage = "en";

  @override
  void initState() {
    super.initState();
    _loadLang();
  }

  Future<void> _loadLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('selectedLanguage') ?? 'en';
    });
  }

  String _getStr(String key) {
    return appStrings[selectedLanguage]?[key] ?? appStrings["en"]![key]!;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
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
                SizedBox(height: 50),
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
                SizedBox(height: 40),

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
                        validator: (val) => val!.isEmpty ? 'Enter your password' : null,
                        onSaved: (value) => password = value ?? '',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28),

                // Login button
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
                        
                        dynamic result = await _auth.signInWithEmail(email, password);
                        if (result is UserCredential) {
                          String uid = result.user!.uid;
                          DocumentSnapshot userDoc = await DatabaseService(uid: uid).getUserDoc();
                          
                          if (userDoc.exists) {
                            Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
                            String name = data['name'] ?? '';
                            String ageRange = data['ageRange'] ?? '0-3';
                            String language = data['language'] ?? 'en';
                            Map<String, dynamic>? vocabData = data['vocabulary'];

                            Map<String, List<Map<String, dynamic>>>? categories;
                            if (vocabData != null) {
                              categories = {};
                              vocabData.forEach((cat, list) {
                                final items = (list as List).map((e) {
                                  return {
                                    'text': e['text'],
                                    'icon': IconData(e['icon'] as int, fontFamily: 'MaterialIcons')
                                  };
                                }).toList();
                                categories![cat] = List<Map<String, dynamic>>.from(items);
                              });
                              
                              // Persist vocabulary locally
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setString('vocab', jsonEncode(vocabData));
                            }
                            
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('selectedLanguage', language);
                            await prefs.setString('saved_language', language);
                            await prefs.setString('ageRange', ageRange);

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DesignPage(
                                  childName: name, 
                                  selectedLanguage: language, 
                                  ageRange: ageRange,
                                  initialCategories: categories,
                                ),
                              ),
                              (route) => false,
                            );
                          } else {
                            setState(() => _isLoading = false);
                            _showError("User profile not found.");
                          }
                        } else {
                          setState(() => _isLoading = false);
                          _showError(result.toString());
                        }
                      }
                    },
                    child: _isLoading 
                      ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                        _getStr("login"),
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
                        MaterialPageRoute(builder: (context) => RegistrationPage()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: GoogleFonts.poppins(color: Color(0xFFA3AED0)),
                        children: [
                          TextSpan(
                            text: "Register",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
