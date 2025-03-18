import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // ✅ Login Function (Fixed Firestore Fetching)
  Future<void> signIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;
      debugPrint("✅ Sign-in successful: $email (UID: $uid)");

      // ✅ Fetch User Data from Firestore using UID
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!doc.exists) {
        throw "User does not exist in Firestore!";
      }

      // ✅ Navigate to Landing Screen
      Navigator.pushReplacementNamed(context, '/landing');
    } on FirebaseAuthException catch (e) {
      debugPrint("🔥 SignIn Error: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Failed: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ✅ Logout Function
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/auth');
  }

  // ✅ Register Function (Prevents Duplicate Emails, Fixes Firestore Structure)
  Future<void> registerUser({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required double latitude,
    required double longitude,
    required BuildContext context,
  }) async {
    try {
      // 🔥 Check if the email is already registered
      final signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        debugPrint("⚠️ Email already in use: $email");

        // ✅ Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email already in use. Please log in instead."),
            backgroundColor: Colors.red,
          ),
        );

        // ✅ Redirect to Login screen
        Navigator.pushReplacementNamed(context, '/auth');
        return;
      }

      // 🔥 Create User in Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // 🔥 Store User Data in Firestore (No Password Storage)
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "uid": uid,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": Timestamp.now(),
      });

      debugPrint("✅ User registered successfully (UID: $uid)");

      // ✅ Navigate to Landing Screen
      Navigator.pushReplacementNamed(context, '/landing');
    } on FirebaseAuthException catch (e) {
      debugPrint("🔥 Registration Error: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Signup Failed: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
