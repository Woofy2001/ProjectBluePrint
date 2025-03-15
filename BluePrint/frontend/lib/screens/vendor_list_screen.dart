import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:blueprint_app/services/vendor_service.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorListScreen extends StatefulWidget {
  @override
  _VendorListScreenState createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  List<Map<String, dynamic>> _vendors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVendors();
  }

  // ✅ Get user location and fetch vendors
  Future<void> _fetchVendors() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      VendorService vendorService = VendorService();
      List<Map<String, dynamic>> vendors =
          await vendorService.getVendors(position);

      setState(() {
        _vendors = vendors;
        _isLoading = false;
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ✅ Open phone dialer or WhatsApp
  void _contactVendor(String phone, {bool whatsapp = false}) async {
    String url = whatsapp ? "https://wa.me/$phone" : "tel:$phone";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nearby Vendors")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _vendors.length,
              itemBuilder: (context, index) {
                var vendor = _vendors[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(vendor['name'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        "${vendor['specialization']} - ${vendor['distance'].toStringAsFixed(2)} km away"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.call, color: Colors.blue),
                          onPressed: () => _contactVendor(vendor['phone']),
                        ),
                        IconButton(
                          icon: Icon(Icons.chat, color: Colors.green),
                          onPressed: () => _contactVendor(vendor['whatsapp'],
                              whatsapp: true),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
