import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'vendor_details_screen.dart';

class VendorListScreen extends StatefulWidget {
  const VendorListScreen({Key? key}) : super(key: key);

  @override
  _VendorListScreenState createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  String searchQuery = "";
  bool showFavorites = false;

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
              // TODO: Navigate to Become Vendor Screen
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Short Description
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Connect with trusted architects, skilled contractors, and premium material suppliers to bring your dream home to life with ease and excellence.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),

          const SizedBox(height: 10),

          // Tabs for All & Favorites
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => setState(() => showFavorites = false),
                child: Text(
                  "All",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        showFavorites ? FontWeight.normal : FontWeight.bold,
                    color: showFavorites ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => showFavorites = true),
                child: Text(
                  "Favorites",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        showFavorites ? FontWeight.bold : FontWeight.normal,
                    color: showFavorites ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ],
          ),

          // Vendor List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('vendors').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var vendors = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return data['name'].toLowerCase().contains(searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: vendors.length,
                  itemBuilder: (context, index) {
                    var vendor = vendors[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(vendor['imageUrl']),
                        ),
                        title: Text(
                          vendor['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(vendor['specialization']),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VendorDetailsScreen(
                                  name: vendor['name'],
                                  specialization: vendor['specialization'],
                                  phone: vendor['phone'],
                                  whatsapp: vendor['whatsapp'],
                                  description: vendor['description'],
                                  services:
                                      List<String>.from(vendor['services']),
                                  imageUrl: vendor['imageUrl'],
                                ),
                              ),
                            );
                          },
                          child: const Text("Contact"),
                        ),
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
