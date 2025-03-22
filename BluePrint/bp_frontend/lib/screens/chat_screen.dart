import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../models/project_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String projectId;
  final String projectName;

  const ChatScreen({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ProjectProvider>(
        context,
        listen: false,
      ).loadProjectChat(widget.projectId);
      _scrollToBottom();
    });
  }

  Future<void> _sendMessage(String userInput) async {
    if (userInput.trim().isEmpty) return;

    final projectProvider = Provider.of<ProjectProvider>(
      context,
      listen: false,
    );

    setState(() => _isProcessing = true);

    // Add user message first
    await projectProvider.addMessage(
      projectId: widget.projectId,
      text: userInput,
      sender: "user",
    );

    _controller.clear();
    _scrollToBottom();

    try {
      // Pass projectId along with userInput
      String imageUrl = await projectProvider.generateFloorPlan(
        widget.projectId, // Ensure projectId is passed
        userInput,
      );

      setState(() => _isProcessing = false);

      // Store bot response and generated image in Firestore
      _scrollToBottom();
    } catch (e) {
      setState(() => _isProcessing = false);

      await projectProvider.addMessage(
        projectId: widget.projectId,
        text: "❌ Error generating floor plan. Try again.",
        sender: "bot",
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.projectName)),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ProjectProvider>(
              builder: (context, projectProvider, _) {
                final project = projectProvider.projects.firstWhere(
                  (p) => p.id == widget.projectId,
                  orElse: () => ProjectModel.empty(),
                );

                if (project.messages.isEmpty) {
                  return const Center(child: Text("No messages found."));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: project.messages.length,
                  itemBuilder: (context, index) {
                    var message = project.messages[index];
                    return _chatBubble(
                      sender: message["sender"] ?? "Unknown",
                      text: message["text"] ?? "",
                      imageUrl: message["image"] ?? "",
                    );
                  },
                );
              },
            ),
          ),
          _chatInputField(),
        ],
      ),
    );
  }

  Widget _chatBubble({
    required String sender,
    required String text,
    String? imageUrl,
  }) {
    bool isUser = sender == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? Colors.blue.shade700 : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isUser ? Colors.white : Colors.black,
              ),
            ),
          ),
          if (imageUrl != null && imageUrl.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.broken_image, color: Colors.red),
                        );
                      },
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final userName =
                          user.displayName ?? user.email ?? "Anonymous";
                      await Provider.of<ProjectProvider>(
                        context,
                        listen: false,
                      ).shareToGallery(
                        userName: userName,
                        prompt: text,
                        imageUrl: imageUrl,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("✅ Shared to Community Gallery"),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.public),
                  label: const Text("Share to Gallery"),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _chatInputField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Describe your floor plan...",
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _sendMessage(_controller.text),
          ),
        ],
      ),
    );
  }
}
