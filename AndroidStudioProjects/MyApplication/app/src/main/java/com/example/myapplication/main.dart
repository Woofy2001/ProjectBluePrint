import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: ConstructorListScreen(),
    );
  }
}

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
    filteredConstructors = constructors;
  }

  void filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredConstructors = constructors;
      } else {
        filteredConstructors =
            constructors
                .where(
                  (c) =>
                      c.name.toLowerCase().contains(query.toLowerCase()) ||
                      c.location.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
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
      filteredConstructors = constructors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Constructors in Sri Lanka")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
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
                        Text("Location: ${constructor.location}"),
                        Text("Projects: ${constructor.projects}"),
                        Text("Contact: ${constructor.contact}"),
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

class ConstructorDetailScreen extends StatelessWidget {
  final Constructor constructor;

  ConstructorDetailScreen({required this.constructor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(constructor.name)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  constructor.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "📍 Location: ${constructor.location}",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "🏗️ Projects: ${constructor.projects}",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "📞 Contact: ${constructor.contact}",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
