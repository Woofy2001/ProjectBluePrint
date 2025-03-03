import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {
  final List<Map<String, String>> contacts = [
    {
      "name": "Nimal Perera",
      "office": "Colombo 03, Sri Lanka",
      "photo": "assets/con1.jpg",
      "projects": "Lotus Tower, Sky Residences",
      "contact": "+94 77 123 4567"
    },
    {
      "name": "Samantha Silva",
      "office": "Kandy, Sri Lanka",
      "photo": "assets/con2.jpg",
      "projects": "Kandy City Centre, Victoria Golf Resort",
      "contact": "+94 71 987 6543"
    },
    {
      "name": "Anura Jayasinghe",
      "office": "Galle, Sri Lanka",
      "photo": "assets/con3.jpg",
      "projects": "Galle Fort Restoration, Ocean View Apartments",
      "contact": "+94 76 456 7890"
    },
    {
      "name": "Pradeep Wickramasinghe",
      "office": "Kurunegala, Sri Lanka",
      "photo": "assets/con4.jpg",
      "projects": "Beachfront Villas, Kurunegala Lagoon Resort",
      "contact": "+94 77 567 1234"
    },
    {
      "name": "Kumarasinghe Hettiarachchi",
      "office": "Jaffna, Sri Lanka",
      "photo": "assets/con5.jpg",
      "projects": "Hospitals, Public infrastructure",
      "contact": "+94 71 678 9012"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sri Lankan Constructors"),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.engineering, color: Colors.blue),
              title: Text(contacts[index]["name"]!,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Office: ${contacts[index]["office"]}"),
                  Text("Projects: ${contacts[index]["projects"]}"),
                  Text("Contact: ${contacts[index]["contact"]}"),
                ],
              ),
              trailing: Icon(Icons.phone, color: Colors.green),
              onTap: () {
                // You can add functionality here, like calling the number
              },
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ContactList(),
  ));
}