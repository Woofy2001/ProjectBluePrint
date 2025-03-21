import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'success_screen.dart';

class VerificationScreen extends StatefulWidget {
  final Map<String, dynamic> vendorData;
  final User user;

  const VerificationScreen({
    super.key,
    required this.vendorData,
    required this.user,
  });

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isVerified = false;
  bool isChecking = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerification();
  }

  // ✅ Function to reload user and check if email is verified
  Future<void> checkEmailVerification() async {
    setState(() {
      isChecking = true;
    });

    await widget.user.reload(); // 🔄 Refresh user authentication state
    User? updatedUser = _auth.currentUser; // 🔄 Get the updated user details

    if (updatedUser != null && updatedUser.emailVerified) {
      setState(() {
        isVerified = true;
      });

      // 🚀 Navigate to the next screen after verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => SuccessScreen(
                vendorData: widget.vendorData,
              ), // ✅ Pass vendorData
        ),
      );
    } else {
      setState(() {
        isVerified = false;
      });
    }

    setState(() {
      isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Email Verification")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "A verification email has been sent to ${widget.user.email}.\nPlease verify before proceeding.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            isChecking
                ? CircularProgressIndicator() // 🔄 Show a loading indicator
                : ElevatedButton(
                  onPressed: checkEmailVerification,
                  child: Text("I've Verified My Email"),
                ),
            if (!isVerified)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Please verify your email before proceeding.",
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
