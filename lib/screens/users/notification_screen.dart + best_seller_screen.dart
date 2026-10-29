// notification_screen.dart
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            const Text("Notifications", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.all(10),
        itemBuilder: (c, i) => Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: const ListTile(
            leading: Icon(Icons.notifications, color: Colors.amber),
            title: Text("New Watch Added!",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text("Check out new Rolex collection",
                style: TextStyle(color: Colors.grey)),
          ),
        ),
      ),
    );
  }
}
