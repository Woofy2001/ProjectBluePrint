import 'package:flutter/material.dart';
import 'screens/blueprint_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blueprint App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlueprintScreen(),
    );
  }
}
