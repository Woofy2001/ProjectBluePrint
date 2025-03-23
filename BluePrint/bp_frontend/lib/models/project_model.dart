import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String userId;
  final String name;
  List<Map<String, dynamic>> messages;
  DateTime timestamp;

  ProjectModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.messages,
    required this.timestamp,
  });

  /// ✅ **Empty constructor to handle missing projects**
  factory ProjectModel.empty() {
    return ProjectModel(
      id: "",
      userId: "",
      name: "Untitled Project",
      messages: [],
      timestamp: DateTime.now(),
    );
  }

  /// ✅ **Convert Firestore document to ProjectModel (Handles missing fields)**
  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ProjectModel(
      id: doc.id,
      userId: data["userId"] ?? "",
      name: data["name"] ?? "Untitled Project",
      messages: List<Map<String, dynamic>>.from(data["messages"] ?? []),
      timestamp: (data["timestamp"] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// ✅ **Convert Firestore document map to ProjectModel (For manual conversion)**
  factory ProjectModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProjectModel(
      id: documentId,
      userId: data["userId"] ?? "",
      name: data["name"] ?? "Untitled Project",
      messages: List<Map<String, dynamic>>.from(data["messages"] ?? []),
      timestamp: (data["timestamp"] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// ✅ **Convert ProjectModel to Firestore document map**
  Map<String, dynamic> toFirestore() {
    return {
      "userId": userId,
      "name": name,
      "messages": messages,
      "timestamp": Timestamp.fromDate(timestamp),
    };
  }
}
