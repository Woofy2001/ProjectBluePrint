import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HousePlanCard extends StatelessWidget {
  final String image; // URL or asset path for floor plan image
  final String name; // User's name
  final String description; // User's prompt (floor plan description)
  final String avatarUrl; // URL of user's avatar image

  const HousePlanCard({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Check if the image is SVG or a regular image (PNG/JPG)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child:
                image.endsWith('.svg')
                    ? SvgPicture.network(
                      image,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    )
                    : Image.network(
                      image,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // Display user's avatar image
                CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
                const SizedBox(width: 10),
                // Display user's name and description (prompt)
                Expanded(
                  // ✅ fix applied here
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis, // ✅ prevents overflow
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
