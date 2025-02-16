import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _drawerItem(Icons.add_circle, "Blu AI", Colors.blue, () {}),
            _drawerItem(Icons.explore, "Explore Designs", Colors.blue, () {}),
            const Divider(),
            _projectItem("Project 1"),
            _projectItem("Project 2"),
            _projectItem("Project 3"),
            const Spacer(),
            ListTile(
              leading: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, color: Colors.blue, size: 28),
              ),
              title: const Text("Mavan Athapaththu"),
              trailing: const Icon(Icons.more_horiz),
              onTap: () {},
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _projectItem(String projectName) {
    return ListTile(
      title: Text(projectName, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {},
    );
  }
}
