import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar:
            AppBar(title: const Text("Orders"), backgroundColor: Colors.black),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('orders').snapshots(),
            builder: (c, s) {
              if (!s.hasData)
                return const Center(child: CircularProgressIndicator());
              if (s.data!.docs.isEmpty)
                return const Center(
                    child: Text("No Orders Yet",
                        style: TextStyle(color: Colors.white70)));
              var docs = s.data!.docs;
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (c, i) {
                    var data = docs[i].data();
                    return ListTile(
                        tileColor: Colors.grey[900],
                        title: Text("Order #${docs[i].id.substring(0, 6)}",
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(
                            "\$${data['total'] ?? 0} - ${data['status'] ?? 'Pending'}",
                            style: const TextStyle(color: Colors.grey)),
                        trailing: PopupMenuButton(
                            onSelected: (val) => FirebaseFirestore.instance
                                .collection('orders')
                                .doc(docs[i].id)
                                .update({'status': val}),
                            itemBuilder: (c) => [
                                  const PopupMenuItem(
                                      value: "Pending", child: Text("Pending")),
                                  const PopupMenuItem(
                                      value: "Shipped", child: Text("Shipped")),
                                  const PopupMenuItem(
                                      value: "Delivered",
                                      child: Text("Delivered"))
                                ]));
                  });
            }));
  }
}
