import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const Text("Edit Profile"), backgroundColor: Colors.black),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const CircleAvatar(
                  radius: 50, child: Icon(Icons.person, size: 50)),
              const SizedBox(height: 20),
              _f("Name"),
              const SizedBox(height: 12),
              _f("Email"),
              const SizedBox(height: 12),
              _f("Phone"),
              const Spacer(),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text("SAVE")))
            ])));
  }

  Widget _f(String h) => TextField(
      decoration: InputDecoration(
          hintText: h,
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
}
