import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> generatePlan(String userInput) async {
  final response = await http.post(
    Uri.parse("http://10.0.2.2:8000/generate-plan"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"text": userInput}),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    // ✅ Append timestamp to force image reload
    String imageUrl = "http://10.0.2.2:8000" +
        data['image_url'] +
        "?t=${DateTime.now().millisecondsSinceEpoch}";
    return imageUrl;
  } else {
    throw Exception("Error generating floor plan: ${response.statusCode}");
  }
}
