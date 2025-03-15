import 'package:flutter/material.dart';

class ConstructorModel {
  final String name;
  final String location;
  final String projects;
  final String contact;

  const ConstructorModel({
    required this.name,
    required this.location,
    required this.projects,
    required this.contact,
  });
}

class ConstructorListScreen extends StatelessWidget {
  ConstructorListScreen({Key? key}) : super(key: key);

  final List<ConstructorModel> constructors = const [
    ConstructorModel(
      name: "Nimal Perera",
      location: "Colombo 03",
      projects: "High-rise buildings, Bridges",
      contact: "+94 71 234 5678",
    ),
    ConstructorModel(
      name: "Samantha Silva",
      location: "Kandy",
      projects: "Housing complexes, Roads",
      contact: "+94 76 345 6789",
    ),
    ConstructorModel(
      name: "Anura Jayasinghe",
      location: "Galle",
      projects: "Hotels, Resorts",
      contact: "+94 77 456 7890",
    ),
    ConstructorModel(
      name: "Pradeep Wickramasinghe",
      location: "Kurunegala",
      projects: "Commercial buildings, Apartments",
      contact: "+94 75 567 8901",
    ),
    ConstructorModel(
      name: "Kumarasinghe Hettiarachchi",
      location: "Jaffna",
      projects: "Hospitals, Public infrastructure",
      contact: "+94 71 678 9012",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Constructors in Sri Lanka"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Navigate back to login page
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: constructors.length,
        itemBuilder: (context, index) {
          final constructor = constructors[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                constructor.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Location: ${constructor.location}"),
                  Text("Projects: ${constructor.projects}"),
                  Text("Contact: ${constructor.contact}"),
                ],
              ),
              leading: const Icon(Icons.business, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
