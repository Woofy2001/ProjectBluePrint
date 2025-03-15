import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'vendor_details_screen.dart';

class VendorListScreen extends StatelessWidget {
  const VendorListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Vendors"),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var vendors = snapshot.data!.docs;

          if (vendors.isEmpty) {
            return const Center(
              child: Text(
                "No vendors found.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.builder(
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              var vendor = vendors[index];
              final vendorData = vendor.data() as Map<String, dynamic>?;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: vendorData != null &&
                            vendorData.containsKey('imageUrl')
                        ? NetworkImage(vendorData['imageUrl'])
                        : const NetworkImage("https://via.placeholder.com/150"),
                  ),
                  title: Text(
                    vendorData?['name'] ?? "Unknown Vendor",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle:
                      Text(vendorData?['specialization'] ?? "Not specified"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // ✅ Handle missing fields safely
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VendorDetailsScreen(
                          name: vendorData?['name'] ?? "Unknown Vendor",
                          specialization:
                              vendorData?['specialization'] ?? "Not specified",
                          phone: vendorData?['phone'] ?? "No phone available",
                          whatsapp: vendorData?['whatsapp'] ??
                              "No WhatsApp available",
                          description: vendorData != null &&
                                  vendorData.containsKey('description')
                              ? vendorData['description']
                              : "No description available.",
                          services: vendorData != null &&
                                  vendorData.containsKey('services')
                              ? List<String>.from(vendorData['services'])
                              : ["No services listed."],
                          imageUrl: vendorData != null &&
                                  vendorData.containsKey('imageUrl')
                              ? vendorData['imageUrl']
                              : "https://via.placeholder.com/150",
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
