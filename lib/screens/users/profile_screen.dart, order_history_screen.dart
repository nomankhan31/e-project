import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar:
            AppBar(title: const Text("Profile"), backgroundColor: Colors.black),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 10),
          const Center(
              child: Text("User Name",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
          const SizedBox(height: 20),
          _tile(Icons.history, "Order History",
              () => Navigator.pushNamed(context, '/order_history')),
          _tile(Icons.location_on, "Addresses",
              () => Navigator.pushNamed(context, '/shipping')),
          _tile(Icons.settings, "Settings",
              () => Navigator.pushNamed(context, '/settings')),
          _tile(
              Icons.logout,
              "Logout",
              () => Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (r) => false)),
        ]));
  }

  Widget _tile(IconData i, String t, VoidCallback tap) => ListTile(
      leading: Icon(i, color: Colors.white),
      title: Text(t, style: const TextStyle(color: Colors.white)),
      onTap: tap,
      tileColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
}
