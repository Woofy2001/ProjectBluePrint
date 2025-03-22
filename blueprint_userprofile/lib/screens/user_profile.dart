import 'package:flutter/material.dart';
import '../models/user_profile_data.dart';
import 'profile_edit.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserProfileData user = UserProfileData(
    name: 'Jhon Petersen',
    email: 'john.petersen100@gmail.com',
    phone: '+94 070 4347 960',
    address: '128 Maple Avenue, Brooklyn, NY',
  );

  void updateUser(UserProfileData updatedUser) {
    setState(() {
      user = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Back', style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileEdit(user: user),
                        ),
                      );
                      if (result != null && result is UserProfileData) {
                        updateUser(result);
                      }
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Avatar
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(height: 20),

              // Name
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // Email
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(
                  user.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(user.email),
              ),

              // Phone
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: Text(user.phone),
              ),

              // Address
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(user.address),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
