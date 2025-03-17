import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // ✅ Import Home Screen
import 'screens/success_screen.dart'; // ✅ Import Success Screen
import 'screens/vendor_list_screen.dart'; // ✅ Import Vendor List Screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ✅ Debugging: Check email verification status
  await debugEmailVerification();

  runApp(MyApp());
}

// ✅ Function to Check Email Verification Status
Future<void> debugEmailVerification() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  if (user == null) {
    print("⚠️ No user is logged in");
    return;
  }

  await user.reload(); // 🔄 Refresh user session
  user = auth.currentUser; // Get updated user state

  bool isVerified = user?.emailVerified ?? false; // ✅ Fully Null-Safe Access
  print("🔍 Email Verified: $isVerified"); // ✅ Log to console
}

// ✅ Function to Add Vendors to Firestore (Call ONLY Once)
Future<void> addVendors() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  await firestore.collection('vendors').doc('vendorId1').set({
    "name": "Richard Mason",
    "specialization": "Architect",
    "phone": "+94771234567",
    "whatsapp": "+94771234567",
    "description": "Experienced architect with expertise in modern design.",
    "services": ["Architectural Design", "Project Planning", "3D Modeling"],
    "imageUrl": "https://your-image-link.com/profile.jpg",
  });

  await firestore.collection('vendors').doc('vendorId2').set({
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
      initialRoute:
          '/vendorList', // ✅ Changed initial screen to VendorListScreen
      routes: {
        '/': (context) => HomeScreen(), // ✅ Home Screen
        '/vendorList': (context) =>
            VendorListScreen(), // ✅ Vendor List Screen (Now the first screen)
        '/success': (context) =>
            SuccessScreen(vendorData: {}), // ✅ Success Screen
      },
    );
  }
}
