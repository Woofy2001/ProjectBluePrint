import 'package:flutter/material.dart';

class FloorPlanScreen extends StatelessWidget {
  final String imageUrl;

  const FloorPlanScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "BluePrint",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(child: Image.network(imageUrl)),
    );
  }
}
