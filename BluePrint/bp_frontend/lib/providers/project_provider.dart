import 'package:flutter/foundation.dart';

class ProjectProvider extends ChangeNotifier {
  final List<String> _projects = []; // 🔹 Stores projects dynamically

  List<String> get projects => _projects;

  void addProject(String projectName) {
    _projects.add(projectName);
    notifyListeners();
  }

  void removeProject(String projectName) {
    _projects.remove(projectName);
    notifyListeners();
  }
}
