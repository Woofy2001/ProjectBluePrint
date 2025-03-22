import 'package:flutter/material.dart';

class VendorDetailScreen extends StatelessWidget {
  const VendorDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: "Blue", style: TextStyle(color: Colors.black)),
              TextSpan(text: "Print", style: TextStyle(color: Color(0xFF2E4D90))),
            ],
          ),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/richard.jpg"),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Mr. Richard Mason", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Architect & Project Consultant"),
                    Text("BArch, MArch, RIBA, LEED AP", style: TextStyle(fontSize: 12)),
                  ],
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                  label: const Text("Add to favourite"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("About the Architect", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            const Text(
              "Mr. Richard Mason is an experienced architect with a passion for crafting innovative and sustainable designs...",
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Services provide", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            const BulletList([
              "Architectural Design and Planning",
              "Material Selection and Cost Estimation",
              "Structural Analysis and Safety Assessments",
              "Sustainable Building Solutions",
              "Project Management and Execution",
            ]),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E4D90),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Contact"),
            ),
          ],
        ),
      ),
    );
  }
}

// Bullet List widget
class BulletList extends StatelessWidget {
  final List<String> items;
  const BulletList(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map((e) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("•  "),
                  Expanded(child: Text(e)),
                ],
              ))
          .toList(),
    );
  }
}
