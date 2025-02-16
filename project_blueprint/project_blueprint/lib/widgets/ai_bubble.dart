import 'dart:async';
import 'package:flutter/material.dart';

class AIBubble extends StatefulWidget {
  final bool isListening; // True when AI is processing
  final VoidCallback onTap; // Action when tapped

  const AIBubble({super.key, required this.isListening, required this.onTap});

  @override
  _AIBubbleState createState() => _AIBubbleState();
}

class _AIBubbleState extends State<AIBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glowOpacity = Tween<double>(begin: 0.2, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // Expand on tap
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // **Glowing Effect**
              if (widget.isListening)
                Opacity(
                  opacity: _glowOpacity.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),

              // **Floating AI Bubble**
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Image.asset(
                  'assets/ai_bubble.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
