import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'app_strings.dart';
import 'child_page.dart';
import 'design_page.dart';
import 'registration_page.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();
  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  String currentLanguage = "en";
  String selectedLanguage = "en";
  String selectedAge = "0-3";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "User");
    loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await DatabaseService(uid: user!.uid).getUserDoc();
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _nameController.text = data['name'] ?? 'User';
            selectedAge = data['ageRange'] ?? '0-3';
            selectedLanguage = data['language'] ?? 'en';
            currentLanguage = selectedLanguage;
          });
          
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("saved_language", selectedLanguage);
          await prefs.setString("ageRange", selectedAge);
        }
      } catch (e) {
        print("Error loading profile: $e");
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _styledInput(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Color(0xFF4A90E2)),
      filled: true,
      fillColor: Color(0xFFF4F7FE),
      labelStyle: GoogleFonts.poppins(color: Color(0xFFA3AED0), fontSize: 14),
      floatingLabelStyle: GoogleFonts.poppins(color: Color(0xFF4A90E2), fontWeight: FontWeight.w600),
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
        borderSide: BorderSide(color: Color(0xFF4A90E2), width: 1.5),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2D3B89),
        ),
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, {VoidCallback? onTap, Color color = const Color(0xFF2D3B89)}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2D3B89),
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Color(0xFFA3AED0), size: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    String _getStr(String key) {
      return appStrings[selectedLanguage]?[key] ?? appStrings["en"]![key]!;
    }

    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Color(0xFFF4F7FE),
      appBar: AppBar(
        title: Text(_getStr("profile")),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2D3B89), Color(0xFF4A90E2)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4A90E2).withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(Icons.edit, size: 18, color: Color(0xFF4A90E2)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              _sectionTitle(_getStr("account_info")),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: _styledInput(_getStr("name"), Icons.badge),
                      style: GoogleFonts.poppins(fontSize: 15, color: Color(0xFF2D3B89)),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: user?.email ?? "Not logged in",
                      readOnly: true,
                      decoration: _styledInput(_getStr("email"), Icons.email),
                      style: GoogleFonts.poppins(fontSize: 15, color: Color(0xFFA3AED0)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              _sectionTitle(_getStr("configuration")),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedAge,
                      decoration: _styledInput(_getStr("age"), Icons.cake),
                      dropdownColor: Colors.white,
                      items: ["0-3", "4-6", "7-9", "10-13", "14-16"].map((val) => 
                        DropdownMenuItem(value: val, child: Text(val, style: GoogleFonts.poppins(fontSize: 15)))
                      ).toList(),
                      onChanged: (v) => setState(() => selectedAge = v!),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedLanguage,
                      decoration: _styledInput(_getStr("language"), Icons.language),
                      dropdownColor: Colors.white,
                      items: ["en", "fr", "es", "de", "it"].map((val) => 
                        DropdownMenuItem(value: val, child: Text(val == "en" ? "English" : val.toUpperCase(), style: GoogleFonts.poppins(fontSize: 15)))
                      ).toList(),
                      onChanged: (v) => setState(() => selectedLanguage = v!),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              _sectionTitle(_getStr("more_options")),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    _buildOptionTile(Icons.info_outline, _getStr("about")),
                    Divider(height: 1, indent: 60),
                    _buildOptionTile(Icons.privacy_tip_outlined, _getStr("privacy")),
                    Divider(height: 1, indent: 60),
                    _buildOptionTile(Icons.help_outline, _getStr("help")),
                    Divider(height: 1, indent: 60),
                    _buildOptionTile(Icons.logout, _getStr("sign_out"), 
                      color: Colors.redAccent,
                      onTap: () async {
                        await _auth.signOut();
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => RegistrationPage()), (r) => false
                        );
                      }
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2D3B89),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: () async {
                    if (user != null) {
                      await DatabaseService(uid: user!.uid).updateUserData(
                        name: _nameController.text,
                        ageRange: selectedAge,
                        language: selectedLanguage,
                      );
                      
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString("saved_language", selectedLanguage);
                      await prefs.setString("selectedLanguage", selectedLanguage);
                      await prefs.setString("ageRange", selectedAge);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Profile updated successfully!"), backgroundColor: Color(0xFF2D3B89))
                      );
                      
                      Navigator.push(context, MaterialPageRoute(builder: (c) => ChildPage(
                        childName: _nameController.text,
                        ageRange: selectedAge,
                      )));
                    }
                  },
                  child: Text(_getStr("save"), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

