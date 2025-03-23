import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorDetailsScreen extends StatelessWidget {
  final String name;
  final String specialization;
  final String phone;
  final String whatsapp;
  final String description;
  final List<String> services;
  final String imageUrl;

  const VendorDetailsScreen({
    super.key,
    required this.name,
    required this.specialization,
    required this.phone,
    required this.whatsapp,
    required this.description,
    required this.services,
    required this.imageUrl,
  });

  void _contactVendor() async {
    final Uri phoneUri = Uri.parse('tel:$phone');
    final Uri whatsappUri = Uri.parse('https://wa.me/$whatsapp');

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      print("❌ Could not launch contact methods.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // 🔙 Back Button & App Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "BluePrint",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder for alignment
                ],
              ),

              const SizedBox(height: 20),

              // 🔹 Vendor Image & Details
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Vendor Image
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(width: 16),

                  // Name, Specialization, and Favorite Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          specialization,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Add to Favourite Button
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement favorite function
                    },
                    icon: const Icon(Icons.favorite_border, color: Colors.blue),
                    label: const Text(
                      "Add to favourite",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔹 About Section
              const Text(
                "About the Architect",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 15),

              // 🔹 Services Provided
              const Text(
                "Services provide",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    services
                        .map(
                          (service) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  service,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              ),

              const SizedBox(height: 30),

              // 🔹 Contact Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _contactVendor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Contact",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
