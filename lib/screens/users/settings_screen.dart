import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const Text("Settings"), backgroundColor: Colors.black),
        body: ListView(children: [
          _tile(Icons.notifications, "Notifications", () {}),
          _tile(Icons.lock, "Change Password",
              () => Navigator.pushNamed(context, '/forgot')),
          _tile(Icons.language, "Language", () {}),
          _tile(Icons.info, "About App", () {}),
          _tile(
              Icons.logout,
              "Logout",
              () => Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (r) => false)),
        ]));
  }

  Widget _tile(IconData i, String t, VoidCallback f) => ListTile(
      leading: Icon(i, color: Colors.white),
      title: Text(t, style: const TextStyle(color: Colors.white)),
      onTap: f);
}
