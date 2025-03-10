import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> generatePlan(String userInput) async {
  final response = await http.post(
    Uri.parse("http://127.0.0.1:8000/generate-plan"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"text": userInput}),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    String imagePath = data['image_url'];
    return "http://127.0.0.1:8000" + imagePath;  // ✅ Correct concatenation
  } else {
    throw Exception("Error generating floor plan: ${response.statusCode}");
  }
}
