import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'screens/vendor_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ✅ Call this function only once to add vendors
  await addVendors();

  runApp(MyApp());
}

Future<void> addVendors() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseFirestore.instance.collection('vendors').doc('vendorId1').set({
    "name": "Richard Mason",
    "specialization": "Architect",
    "phone": "+94771234567",
    "whatsapp": "+94771234567",
    "description": "Experienced architect with expertise in modern design.",
    "services": ["Architectural Design", "Project Planning", "3D Modeling"],
    "imageUrl": "https://your-image-link.com/profile.jpg",
  });

  FirebaseFirestore.instance.collection('vendors').doc('vendorId2').set({
    "name": "BuildWell Supplies",
    "specialization": "Construction Materials",
    "phone": "+94772345678",
    "whatsapp": "+94772345678",
    "description": "Leading supplier of high-quality construction materials.",
    "services": ["Cement Supply", "Bricks", "Steel Structures"],
    "imageUrl": "https://your-image-link.com/vendor.jpg",
  });

  print("✅ Vendors Added to Firestore");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blueprint App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VendorListScreen(),
    );
  }
}
