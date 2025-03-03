import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactList extends StatelessWidget {
  final List<Map<String, String>> constructors = [
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

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not launch $phoneNumber";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Sri Lanka Constructors"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: constructors.length,
          itemBuilder: (context, index) {
            final constructor = constructors[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(constructor["photo"]!),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            constructor["name"]!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "📍 ${constructor["location"]}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "🏗️ Projects: ${constructor["projects"]}",
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                          SizedBox(height: 6),
                          GestureDetector(
                            onTap: () => _makePhoneCall(constructor["contact"]!),
                            child: Row(
                              children: [
                                Icon(Icons.phone, color: Colors.green, size: 18),
                                SizedBox(width: 5),
                                Text(
                                  constructor["contact"]!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ContactList(),
  ));
}