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
    final isSplash = title.isEmpty && subtitle.isEmpty;
    final isWelcome = title == "Welcome";

    return Column(
      children: [
        if (showNavigation)
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: onBack, child: const Text("Back")),
                TextButton(onPressed: onSkip, child: const Text("Skip")),
              ],
            ),
          ),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: isSplash
                  ? Image.asset(image, height: 60)
                  : isWelcome
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Welcome",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),
                            Image.asset(image, height: 60),
                            const SizedBox(height: 20),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 280,
                              width: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFD8EDF1),
                              ),
                              child: Center(
                                child: Image.asset(image, height: 180),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              title,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward,
                size: 30, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
