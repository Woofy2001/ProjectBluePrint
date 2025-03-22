import 'package:flutter/material.dart';

class OnboardingWidget extends StatelessWidget {
  final String title, subtitle, image;
  final bool showNavigation;
  final VoidCallback onBack, onSkip, onNext;

  const OnboardingWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    this.showNavigation = false,
    required this.onBack,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showNavigation)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: onBack, child: const Text("Back")),
                TextButton(onPressed: onSkip, child: const Text("Skip")),
              ],
            ),
          Image.asset(image, height: 300),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward, size: 30, color: Colors.blue),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
