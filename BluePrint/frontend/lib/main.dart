import 'package:flutter/material.dart';
import 'floor_plan_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blueprint App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FloorPlanScreen(), // Redirects to Floor Plan Screen
    );
  }
}
