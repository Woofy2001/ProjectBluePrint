import 'package:flutter/material.dart';
import 'community_gallery_page.dart';
import 'prompting_ui_page.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex; // Indicates the active tab
  final Widget child; // The screen content

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) {
      return; // Do nothing if the current tab is already selected
    }

    switch (index) {
      case 0: // Home (to be created later)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Home page coming soon!")),
        );
        break;

      case 1: // UI Prompting Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const PromptingUIPage(prompt: '')),
        );
        break;

      case 2: // Community Gallery Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CommunityGalleryPage()),
        );
        break;

      case 3: // Contact Contractors (to be created later)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Contact Contractors page coming soon!")),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, // Main screen content
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Prompting'),
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_library), label: 'Gallery'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Contact'),
        ],
      ),
    );
  }
}
