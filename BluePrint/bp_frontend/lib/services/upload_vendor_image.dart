import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

Future<void> uploadVendorImage(String vendorId) async {
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
    TaskSnapshot snapshot =
        await FirebaseStorage.instance.ref(fileName).putFile(imageFile);

    // ✅ Get the public URL dynamically
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print("✅ Image uploaded successfully: $downloadUrl");

    // ✅ Store the public URL in Firestore under the vendor's document
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .update({
      'imageUrl': downloadUrl, // Public URL stored in Firestore
    });

    print("✅ Vendor image URL updated in Firestore!");
  } catch (e) {
    print("⚠️ Error uploading image: $e");
  }
}
