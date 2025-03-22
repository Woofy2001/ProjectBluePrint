import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(vertical: 10), // Add margin for spacing
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300], // Light grey for better visibility
        borderRadius: BorderRadius.circular(20),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.black), // Black text for visibility
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Colors.black), // Black search icon
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.black54), // Darker hint color
          border: InputBorder.none,
        ),
      ),
    );
  }
}
