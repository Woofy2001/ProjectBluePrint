// ... [other imports remain unchanged]
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/project_provider.dart';
import '../screens/user_settings.dart';
import '../screens/vendor_list_screen.dart';
import '../screens/community_gallery_screen.dart';
import '../services/auth_service.dart';
import '../screens/chat_screen.dart';

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
                    null,
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

              _drawerItem(Icons.explore, "Contact a Vendor", Colors.blue, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VendorListScreen()),
                );
              }),

              _drawerItem(Icons.public, "Community Gallery", Colors.blue, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CommunityGalleryScreen(),
                  ),
                );
              }),

              const Divider(),

              Expanded(
                child:
                    projectProvider.projects.isEmpty
                        ? const Center(child: Text("No projects found."))
                        : ListView.builder(
                          itemCount: projectProvider.projects.length,
                          itemBuilder: (context, index) {
                            final project = projectProvider.projects[index];
                            return ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      project.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'rename') {
                                        _showRenameDialog(
                                          context,
                                          project.id,
                                          project.name,
                                        );
                                      }
                                    },
                                    itemBuilder:
                                        (context) => const [
                                          PopupMenuItem(
                                            value: 'rename',
                                            child: Text("Rename"),
                                          ),
                                        ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // TODO: Implement delete functionality
                                },
                              ),
                              onTap: () async {
                                Navigator.pop(context); // Close drawer
                                await projectProvider.loadProjectChat(
                                  project.id,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ChatScreen(
                                          projectId: project.id,
                                          projectName: project.name,
                                        ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
              ),

              const Divider(),

              FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .get(),
                builder: (context, snapshot) {
                  String imageUrl = "";
                  String userDisplayName = user?.email ?? "Guest";

                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data!.data() != null) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;

                    imageUrl =
                        data['profileImage'] ??
                        "https://www.woolha.com/media/2020/03/eevee.png";

                    final firstName = data['first_name'] ?? '';
                    final lastName = data['last_name'] ?? '';
                    final fullName = "$firstName $lastName".trim();

                    if (fullName.isNotEmpty) {
                      userDisplayName = fullName;
                    }
                  }

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundImage:
                          imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : const AssetImage("assets/default-avatar.png")
                                  as ImageProvider,
                    ),
                    title: Text(userDisplayName),
                    trailing: const Icon(Icons.more_horiz),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserProfile(),
                        ),
                      );
                    },
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

  void _showRenameDialog(
    BuildContext context,
    String projectId,
    String currentName,
  ) {
    final TextEditingController _controller = TextEditingController(
      text: currentName,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Rename Project"),
            content: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "New project name"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newName = _controller.text.trim();
                  if (newName.isNotEmpty) {
                    await Provider.of<ProjectProvider>(
                      context,
                      listen: false,
                    ).renameProject(projectId, newName);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Rename"),
              ),
            ],
          ),
    );
  }
}
