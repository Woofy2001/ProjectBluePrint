import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'providers/project_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/landing_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase Initialized Successfully!");

    // 🔹 Enable Firestore Debugging & Offline Mode
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true, // ✅ Enable offline support
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // ✅ Unlimited cache size
    );

    print("✅ Firestore Logging Enabled!");

  } catch (e) {
    print("❌ Firebase Initialization Error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            print("✅ AuthService Provider Initialized");
            return AuthService();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            print("✅ ProjectProvider Initialized");
            return ProjectProvider();
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Blueprint',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => Consumer<AuthService>(
            builder: (context, authService, child) {
              if (authService.currentUser != null) {
                print("🔄 User is Logged In - Navigating to LandingScreen");
                return const LandingScreen();
              } else {
                print("🔄 No User Found - Navigating to AuthScreen");
                return const AuthScreen();
              }
            },
          ),
          '/auth': (context) {
            print("🔄 Navigating to AuthScreen");
            return const AuthScreen();
          },
          '/landing': (context) {
            print("🔄 Navigating to LandingScreen");
            return const LandingScreen();
          },
        },
      ),
    );
  }
}
