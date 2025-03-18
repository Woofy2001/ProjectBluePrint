import 'package:flutter/material.dart';
import '../utils/api_service.dart'; // ✅ Ensure correct import

class ChatScreen extends StatefulWidget {
  final String projectId;
  final String? initialMessage;

  const ChatScreen({super.key, required this.projectId, this.initialMessage});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  bool _isProcessing = false;
  String? _imageUrl;
  final ScrollController _scrollController = ScrollController();

  final Color userBubbleColor = const Color(0xFF3A72D8);

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      _addMessage("user", widget.initialMessage!);
      _sendMessage(widget.initialMessage!);
    }
  }

  void _addMessage(String sender, String text, {String? imageUrl}) {
    setState(() {
      messages.add({"sender": sender, "text": text, "image": imageUrl});
    });

    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _sendMessage(String? userInput) async {
    if (userInput == null || userInput.trim().isEmpty) return;

    _addMessage("user", userInput);
    _controller.clear();
    setState(() => _isProcessing = true);

    try {
      String imageUrl = await ApiService.generateFloorPlan(
        userInput,
      ); // ✅ Fetch floor plan

      setState(() {
        _imageUrl = imageUrl;
        _isProcessing = false;
      });

      _addMessage(
        "bot",
        "Here is your generated floor plan.",
        imageUrl: imageUrl,
      );
    } catch (e) {
      setState(() => _isProcessing = false);
      _addMessage("bot", "❌ Error generating floor plan. Try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade500,
        title: const Text(
          "BluePrint",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.0),
              itemCount: messages.length + (_isProcessing ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length) return _processingMessage();
                var message = messages[index];
                return _chatBubble(
                  message["sender"]!,
                  message["text"]!,
                  imageUrl: message["image"],
                );
              },
            ),
          ),
          _chatInputField(),
        ],
      ),
    );
  }

  Widget _chatBubble(String sender, String text, {String? imageUrl}) {
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
              color: isUser ? userBubbleColor : Colors.white,
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
          if (imageUrl != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                key: ValueKey(imageUrl),
              ),
            ),
        ],
      ),
    );
  }

  Widget _processingMessage() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text("⏳ Processing...", style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _chatInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Describe your floor plan...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: Colors.blue.shade900,
            onPressed: () => _sendMessage(_controller.text),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
