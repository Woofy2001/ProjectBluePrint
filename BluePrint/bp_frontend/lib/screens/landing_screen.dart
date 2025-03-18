import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/drawer_menu.dart';
import 'chat_screen.dart';
import '../screens/user_settings.dart';
import '../providers/project_provider.dart';
import '../utils/api_service.dart';
import '../services/auth_service.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _hasText = _textController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _startChat() async {
    String userInput = _textController.text.trim();
    if (userInput.isEmpty) return;

    String projectName =
        "Project ${Provider.of<ProjectProvider>(context, listen: false).projects.length + 1}";

    Provider.of<ProjectProvider>(
      context,
      listen: false,
    ).addProject(projectName);
    await ApiService.generateFloorPlan(userInput);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                ChatScreen(initialMessage: userInput, projectId: projectName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    // ✅ Redirect user to login if not authenticated
    if (user == null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/auth');
      });
      return const Center(child: CircularProgressIndicator());
    }

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: DrawerMenu(
          projects: Provider.of<ProjectProvider>(context).projects,
          onProjectSelected: (project) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        ChatScreen(initialMessage: null, projectId: project),
              ),
            );
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "BluePrint",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserSettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 200),
            Image.asset(
              'assets/ai_bubble.png',
              width: 150,
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, size: 50, color: Colors.red);
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Hi there! I'm Blu, your house planning assistant.\nHow can I help you today?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            _chatInputField(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _chatInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Describe your floor plan...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: Colors.blue.shade900,
            onPressed: _startChat,
            child: Icon(_hasText ? Icons.send : Icons.mic, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
