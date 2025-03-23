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
    name: 'Kusal Mendis',
    email: 'john.petersen100@gmail.com',
    phone: '+94 070 4347 960',
    address: 'Moratuwa,Sri Lanka',
  );

  void updateUser(UserProfileData updatedUser) {
    setState(() {
      user = updatedUser;
    });
  }

  void _logout() {
    debugPrint('Logout button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 140, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.person_outline),
                    title: Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user.email),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.phone_outlined),
                    title: Text(user.phone),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(user.address),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3057E1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
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
            ),
          ],
        ),
      ),
    );
  }
}
