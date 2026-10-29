import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar:
            AppBar(title: const Text("Users"), backgroundColor: Colors.black),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (c, s) {
              if (!s.hasData)
                return const Center(child: CircularProgressIndicator());
              var docs = s.data!.docs;
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (c, i) {
                    var data = docs[i].data();
                    return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(data['email'] ?? 'No Email',
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(data['name'] ?? 'User',
                            style: const TextStyle(color: Colors.grey)),
                        trailing: IconButton(
                            icon: const Icon(Icons.block, color: Colors.red),
                            onPressed: () {}));
                  });
            }));
  }
}
