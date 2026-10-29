import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const Text("My Orders"), backgroundColor: Colors.black),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('orders').snapshots(),
            builder: (c, s) {
              if (!s.hasData)
                return const Center(child: CircularProgressIndicator());
              if (s.data!.docs.isEmpty)
                return const Center(
                    child: Text("No Orders",
                        style: TextStyle(color: Colors.white70)));
              var docs = s.data!.docs;
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (c, i) {
                    var d = docs[i].data();
                    return Card(
                        color: Colors.grey[900],
                        child: ListTile(
                            title: Text("Order #${docs[i].id.substring(0, 6)}",
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(
                                "Status: ${d['status'] ?? 'Pending'}",
                                style: const TextStyle(color: Colors.grey)),
                            trailing: Text("\$${d['total'] ?? 0}",
                                style: const TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold))));
                  });
            }));
  }
}
