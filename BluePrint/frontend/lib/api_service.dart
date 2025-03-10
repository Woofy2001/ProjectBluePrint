import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> generatePlan(String userInput) async {
  final response = await http.post(
    Uri.parse("http://your-server-ip:8000/generate-plan"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"text": userInput}),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data['image_url'];
  } else {
    throw Exception("Error generating floor plan");
  }
}
