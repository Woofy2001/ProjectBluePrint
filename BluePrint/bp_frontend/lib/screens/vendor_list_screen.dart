import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'vendor_details_screen.dart';
import 'vendor_form_screen.dart';

class VendorListScreen extends StatefulWidget {
  const VendorListScreen({super.key});

  @override
  _VendorListScreenState createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  String searchQuery = "";
  bool showFavorites = false;
  List<DocumentSnapshot> vendors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BluePrint",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue, size: 28),
            onPressed: () {
              // ✅ Redirect to vendor registration form
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VendorFormScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: "Search...",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query.toLowerCase();
                });
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Connect with trusted architects, skilled contractors, and premium material suppliers to bring your dream home to life with ease and excellence.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                _buildTab("All", !showFavorites),
                _buildTab("Favorites", showFavorites),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('vendors').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                vendors =
                    snapshot.data!.docs.where((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      return data['name'].toString().toLowerCase().contains(
                        searchQuery,
                      );
                    }).toList();

                return ListView.builder(
                  itemCount: vendors.length,
                  itemBuilder: (context, index) {
                    var vendor = vendors[index];
                    return _buildVendorCard(vendor);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showFavorites = (title == "Favorites");
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildVendorCard(DocumentSnapshot vendor) {
    var data = vendor.data() as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50, // ✅ Light blue background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Square Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              data['imageUrl'] ?? "https://via.placeholder.com/100",
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Vendor Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  data['specialization'],
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Contact Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => VendorDetailsScreen(
                        name: data['name'],
                        specialization: data['specialization'],
                        phone: data['phone'],
                        whatsapp: data['whatsapp'],
                        description: data['description'],
                        services: List<String>.from(data['services']),
                        imageUrl: data['imageUrl'],
                      ),
                ),
              );
            },
            child: const Text("Contact"),
          ),
        ],
      ),
    );
  }
}
