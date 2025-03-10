import 'package:flutter/material.dart';
import 'api_service.dart';

class FloorPlanScreen extends StatefulWidget {
  @override
  _FloorPlanScreenState createState() => _FloorPlanScreenState();
}

class _FloorPlanScreenState extends State<FloorPlanScreen> {
  String imageUrl = "";

  void generateFloorPlan() async {
    String url = await generatePlan("3 bedroom, 2 bathroom, 1 kitchen");
    setState(() {
      imageUrl = "http://your-server-ip:8000" + url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generated Floor Plan")),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: generateFloorPlan, child: Text("Generate Floor Plan")),
          imageUrl.isNotEmpty
              ? Image.network(imageUrl)
              : Text("No plan generated yet")
        ],
      ),
    );
  }
}
