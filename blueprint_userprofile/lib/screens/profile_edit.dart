import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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

  XFile? _profileImage;

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
      });
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 200,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Change Profile Picture'),
                onTap: () {
                  _pickImage();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_red_eye),
                title: const Text('View Profile Picture'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _fieldDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF2F2F2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                80,
                20,
                20,
              ), // shifted down
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            _profileImage == null
                                ? AssetImage('assets/images/profile.jpg')
                                    as ImageProvider
                                : FileImage(File(_profileImage!.path)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: _showBottomSheet,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: nameController,
                    decoration: _fieldDecoration(
                      'New username',
                      Icons.person_outline,
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
                    decoration: _fieldDecoration(
                      'New contact number',
                      Icons.phone_outlined,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: addressController,
                    decoration: _fieldDecoration(
                      'New address',
                      Icons.location_on_outlined,
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
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Back', style: TextStyle(fontSize: 16)),
                  ),
                  GestureDetector(
                    onTap:
                        () => Navigator.pop(
                          context,
                          UserProfileData(
                            name: nameController.text,
                            email: widget.user.email,
                            phone: phoneController.text,
                            address: addressController.text,
                          ),
                        ),
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
            ),
          ],
        ),
      ),
    );
  }
}
