import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo "BluePrint"
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Blue",
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "Print",
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Email Input
              TextField(
                decoration: InputDecoration(
                  labelText: "Email or username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 15),

              // Password Input
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: Icon(Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 20),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Sign in",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Forgot Password & Create Account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Forgotten ", style: GoogleFonts.poppins(fontSize: 14)),
                  Text(
                    "Password",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  Text(
                    "Create account",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Divider "Or"
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[400])),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Or"),
                  ),
                  Expanded(child: Divider(color: Colors.grey[400])),
                ],
              ),
              const SizedBox(height: 15),

              // Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.google,
                      size: 28,
                      color: Colors.red,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.facebook,
                      size: 28,
                      color: Colors.blue,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.apple,
                      size: 28,
                      color: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
