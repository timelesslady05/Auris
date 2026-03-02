import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AurisApp());
}

class AurisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auris',
      theme: ThemeData(
        primaryColor: Color(0xFF2D3B89),
        scaffoldBackgroundColor: Color(0xFFF4F7FE),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF2D3B89),
          secondary: Color(0xFF4A90E2),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: Color(0xFF2D3B89),
        ),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          headlineLarge: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3B89),
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3B89),
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
            color: Color(0xFF2D3B89),
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            color: Color(0xFFA3AED0),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3B89),
          ),
          iconTheme: IconThemeData(color: Color(0xFF2D3B89)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2D3B89),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            elevation: 4,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: GoogleFonts.poppins(color: Color(0xFFA3AED0)),
          hintStyle: GoogleFonts.poppins(color: Color(0xFFA3AED0)),
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
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: GoogleFonts.poppins(color: Color(0xFF2D3B89)),
        ),
        cardTheme: CardThemeData(
          elevation: 8,
          shadowColor: Color(0xFF2D3B89).withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}