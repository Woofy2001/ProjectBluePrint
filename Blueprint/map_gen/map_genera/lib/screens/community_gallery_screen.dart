import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../widgets/house_plan_card.dart';

class CommunityGalleryScreen extends StatelessWidget {
  const CommunityGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> housePlans = [
      {
        "image": "assets/images/plan1.svg",
        "name": "Jhon Petersen",
        "description": "1 Bedroom, 1 Bathroom",
        "avatar": "https://i.pravatar.cc/150?img=5",
      },
      {
        "image": "assets/images/plan2.svg",
        "name": "Jhon Petersen",
        "description": "1 Bedroom, 1 Bathroom",
        "avatar": "https://i.pravatar.cc/150?img=8",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {}, // Implement drawer or menu action
        ),
        title: const Text(
          "BluePrint",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SearchBarWidget(),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: housePlans.length,
              itemBuilder: (context, index) {
                return HousePlanCard(
                  image: housePlans[index]["image"]!,
                  name: housePlans[index]["name"]!,
                  description: housePlans[index]["description"]!,
                  avatarUrl: housePlans[index]["avatar"]!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
