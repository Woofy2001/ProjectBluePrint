import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';

class VendorScreen extends StatelessWidget {
  const VendorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Contact Vendors",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _vendorCard("ABC Constructions", "📞 123-456-7890"),
            _vendorCard("HomeStyle Builders", "📞 987-654-3210"),
            _vendorCard("Eco Homes Ltd.", "📞 555-666-7777"),
          ],
        ),
      ),
    );
  }

  Widget _vendorCard(String name, String contact) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      child: ListTile(
        leading: const Icon(Icons.business, color: Colors.blue),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(contact),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
