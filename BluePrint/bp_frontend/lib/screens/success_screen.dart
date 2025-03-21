import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final Map<String, dynamic> vendorData; // ✅ Accept vendorData

  const SuccessScreen({super.key, required this.vendorData}); // ✅ Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verification Successful")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified, color: Colors.green, size: 80),
            SizedBox(height: 20),
            Text(
              "Your email has been successfully verified!\nWelcome, ${vendorData['name']}",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Home Screen or Vendor Dashboard
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
