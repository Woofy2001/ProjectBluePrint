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

  // ✅ Prevent Duplicate Firebase Initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Blueprint',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/':
              (context) => Consumer<AuthService>(
                builder: (context, authService, child) {
                  return authService.currentUser != null
                      ? const LandingScreen()
                      : const AuthScreen();
                },
              ),
          '/auth': (context) => const AuthScreen(),
          '/landing': (context) => const LandingScreen(),
        },
      ),
    );
  }
}
