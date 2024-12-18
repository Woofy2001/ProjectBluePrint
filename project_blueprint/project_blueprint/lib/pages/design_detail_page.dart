import 'package:flutter/material.dart';
import 'custom_bottom_navigation.dart';
import 'prompting_ui_page.dart';

class DesignDetailPage extends StatelessWidget {
  final Map<String, String> design;

  const DesignDetailPage({super.key, required this.design});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigation(
      currentIndex: 2, // Active tab: Community Gallery
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Design Details'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display design image
              Image.asset(design['image']!,
                  width: double.infinity, fit: BoxFit.cover, height: 250),
              const SizedBox(height: 12),
              // User Details and Prompt
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(design['user']!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Prompt',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(design['prompt']!,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 10),
                    Text('Date Designed: ${design['date']}',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // "Use This Template" Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    // Navigate to Prompting UI with the prompt data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PromptingUIPage(prompt: design['prompt']!),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('Use This Template',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
