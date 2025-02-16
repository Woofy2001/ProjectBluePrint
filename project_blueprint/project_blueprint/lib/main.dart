import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';

void main() {
  runApp(const BluePrintApp());
}

class BluePrintApp extends StatelessWidget {
  const BluePrintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BluePrint',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const LandingScreen(),
    );
  }
}
