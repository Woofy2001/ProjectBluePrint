import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/drawer_menu.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: const DrawerMenu(), // ✅ Slide Menu
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "BluePrint",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,

          // ✅ **Hamburger Menu Button (☰) to Open Drawer**
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open Slide Menu
              },
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // ✅ **Static AI Bubble Image**
            Image.asset(
              'assets/ai_bubble.png', // Ensure this file exists in /assets/
              width: 100,
              height: 100,
            ),

            const SizedBox(height: 20),
            const Text(
              "Hi there human, I'm Blu.\nYour personal house planning assistant.\nHow can I help you today?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w400),
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
              decoration: InputDecoration(
                hintText: "Type a prompt...",
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
            onPressed: () {
              // TODO: Add AI processing action here
            },
            child: const Icon(Icons.mic, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
