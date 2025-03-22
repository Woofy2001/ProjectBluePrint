import 'package:flutter/material.dart';
import 'screens/community_gallery_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blueprint Gallery',
      theme: ThemeData(
        brightness: Brightness.light, // Set Light Theme
        primarySwatch: Colors.blue,
        fontFamily: 'InterTight',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const CommunityGalleryScreen(),
    );
  }
}
