import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class VendorImageUploader {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Function to Pick Image and Upload to Firebase Storage
  static Future<void> uploadVendorImage(String vendorId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print("❌ No image selected.");
      return;
    }

    File imageFile = File(pickedFile.path);
    String fileName = "vendors/$vendorId.jpg";

    try {
      // ✅ Upload image to Firebase Storage
      TaskSnapshot snapshot = await _storage.ref(fileName).putFile(imageFile);

      // ✅ Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("✅ Image uploaded: $downloadUrl");

      // ✅ Store the URL in Firestore under the vendor's document
      await _firestore.collection('vendors').doc(vendorId).update({
        'imageUrl': downloadUrl,
      });

      print("✅ Vendor image updated in Firestore!");
    } catch (e) {
      print("⚠️ Error uploading image: $e");
    }
  }
}
