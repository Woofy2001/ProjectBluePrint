import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/user_settings.dart';
import '../screens/landing_screen.dart';
import '../screens/vendor_list_screen.dart';

class DrawerMenu extends StatelessWidget {
  final List<String> projects;
  final Function(String) onProjectSelected;

  const DrawerMenu({
    super.key,
    required this.projects,
    required this.onProjectSelected,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 40),
          _drawerItem(Icons.add_circle, "New Project", Colors.blue, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LandingScreen()),
            );
          }),
          _drawerItem(Icons.explore, "Contact a Vendor", Colors.blue, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VendorListScreen()),
            );
          }),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    projects[index],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    onProjectSelected(projects[index]);
                  },
                );
              },
            ),
          ),
          const Divider(),
          // ✅ User Profile Section at the Bottom
          ListTile(
            leading: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.person, color: Colors.blue, size: 28),
            ),
            title: Text(user?.email ?? "Guest"),
            trailing: const Icon(Icons.more_horiz),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserSettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: onTap,
    );
  }
}
