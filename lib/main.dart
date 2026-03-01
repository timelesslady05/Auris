import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(AurisApp());
}

class AurisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auris',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),  // 
    );
  }
}