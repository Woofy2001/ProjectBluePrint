import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  Map<String, dynamic>? userData;
  bool _isLoading = true; // Start with loading state

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = Provider.of<AuthService>(context, listen: false).currentUser;
      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .get();
        if (doc.exists) {
          setState(() {
            userData = doc.data();
          });
        } else {
          // ✅ Handle missing user data
          setState(() {
            userData = {
              "username": "N/A",
              "email": user.email,
              "location": "N/A",
              "contact": "N/A",
            };
          });
          debugPrint("⚠️ No user data found in Firestore!");
        }
      }
    } catch (e) {
      debugPrint("🔥 Firestore Error: $e");
    }
    setState(() => _isLoading = false);
  }

  void _logout() async {
    await Provider.of<AuthService>(context, listen: false).signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Settings")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(userData?["username"] ?? "N/A"),
                      subtitle: Text(userData?["email"] ?? "N/A"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(userData?["location"] ?? "N/A"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(userData?["contact"] ?? "N/A"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
