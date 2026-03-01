import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String selectedLanguage = "en-IN";

  Map<String, List<Map<String, dynamic>>>? initialCategories;

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedLanguage != null) selectedLanguage = widget.initialSelectedLanguage!;
    if (widget.initialAgeRange != null) ageRange = widget.initialAgeRange!;
    initialCategories = widget.initialCategories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Parent Registration")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Child Name"),
                  onSaved: (value) => name = value ?? '',
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  value: ageRange,
                  items: ["0-3", "4-6", "7-9"]
                      .map((age) => DropdownMenuItem(
                            value: age,
                            child: Text(age),
                          ))
                      .toList(),
                  onChanged: (value) => ageRange = value.toString(),
                  decoration: InputDecoration(labelText: "Age Range"),
                ),
                SizedBox(height: 10),
                // language selection
                SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  value: selectedLanguage,
                  decoration: InputDecoration(labelText: "Select Language"),
                  items: [
                    DropdownMenuItem(value: "en-IN", child: Text("English")),
                    DropdownMenuItem(value: "hi-IN", child: Text("Hindi")),
                    DropdownMenuItem(value: "ta-IN", child: Text("Tamil")),
                    DropdownMenuItem(value: "te-IN", child: Text("Telugu")),
                    DropdownMenuItem(value: "kn-IN", child: Text("Kannada")),
                    DropdownMenuItem(value: "ml-IN", child: Text("Malayalam")),
                    DropdownMenuItem(value: "mr-IN", child: Text("Marathi")),
                    DropdownMenuItem(value: "bn-IN", child: Text("Bengali")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value!;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: "Phone Number"),
                  onSaved: (value) => phone = value ?? '',
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  onSaved: (value) => email = value ?? '',
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text("Continue"),
                  onPressed: () async {
                    _formKey.currentState!.save();
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('selectedLanguage', selectedLanguage);
                    await prefs.setString('ageRange', ageRange);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DesignPage(childName: name, selectedLanguage: selectedLanguage, ageRange: ageRange, initialCategories: initialCategories),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}