import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
// import 'screens/signin_screen.dart'; // Uncomment when you add SignIn

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blueprint',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const OnboardingScreen(),
      routes: {
        // '/signin': (context) => const SignInScreen(), // Update when SignInScreen is created
      },
    );
  }
}
