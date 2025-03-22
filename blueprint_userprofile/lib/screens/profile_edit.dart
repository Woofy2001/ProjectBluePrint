import 'package:flutter/material.dart';
import '../models/user_profile_data.dart';

class ProfileEdit extends StatefulWidget {
  final UserProfileData user;

  const ProfileEdit({super.key, required this.user});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    phoneController = TextEditingController(text: widget.user.phone);
    addressController = TextEditingController(text: widget.user.address);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void saveAndReturn() {
    Navigator.pop(
      context,
      UserProfileData(
        name: nameController.text,
        email: widget.user.email,
        phone: phoneController.text,
        address: addressController.text,
      ),
    );
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
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Back', style: TextStyle(fontSize: 16)),
                  ),
                  GestureDetector(
                    onTap: saveAndReturn,
                    child: const Text(
                      'Done',
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
                widget.user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Editable Fields
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: 'New username',
                  filled: true,
                  fillColor: Color(0xFFF0F0F0),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                widget.user.email,
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_outlined),
                  hintText: 'New contact number',
                  filled: true,
                  fillColor: Color(0xFFF0F0F0),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_on_outlined),
                  hintText: 'New address',
                  filled: true,
                  fillColor: Color(0xFFF0F0F0),
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
