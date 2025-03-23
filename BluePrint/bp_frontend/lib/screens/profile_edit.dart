import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:ui';
import '../models/user_profile_data.dart';

class ProfileEdit extends StatefulWidget {
  final UserProfileData user;

  const ProfileEdit({super.key, required this.user});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  void _viewProfilePicture() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "View Profile",
      pageBuilder:
          (_, __, ___) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.black.withOpacity(0.6),
                alignment: Alignment.center,
                child: InteractiveViewer(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            _profileImage == null
                                ? const AssetImage('assets/images/profile.jpg')
                                    as ImageProvider
                                : FileImage(File(_profileImage!.path)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                  _viewProfilePicture();
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

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegExp = RegExp(r'^\+?\d[\d\s]{6,}$');
    if (!phoneRegExp.hasMatch(value.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 140, 20, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage:
                              _profileImage == null
                                  ? const AssetImage(
                                        'assets/images/profile.jpg',
                                      )
                                      as ImageProvider
                                  : FileImage(File(_profileImage!.path)),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                              onPressed: _showBottomSheet,
                              tooltip: 'Change Profile Picture',
                              padding: EdgeInsets.zero,
                              splashRadius: 20,
                            ),
                          ),
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
                    TextFormField(
                      controller: nameController,
                      decoration: _fieldDecoration(
                        'New username',
                        Icons.person_outline,
                      ),
                      validator:
                          (value) => _validateRequired(value, 'Username'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.user.email,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneController,
                      decoration: _fieldDecoration(
                        'New contact number',
                        Icons.phone_outlined,
                      ),
                      validator: _validatePhone,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: addressController,
                      decoration: _fieldDecoration(
                        'New address',
                        Icons.location_on_outlined,
                      ),
                      validator: (value) => _validateRequired(value, 'Address'),
                    ),
                  ],
                ),
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
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final user = FirebaseAuth.instance.currentUser;
                        String? downloadUrl;

                        if (_profileImage != null && user != null) {
                          final ref = FirebaseStorage.instance.ref().child(
                            'user_profiles/${user.uid}.jpg',
                          );
                          await ref.putFile(File(_profileImage!.path));
                          downloadUrl = await ref.getDownloadURL();
                        }

                        if (user != null) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update({
                                'first_name':
                                    nameController.text.trim().split(' ').first,
                                'last_name': nameController.text
                                    .trim()
                                    .split(' ')
                                    .skip(1)
                                    .join(' '),
                                'contact': phoneController.text.trim(),
                                'location': addressController.text.trim(),
                                if (downloadUrl != null)
                                  'profileImage': downloadUrl,
                              });
                        }

                        Navigator.pop(
                          context,
                          UserProfileData(
                            name: nameController.text.trim(),
                            email: widget.user.email,
                            phone: phoneController.text.trim(),
                            address: addressController.text.trim(),
                          ),
                        );
                      }
                    },
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
