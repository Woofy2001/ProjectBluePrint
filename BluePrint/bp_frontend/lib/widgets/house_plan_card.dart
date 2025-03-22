import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HousePlanCard extends StatelessWidget {
  final String image; // URL or asset path
  final String name;
  final String description;
  final String avatarUrl;

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
          // Check if image is SVG or Network image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child:
                image.endsWith('.svg')
                    ? SvgPicture.network(
                      image, // Use this if your image is an SVG from URL
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    )
                    : Image.network(
                      image, // Use this if your image is a network image (PNG, JPG, etc.)
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
                const SizedBox(width: 10),
                Column(
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
