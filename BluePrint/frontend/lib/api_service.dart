import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> generatePlan(String userInput) async {
  final response = await http.post(
    Uri.parse("http://127.0.0.1:8000/generate-plan"),
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*", // Allow CORS
    },
    body: jsonEncode({"text": userInput}),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return "http://127.0.0.1:8000" + data['image_url']; // Append backend URL
  } else {
    throw Exception("Error generating floor plan: ${response.statusCode}");
  }
}
