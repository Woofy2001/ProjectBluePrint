import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://10.0.2.2:8000"; // 🔗 Use 10.0.2.2 for Android Emulator

  // ✅ Extract house details
  static Future<Map<String, dynamic>> extractHouseDetails(String text) async {
    final response = await http.post(
      Uri.parse("$baseUrl/extract"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": text}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to extract house details");
    }
  }

  // ✅ Generate floor plan (Fixes Image URL)
  static Future<String> generateFloorPlan(String text) async {
    final response = await http.post(
      Uri.parse("$baseUrl/generate-plan"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": text}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return "$baseUrl${data["image_url"]}?t=${DateTime.now().millisecondsSinceEpoch}"; // ✅ Ensure full image URL
    } else {
      throw Exception("Failed to generate floor plan");
    }
  }

  // ✅ Export CAD file
  static Future<String> exportCadFile() async {
    final response = await http.get(Uri.parse("$baseUrl/export-cad"));

    if (response.statusCode == 200) {
      return "$baseUrl${jsonDecode(response.body)["cad_url"]}"; // ✅ Ensure full CAD URL
    } else {
      throw Exception("Failed to export CAD file");
    }
  }
}
