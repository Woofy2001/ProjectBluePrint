import 'package:flutter/material.dart';
import 'custom_bottom_navigation.dart';

class PromptingUIPage extends StatefulWidget {
  final String prompt;

  const PromptingUIPage({super.key, required this.prompt});

  @override
  _PromptingUIPageState createState() => _PromptingUIPageState();
}

class _PromptingUIPageState extends State<PromptingUIPage> {
  final TextEditingController _controller = TextEditingController();

  // Simulated list of chat messages
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    // Add the initial assistant message
    messages.add({
      "role": "assistant",
      "content":
          "I'm your virtual house planning assistant.\nLet's design your perfect home together!\nShare your preferences, and I'll create a custom house plan just for you."
    });
    // Add the prompt passed from the previous screen
    if (widget.prompt.isNotEmpty) {
      messages.add({"role": "user", "content": widget.prompt});
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // Add user's message to chat
      messages.add({"role": "user", "content": text});

      // Clear input
      _controller.clear();

      // Simulate assistant's response
      messages.add({
        "role": "assistant",
        "content":
            "Thank you for your input! Here's an updated design suggestion:\n$text"
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigation(
      currentIndex: 1, // Active tab: Prompting UI
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Text.rich(
            TextSpan(
              text: 'Blue',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'Print', style: TextStyle(color: Colors.blue))
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text(
                "Color-Palette Mode",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(Icons.notifications_none, color: Colors.black),
            const SizedBox(width: 10),
            const Icon(Icons.person_outline, color: Colors.black),
            const SizedBox(width: 10),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message["role"] == "user";

                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.blue.shade100
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft:
                              isUser ? const Radius.circular(16) : Radius.zero,
                          bottomRight:
                              isUser ? Radius.zero : const Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        message["content"]!,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Send a message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(14),
                    ),
                    onPressed: _sendMessage,
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
