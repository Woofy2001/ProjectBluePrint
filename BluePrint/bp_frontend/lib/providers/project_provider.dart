import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/project_model.dart';

class ProjectProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<ProjectModel> _projects = [];
  ProjectModel? _currentProject;

  List<ProjectModel> get projects => _projects;
  ProjectModel? get currentProject => _currentProject;

  Future<void> fetchUserProjects() async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      print("❌ [fetchUserProjects] No user found!");
      return;
    }

    print("🔄 [fetchUserProjects] Fetching projects for user: $userId");

    try {
      final snapshot =
          await _firestore
              .collection("users")
              .doc(userId)
              .collection("projects")
              .orderBy("timestamp", descending: true)
              .get();

      _projects =
          snapshot.docs.map((doc) => ProjectModel.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      print("❌ [fetchUserProjects] Error: $e");
    }
  }

  Future<ProjectModel?> getProjectByName(String projectName) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      print("❌ [getProjectByName] User not authenticated!");
      return null;
    }

    print("🔍 [getProjectByName] Searching for project: $projectName");

    final querySnapshot =
        await _firestore
            .collection("users")
            .doc(userId)
            .collection("projects")
            .where("name", isEqualTo: projectName)
            .limit(1)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      return ProjectModel.fromFirestore(querySnapshot.docs.first);
    } else {
      print("⚠️ [getProjectByName] No project found with name '$projectName'.");
      return null;
    }
  }

  Future<String> generateFloorPlan(String projectId, String prompt) async {
    try {
      print("🔄 [generateFloorPlan] Sending request to backend for: $prompt");

      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/generate-plan"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"prompt": prompt}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String localUrl = "http://10.0.2.2:8000" + data["image_url"];
        print("✅ [generateFloorPlan] Image URL received: $localUrl");

        final tempDir = Directory.systemTemp;
        final filePath =
            "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png";
        final imageFile = File(filePath);
        final imageBytes = await http.readBytes(Uri.parse(localUrl));
        await imageFile.writeAsBytes(imageBytes);

        String firebaseUrl = await uploadImageToFirebase(projectId, imageFile);

        await addMessage(
          projectId: projectId,
          text: "Here is your generated floor plan.",
          sender: "bot",
          imageUrl: firebaseUrl,
        );

        return firebaseUrl;
      } else {
        throw Exception("❌ Backend returned an error: ${response.body}");
      }
    } catch (e) {
      print("❌ [generateFloorPlan] Error: $e");
      throw Exception("Failed to generate floor plan");
    }
  }

  Future<void> addMessage({
    required String projectId,
    required String text,
    required String sender,
    String? imageUrl,
  }) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      print("❌ [addMessage] User not authenticated!");
      return;
    }

    final projectRef = _firestore
        .collection("users")
        .doc(userId)
        .collection("projects")
        .doc(projectId);

    try {
      await projectRef.collection("messages").add({
        "text": text,
        "sender": sender,
        "image": imageUrl ?? "",
        "timestamp": FieldValue.serverTimestamp(),
      });

      print("✅ [addMessage] Message saved!");
      await loadProjectChat(projectId);
    } catch (e) {
      print("❌ [addMessage] Error: $e");
    }
  }

  Future<void> loadProjectChat(String projectId) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      print("❌ [loadProjectChat] User not logged in!");
      return;
    }

    final projectRef = _firestore
        .collection("users")
        .doc(userId)
        .collection("projects")
        .doc(projectId)
        .collection("messages");

    try {
      final snapshot =
          await projectRef.orderBy("timestamp", descending: false).get();

      final project = _projects.firstWhere(
        (p) => p.id == projectId,
        orElse: () => ProjectModel.empty(),
      );

      if (project.id.isNotEmpty) {
        project.messages =
            snapshot.docs.map((doc) {
              return {
                "text": doc["text"] ?? "",
                "sender": doc["sender"] ?? "Unknown",
                "image": doc.data().containsKey("image") ? doc["image"] : "",
                "timestamp": doc["timestamp"] ?? FieldValue.serverTimestamp(),
              };
            }).toList();

        notifyListeners();
        print(
          "✅ [loadProjectChat] Loaded ${project.messages.length} messages.",
        );
      } else {
        print("⚠️ [loadProjectChat] No valid project found!");
      }
    } catch (e) {
      print("❌ [loadProjectChat] Error: $e");
    }
  }

  Future<String> uploadImageToFirebase(String projectId, File imageFile) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return "";

    if (!imageFile.existsSync()) {
      print("❌ [uploadImageToFirebase] Error: File does not exist.");
      return "";
    }

    try {
      String filePath =
          "users/$userId/projects/$projectId/${DateTime.now().millisecondsSinceEpoch}.png";
      UploadTask uploadTask = _storage.ref(filePath).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("✅ [uploadImageToFirebase] Image uploaded: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("❌ [uploadImageToFirebase] Error: $e");
      return "";
    }
  }

  Future<void> addProjectAndMessage(
    String projectName,
    String promptText,
    File? imageFile,
  ) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      print("❌ [addProject] User not authenticated!");
      return;
    }

    print(
      "✅ [addProject] Checking if project '$projectName' exists for user: $userId",
    );

    await fetchUserProjects();
    ProjectModel? existingProject = await getProjectByName(projectName);

    String projectId;
    if (existingProject != null) {
      projectId = existingProject.id;
      print("✅ [addProject] Project '$projectName' already exists.");
    } else {
      final projectRef =
          _firestore
              .collection("users")
              .doc(userId)
              .collection("projects")
              .doc();
      projectId = projectRef.id;

      await projectRef.set({
        "id": projectId,
        "userId": userId,
        "name": projectName,
        "messages": [],
        "images": [],
        "timestamp": FieldValue.serverTimestamp(),
      });

      print("✅ [addProject] Project '$projectName' created.");
      await fetchUserProjects();
    }

    await addMessage(projectId: projectId, text: promptText, sender: "user");
  }

  Future<void> renameProject(String projectId, String newName) async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final projectRef = _firestore
        .collection("users")
        .doc(userId)
        .collection("projects")
        .doc(projectId);

    try {
      await projectRef.update({"name": newName});
      print("✅ [renameProject] Renamed to $newName");
      await fetchUserProjects();
    } catch (e) {
      print("❌ [renameProject] Error: $e");
    }
  }

  /// ✅ Updated: Fetch profile image from Firestore
  Future<void> shareToGallery({
    required String projectId,
    required String imageUrl,
    required String prompt,
    required String userName,
    String? userImage,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("❌ [shareToGallery] User is not authenticated");
        return;
      }

      // Pull profileImage from Firestore document
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      final imageFromProfile =
          userDoc.data()?['profileImage'] ?? "https://default-image-url.com";

      await FirebaseFirestore.instance.collection('community_gallery').add({
        'userName': userName,
        'userImage': imageFromProfile,
        'imageUrl': imageUrl,
        'prompt': prompt,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
      });

      print("✅ [shareToGallery] Shared to community gallery");
    } catch (e) {
      print("❌ [shareToGallery] Error: $e");
    }
  }

  Future<String?> createProjectFromCommunityPrompt(String prompt) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final newProjectRef =
        FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .collection("projects")
            .doc();

    final projectId = newProjectRef.id;

    await newProjectRef.set({
      "id": projectId,
      "userId": user.uid,
      "name": "Community Prompt",
      "messages": [],
      "images": [],
      "timestamp": FieldValue.serverTimestamp(),
    });

    await fetchUserProjects();
    return projectId;
  }
}
