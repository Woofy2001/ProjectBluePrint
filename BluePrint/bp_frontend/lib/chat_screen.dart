import 'package:flutter/material.dart';
import 'services/api_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _imageUrl;
  String? _errorMessage;
  bool _isLoading = false;

  void _sendPrompt() async {
    setState(() {
      _errorMessage = null;
      _imageUrl = null; // ✅ Clear the old image before loading a new one
      _isLoading = true;
    });

    try {
      String imageUrl = await generatePlan(_controller.text);
      setState(() {
        _imageUrl = imageUrl;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll("Exception:", "").trim();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blueprint App")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child:
                  _isLoading
                      ? CircularProgressIndicator() // ✅ Show a loading spinner
                      : _errorMessage != null
                      ? Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      )
                      : _imageUrl != null
                      ? Image.network(
                        _imageUrl!,
                      ) // ✅ UI refreshes with the new image
                      : Text(
                        "Enter a house description to generate a floor plan.",
                      ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter house description...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendPrompt),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
