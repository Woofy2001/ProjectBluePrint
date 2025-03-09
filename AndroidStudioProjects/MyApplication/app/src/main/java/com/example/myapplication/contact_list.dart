import 'package:flutter/material.dart';

class Constructor {
  final String name;
  final String location;
  final String projects;
  final String contact;

  Constructor({
    required this.name,
    required this.location,
    required this.projects,
    required this.contact,
  });
}

class ConstructorListScreen extends StatelessWidget {
  final List<Constructor> constructors = [
    Constructor(
      name: "Nimal Perera",
      location: "Colombo 03",
      projects: "High-rise buildings, Bridges",
      contact: "+94 71 234 5678",
    ),
    Constructor(
      name: "Samantha Silva",
      location: "Kandy",
      projects: "Housing complexes, Roads",
      contact: "+94 76 345 6789",
    ),
    Constructor(
      name: "Anura Jayasinghe",
      location: "Galle",
      projects: "Hotels, Resorts",
      contact: "+94 77 456 7890",
    ),
    Constructor(
      name: "Pradeep Wickramasinghe",
      location: "Kurunegala",
      projects: "Commercial buildings, Apartments",
      contact: "+94 75 567 8901",
    ),
    Constructor(
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
        title: Text("Constructors in Sri Lanka"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
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
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                constructor.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Location: ${constructor.location}"),
                  Text("Projects: ${constructor.projects}"),
                  Text("Contact: ${constructor.contact}"),
                ],
              ),
              leading: Icon(Icons.business, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
