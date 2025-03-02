import 'package:flutter/material.dart';
import 'contact.dart';

class ContactList extends StatelessWidget {
  final List<Contact> contacts;

  ContactList({required this.contacts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(contacts[index].profileImage),
          ),
          title: Text(contacts[index].name),
          trailing: Icon(Icons.more_vert),
          onTap: () {
            // Handle Contact Click
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Clicked on ${contacts[index].name}"))
            );
          },
        );
      },
    );
  }
}
