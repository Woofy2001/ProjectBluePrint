import 'package:flutter/material.dart';
import 'pages/community_gallery_page.dart';
import 'pages/prompting_ui_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blueprint App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/gallery', // Set the initial route to Community Gallery
      routes: {
        '/gallery': (context) => const CommunityGalleryPage(),
        '/prompt': (context) =>
            const PromptingUIPage(prompt: ""), // Provide a default empty prompt
      },
    );
  }
}
