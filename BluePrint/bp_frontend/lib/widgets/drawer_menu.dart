import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../screens/user_settings.dart';
import '../screens/vendor_list_screen.dart';
import '../services/auth_service.dart';

class DrawerMenu extends StatelessWidget {
  final Function(String projectId)? onProjectSelected;

  const DrawerMenu({super.key, this.onProjectSelected});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, _) {
        final authService = Provider.of<AuthService>(context);
        final user = authService.currentUser;

        return Drawer(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // ✅ Create New Project
              _drawerItem(
                Icons.add_circle,
                "New Project",
                Colors.blue,
                () async {
                  String projectName =
                      "Project ${projectProvider.projects.length + 1}";

                  await projectProvider.addProjectAndMessage(
                    projectName,
                    "New project created",
                    null, // No image required initially
                  );

                  if (onProjectSelected != null) {
                    final newProject = await projectProvider.getProjectByName(
                      projectName,
                    );
                    if (newProject != null) {
                      onProjectSelected!(newProject.id);
                    }
                  }
                },
              ),

              // ✅ Navigate to Vendor List
              _drawerItem(Icons.explore, "Contact a Vendor", Colors.blue, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VendorListScreen()),
                );
              }),
              const Divider(),

              // ✅ Fetch & Display User Projects
              Expanded(
                child:
                    projectProvider.projects.isEmpty
                        ? const Center(child: Text("No projects found."))
                        : ListView.builder(
                          itemCount: projectProvider.projects.length,
                          itemBuilder: (context, index) {
                            final project = projectProvider.projects[index];
                            return ListTile(
                              title: Text(
                                project.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  // TODO: Implement delete functionality
                                },
                              ),
                              onTap: () {
                                if (onProjectSelected != null) {
                                  onProjectSelected!(project.id);
                                }
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
              ),
              const Divider(),

              // ✅ User Profile Section
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
      },
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
