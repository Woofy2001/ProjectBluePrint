import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';

class VendorFormScreen extends StatefulWidget {
  const VendorFormScreen({super.key});

  @override
  _VendorFormScreenState createState() => _VendorFormScreenState();
}

class _VendorFormScreenState extends State<VendorFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();

  final TextEditingController _service1Controller = TextEditingController();
  final TextEditingController _service2Controller = TextEditingController();
  final TextEditingController _service3Controller = TextEditingController();

  bool _locationEnabled = false;
  Position? _currentPosition;
  File? _image;
  bool _isSubmitting = false;

  /// ✅ **Get User Location**
  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      _currentPosition = await Geolocator.getCurrentPosition();
      setState(() {});
    } catch (e) {
      print("🔥 Location Error: $e");
    }
  }

  /// ✅ **Pick Image**
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  /// ✅ **Upload Image & Return URL**
  Future<String> _uploadImage(File imageFile, String vendorId) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child(
        "vendors/$vendorId.jpg",
      );
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("🔥 Error uploading image: $e");
      return "";
    }
  }

  /// ✅ **Generate Unique Vendor ID**
  Future<String> _getNewVendorId() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("vendors").get();
      int nextId = snapshot.docs.length + 1;
      return "vendorId$nextId";
    } catch (e) {
      print("🔥 Error generating Vendor ID: $e");
      return "vendorId999"; // Fallback ID
    }
  }

  /// ✅ **Submit Form**
  Future<void> _submitForm() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Vendor Name and Phone are required."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User not logged in."),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    String vendorId = await _getNewVendorId();
    String imageUrl = "";

    if (_image != null) {
      imageUrl = await _uploadImage(_image!, vendorId);
    }

    List<String> services = [];
    if (_service1Controller.text.isNotEmpty) {
      services.add(_service1Controller.text);
    }
    if (_service2Controller.text.isNotEmpty) {
      services.add(_service2Controller.text);
    }
    if (_service3Controller.text.isNotEmpty) {
      services.add(_service3Controller.text);
    }

    Map<String, dynamic> vendorData = {
      "name": _nameController.text,
      "phone": _phoneController.text,
      "whatsapp": _whatsappController.text,
      "specialization": _specializationController.text,
      "description": _descriptionController.text,
      "services": services,
      "latitude":
          _locationEnabled && _currentPosition != null
              ? _currentPosition!.latitude
              : null,
      "longitude":
          _locationEnabled && _currentPosition != null
              ? _currentPosition!.longitude
              : null,
      "imageUrl": imageUrl,
      "ownerId": userId,
    };

    try {
      await FirebaseFirestore.instance
          .collection("vendors")
          .doc(vendorId)
          .set(vendorData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Advertisement Submitted Successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      _resetForm();
    } catch (e) {
      print("🔥 Firestore Write Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error submitting advertisement."),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  /// ✅ **Reset Form After Submission**
  void _resetForm() {
    _nameController.clear();
    _phoneController.clear();
    _whatsappController.clear();
    _specializationController.clear();
    _descriptionController.clear();
    _service1Controller.clear();
    _service2Controller.clear();
    _service3Controller.clear();
    setState(() {
      _image = null;
      _currentPosition = null;
      _locationEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vendor Registration")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _image != null
                ? CircleAvatar(backgroundImage: FileImage(_image!), radius: 50)
                : CircleAvatar(radius: 50, child: Icon(Icons.camera_alt)),
            TextButton(onPressed: _pickImage, child: Text("Pick Image")),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Vendor Name"),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: _whatsappController,
              decoration: InputDecoration(labelText: "WhatsApp"),
            ),
            TextField(
              controller: _specializationController,
              decoration: InputDecoration(labelText: "Specialization"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: _service1Controller,
              decoration: InputDecoration(labelText: "Service 1 (Optional)"),
            ),
            TextField(
              controller: _service2Controller,
              decoration: InputDecoration(labelText: "Service 2 (Optional)"),
            ),
            TextField(
              controller: _service3Controller,
              decoration: InputDecoration(labelText: "Service 3 (Optional)"),
            ),
            Row(
              children: [
                Checkbox(
                  value: _locationEnabled,
                  onChanged:
                      (value) => setState(() => _locationEnabled = value!),
                ),
                Text("Allow Location"),
              ],
            ),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text("Get Location"),
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child:
                  _isSubmitting
                      ? CircularProgressIndicator()
                      : Text("Submit Advertisement"),
            ),
          ],
        ),
      ),
    );
  }
}
