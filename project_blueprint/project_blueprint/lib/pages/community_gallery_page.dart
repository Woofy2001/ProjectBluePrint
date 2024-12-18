import 'package:flutter/material.dart';
import 'custom_bottom_navigation.dart';
import 'design_detail_page.dart';

class CommunityGalleryPage extends StatelessWidget {
  static final List<Map<String, String>> designs = [
    {
      "image": "assets/design1.jpg",
      "user": "Sophia Carter",
      "date": "2024-12-15",
      "prompt": "2 bedrooms, eco-friendly layout"
    },
    {
      "image": "assets/design2.jpg",
      "user": "John Doe",
      "date": "2024-12-10",
      "prompt": "3 bedrooms, coastal design"
    },
  ];

  const CommunityGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigation(
      currentIndex: 2, // Active tab: Community Gallery
      child: Scaffold(
        appBar: AppBar(
          title: const Text.rich(
            TextSpan(
              text: 'Blue',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'Print', style: TextStyle(color: Colors.blue))
              ],
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search designs...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 4,
                ),
                padding: const EdgeInsets.all(12),
                itemCount: designs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DesignDetailPage(design: designs[index]),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.asset(
                                designs[index]['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(designs[index]['user']!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(designs[index]['date']!,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
