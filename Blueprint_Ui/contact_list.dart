import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {
  final List<Map<String, String>> contacts = [
    {
      "name": "Rohan Perera",
      "office": "Colombo, Sri Lanka",
      "projects": "Lotus Tower, Sky Residences",
      "contact": "+94 77 123 4567"
    },
    {
      "name": "Kamal Fernando",
      "office": "Kandy, Sri Lanka",
      "projects": "Kandy City Centre, Victoria Golf Resort",
      "contact": "+94 71 987 6543"
    },
    {
      "name": "Samantha De Silva",
      "office": "Galle, Sri Lanka",
      "projects": "Galle Fort Restoration, Ocean View Apartments",
      "contact": "+94 76 456 7890"
    },
    {
      "name": "Nimal Jayawardena",
      "office": "Negombo, Sri Lanka",
      "projects": "Beachfront Villas, Negombo Lagoon Resort",
      "contact": "+94 77 567 1234"
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