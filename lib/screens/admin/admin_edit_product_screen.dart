import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminEditProductScreen extends StatelessWidget {
  const AdminEditProductScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final id = args?['id'] ?? '';
    final name = TextEditingController(text: args?['name'] ?? '');
    final price = TextEditingController(text: args?['price']?.toString() ?? '');
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const Text("Edit Product"), backgroundColor: Colors.black),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              TextField(
                  controller: name,
                  decoration: InputDecoration(
                      hintText: "Name",
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 12),
              TextField(
                  controller: price,
                  decoration: InputDecoration(
                      hintText: "Price",
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('watches')
                            .doc(id)
                            .update({
                          'name': name.text,
                          'price': double.tryParse(price.text) ?? 0
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("UPDATE")))
            ])));
  }
}
