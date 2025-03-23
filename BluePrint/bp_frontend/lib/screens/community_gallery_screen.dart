import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../widgets/house_plan_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityGalleryScreen extends StatelessWidget {
  const CommunityGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection("community_gallery")
                      .orderBy(
                        "timestamp",
                        descending: true,
                      ) // Sort by timestamp
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final galleryItems =
                    snapshot.data!.docs.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;

                      // Fetching user details (name, image) and prompt
                      return {
                        "image": data['imageUrl'] ?? '',
                        "name": data['userName'] ?? 'Unknown',
                        "description":
                            data['prompt'] ??
                            'No description provided.', // ✅ FIXED to safely fallback
                        "avatar":
                            data['userImage'] ??
                            "https://i.pravatar.cc/150?img=5", // Default image
                      };
                    }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: galleryItems.length,
                  itemBuilder: (context, index) {
                    return HousePlanCard(
                      image: galleryItems[index]["image"]!,
                      name: galleryItems[index]["name"]!,
                      description: galleryItems[index]["description"]!,
                      avatarUrl: galleryItems[index]["avatar"]!,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
