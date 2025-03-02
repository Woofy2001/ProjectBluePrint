import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contacts App")),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/mavan.jpg"),
                  ),
                  SizedBox(height: 10),
                  Text("Mavan Athapaththu", 
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text("Office Location"),
              subtitle: Text("Colombo, Sri Lanka"),
            ),
            ListTile(
              leading: Icon(Icons.apartment),
              title: Text("Projects Completed"),
              subtitle: Text("10+ Construction Projects"),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text("Contact Number"),
              subtitle: Text("+94 76 123 4567"),
            ),
          ],
        ),
      ),
      body: Center(child: Text("Welcome to Contacts App")),
    );
  }
}
