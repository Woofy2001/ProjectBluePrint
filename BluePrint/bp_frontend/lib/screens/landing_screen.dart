import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/drawer_menu.dart';
import 'chat_screen.dart';
import '../providers/project_provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectProvider = Provider.of<ProjectProvider>(
        context,
        listen: false,
      );
      if (projectProvider.projects.isEmpty) {
        projectProvider.fetchUserProjects();
      }
    });

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

  /// ✅ **Starts a new chat session**
  void _startChat() async {
    String userInput = _textController.text.trim();
    if (userInput.isEmpty) return;

    final projectProvider = Provider.of<ProjectProvider>(
      context,
      listen: false,
    );

    // ✅ Generate a unique project name
    String projectName = "Project ${projectProvider.projects.length + 1}";

    // ✅ Create project and add message
    await projectProvider.addProjectAndMessage(projectName, userInput, null);

    var existingProject = await projectProvider.getProjectByName(projectName);

    if (existingProject != null) {
      // ✅ Navigate to chat screen with correct projectId
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ChatScreen(
                projectId: existingProject.id,
                projectName: existingProject.name,
              ),
        ),
      );
    } else {
      print("❌ Error: Project not found after creation.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: DrawerMenu(
          onProjectSelected: (projectId) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  final projectProvider = Provider.of<ProjectProvider>(
                    context,
                    listen: false,
                  );
                  final selectedProject = projectProvider.projects.firstWhere(
                    (p) => p.id == projectId,
                  );
                  return ChatScreen(
                    projectId: selectedProject.id,
                    projectName: selectedProject.name,
                  );
                },
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
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 200),
            const Text(
              "Hi there! I'm Blu, your house planning assistant.\nHow can I help you today?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const Spacer(),
            _chatInputField(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// ✅ **Chat Input Field with validation**
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
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: Colors.blue.shade900,
            onPressed: _hasText ? _startChat : null, // ✅ Prevent empty messages
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
