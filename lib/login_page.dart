import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'design_page.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';

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
                  "Welcome Back! 👋",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3B89),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Sign in to continue using Auris",
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
                        decoration: _styledInput("Email", Icons.email_outlined),
                        style: GoogleFonts.poppins(color: Color(0xFF2D3B89)),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                        onSaved: (value) => email = value ?? '',
                      ),
                      SizedBox(height: 16),
                      TextFormField(
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
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2D3B89),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                    ),
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        
                        dynamic result = await _auth.signInWithEmail(email, password);
                        if (result != null) {
                          String uid = result.user.uid;
                          DocumentSnapshot userDoc = await DatabaseService(uid: uid).getUserDoc();
                          
                          if (userDoc.exists) {
                            Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
                            String name = data['name'] ?? '';
                            String ageRange = data['ageRange'] ?? '0-3';
                            String language = data['language'] ?? 'en';
                            
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('selectedLanguage', language);
                            await prefs.setString('saved_language', language);
                            await prefs.setString('ageRange', ageRange);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DesignPage(childName: name, selectedLanguage: language, ageRange: ageRange),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login Failed. Check credentials.")),
                          );
                        }
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
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
