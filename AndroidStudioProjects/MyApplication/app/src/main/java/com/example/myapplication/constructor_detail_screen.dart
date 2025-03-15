import 'package:flutter/material.dart';
import 'constructor.dart';

class ConstructorDetailScreen extends StatelessWidget {
  final Constructor constructor;

  ConstructorDetailScreen({required this.constructor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(constructor.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  constructor.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "📍 Location: ${constructor.location}",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "🏗️ Projects: ${constructor.projects}",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "📞 Contact: ${constructor.contact}",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
