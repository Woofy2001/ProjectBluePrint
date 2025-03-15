import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class VendorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Get vendors from Firestore
  Future<List<Map<String, dynamic>>> getVendors(Position userPosition) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('vendors').get();

      List<Map<String, dynamic>> vendors = snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "name": doc['name'],
          "specialization": doc['specialization'],
          "latitude": doc['latitude'],
          "longitude": doc['longitude'],
          "phone": doc['phone'],
          "whatsapp": doc['whatsapp'],
          "distance": Geolocator.distanceBetween(
                userPosition.latitude,
                userPosition.longitude,
                doc['latitude'],
                doc['longitude'],
              ) /
              1000, // Convert to KM
        };
      }).toList();

      // ✅ Sort vendors by distance (nearest first)
      vendors.sort((a, b) => a['distance'].compareTo(b['distance']));

      return vendors;
    } catch (e) {
      print("Error fetching vendors: $e");
      return [];
    }
  }
}
