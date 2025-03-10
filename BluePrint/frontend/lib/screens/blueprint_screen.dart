import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BlueprintScreen extends StatefulWidget {
  @override
  _BlueprintScreenState createState() => _BlueprintScreenState();
}

class _BlueprintScreenState extends State<BlueprintScreen> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [
    {"sender": "ai", "text": "Hi there! Describe your dream house plan."}
  ];
  String? _imageUrl;
  String _errorMessage = '';

  Future<void> _generateFloorPlan() async {
    final String userInput = _controller.text;

    if (!_validateUserInput(userInput)) {
      setState(() {
        _errorMessage = "Invalid request! Please describe a house plan.";
      });
      return;
    }

    setState(() {
      _errorMessage = "";
      _messages.add({"sender": "user", "text": userInput});
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/generate-plan'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': userInput}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _imageUrl = "http://10.0.2.2:8000" +
              data['image_url'] +
              "?t=${DateTime.now().millisecondsSinceEpoch}";
          _messages.add({
            "sender": "ai",
            "text": "Here is your generated floor plan.",
            "image": _imageUrl
          });
        });
      } else {
        setState(() {
          _errorMessage = "Failed to generate floor plan. Try again.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: Unable to connect to backend.";
      });
    }
  }

  bool _validateUserInput(String input) {
    List<String> allowedWords = [
      'bedroom',
      'kitchen',
      'bathroom',
      'living room',
      'house',
      'floor plan'
    ];
    return allowedWords.any((word) => input.toLowerCase().contains(word));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade500,
        title: Text("BluePrint", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg['sender'] == "user"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: msg['sender'] == "user"
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: msg['sender'] == "user"
                              ? Colors.blue.shade400
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          msg['text'],
                          style: TextStyle(
                            color: msg['sender'] == "user"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      if (msg.containsKey("image"))
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Image.network(msg['image'],
                              fit: BoxFit.contain, key: ValueKey(msg['image'])),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
                      hintText: "Describe your house plan...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _generateFloorPlan,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
