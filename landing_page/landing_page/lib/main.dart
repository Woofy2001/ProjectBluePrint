import 'package:flutter/material.dart';
import 'landing_screen.dart';  // Assuming this is your screen file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blueprint',
      theme: ThemeData(
        brightness: Brightness.dark, // Set app theme to dark mode
        primaryColor: const Color(0xFF0C2F8D),  // Dark blue primary color for logo text
        backgroundColor: const Color(0xFF2A2A2A), // Dark grey background
        scaffoldBackgroundColor: const Color(0xFF2A2A2A),
        textTheme: const TextTheme(
          headline1: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(color: Colors.white, fontSize: 18),
          bodyText2: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF444444), // Darker input field
          hintStyle: TextStyle(color: Colors.white70),
          prefixIconColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      home: const LandingScreen(),  // Your home screen
    );
  }
}
