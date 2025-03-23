import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../widgets/house_plan_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import './chat_screen.dart';

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
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final galleryItems =
                    snapshot.data!.docs.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      return {
                        "image": data['imageUrl'] ?? '',
                        "name": data['userName'] ?? 'Unknown',
                        "description":
                            data['prompt'] ?? 'No description provided.',
                        "avatar":
                            data['userImage'] ??
                            "https://i.pravatar.cc/150?img=5",
                      };
                    }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: galleryItems.length,
                  itemBuilder: (context, index) {
                    final item = galleryItems[index];
                    return GestureDetector(
                      onTap: () async {
                        final provider = Provider.of<ProjectProvider>(
                          context,
                          listen: false,
                        );
                        final newId = await provider
                            .createProjectFromCommunityPrompt(
                              item["description"],
                            );
                        if (newId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ChatScreen(
                                    projectId: newId,
                                    projectName: "Community Prompt",
                                    initialPrompt: item["description"],
                                  ),
                            ),
                          );
                        }
                      },
                      child: HousePlanCard(
                        image: item["image"]!,
                        name: item["name"]!,
                        description: item["description"]!,
                        avatarUrl: item["avatar"]!,
                      ),
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
