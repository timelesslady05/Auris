import 'package:flutter/material.dart';
import 'design_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String ageRange = '0-3';
  String phone = '';
  String email = '';

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
                  onPressed: () {
                    _formKey.currentState!.save();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DesignPage(childName: name),
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