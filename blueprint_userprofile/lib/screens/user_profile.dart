import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Edit Profile'),
          onPressed: () {
            Navigator.pushNamed(context, '/profile-edit');
          },
        ),
      ),
    );
  }
}
