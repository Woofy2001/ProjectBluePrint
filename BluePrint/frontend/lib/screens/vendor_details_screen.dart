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
    Key? key,
    required this.name,
    required this.specialization,
    required this.phone,
    required this.whatsapp,
    required this.description,
    required this.services,
    required this.imageUrl,
  }) : super(key: key);

  void _callVendor() async {
    final Uri phoneUri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print("❌ Could not launch phone call.");
    }
  }

  void _whatsappVendor() async {
    final Uri whatsappUri = Uri.parse('https://wa.me/$whatsapp');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      print("❌ Could not launch WhatsApp.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade700,
                  Colors.blue.shade300,
                ],
              ),
            ),
          ),

          // Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // App Title
                Text(
                  "BluePrint",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // Profile Image
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(imageUrl),
                ),

                const SizedBox(height: 10),

                // Vendor Name
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // Specialization
                Text(
                  specialization,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 5),

                // "Add to Favourite" Button
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement favourite function
                  },
                  icon: Icon(Icons.favorite_border, color: Colors.white),
                  label: Text(
                    "Add to favourite",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // About Section
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // About Title
                      Text(
                        "About the ${specialization.split(" ").last}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // About Description
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade700),
                      ),

                      const SizedBox(height: 15),

                      // Services Title
                      Text(
                        "Services provide",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Services List
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: services
                            .map((service) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.check,
                                          color: Colors.blue, size: 16),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          service,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),

                      const SizedBox(height: 20),

                      // Contact Button
                      Center(
                        child: ElevatedButton(
                          onPressed: _callVendor,
                          child: Text("Contact"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            backgroundColor: Colors.blue.shade700,
                          ),
                        ),
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
