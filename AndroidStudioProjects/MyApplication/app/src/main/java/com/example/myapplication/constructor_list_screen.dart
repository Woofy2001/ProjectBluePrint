import 'package:flutter/material.dart';
import 'constructor.dart';
import 'constructor_detail_screen.dart';

class ConstructorListScreen extends StatefulWidget {
  @override
  _ConstructorListScreenState createState() => _ConstructorListScreenState();
}

class _ConstructorListScreenState extends State<ConstructorListScreen> {
  List<Constructor> constructors = [
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

  List<Constructor> filteredConstructors = [];

  @override
  void initState() {
    super.initState();
    filteredConstructors = List.from(constructors);
  }

  void filterSearch(String query) {
    setState(() {
      filteredConstructors =
          query.isEmpty
              ? List.from(constructors)
              : constructors
                  .where(
                    (c) =>
                        c.name.toLowerCase().contains(query.toLowerCase()) ||
                        c.location.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();
    });
  }

  void addNewConstructor() {
    setState(() {
      constructors.add(
        Constructor(
          name: "New Constructor",
          location: "Unknown",
          projects: "Various",
          contact: "+94 70 000 0000",
        ),
      );
      filteredConstructors = List.from(constructors);
    });
  }

  void removeConstructor(int index) {
    setState(() {
      constructors.removeAt(index);
      filteredConstructors = List.from(constructors);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Constructors in Sri Lanka")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterSearch,
              decoration: InputDecoration(
                labelText: "Search by Name or Location",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredConstructors.length,
              itemBuilder: (context, index) {
                final constructor = filteredConstructors[index];
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
                        Text("📍 Location: ${constructor.location}"),
                        Text("🏗️ Projects: ${constructor.projects}"),
                        Text("📞 Contact: ${constructor.contact}"),
                      ],
                    ),
                    leading: Icon(Icons.business, color: Colors.blue),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ConstructorDetailScreen(
                                constructor: constructor,
                              ),
                        ),
                      );
                    },
                    onLongPress: () {
                      removeConstructor(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewConstructor,
        child: Icon(Icons.add),
        tooltip: "Add Constructor",
      ),
    );
  }
}
