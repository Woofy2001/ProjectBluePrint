import 'package:flutter/material.dart';
import 'custom_bottom_navigation.dart';

class PromptingUIPage extends StatefulWidget {
  final String prompt; // Prompt passed from Design Detail Page

  const PromptingUIPage({super.key, required this.prompt});

  @override
  _PromptingUIPageState createState() => _PromptingUIPageState();
}

class _PromptingUIPageState extends State<PromptingUIPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the input field with the prompt if provided
    _controller.text = widget.prompt;
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigation(
      currentIndex: 1, // Active tab: UI Prompting
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Prompting UI'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customize Your Design',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Input Field to Edit Prompt
              TextField(
                controller: _controller,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Enter your design prompt...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle what happens after editing the prompt
                    final updatedPrompt = _controller.text.trim();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Prompt Saved: $updatedPrompt')),
                    );
                  },
                  child: const Text("Submit Prompt"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
