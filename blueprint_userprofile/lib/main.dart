import 'package:flutter/material.dart';
import 'screens/user_profile.dart';
import 'screens/profile_edit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blueprint User Profile',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const UserProfile(),
        '/profile-edit': (context) => const ProfileEdit(),
      },
    );
  }
}
