import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watchhub/models/watch_card.dart';
import '../../models/watch_model.dart';

class NewArrivalsScreen extends StatelessWidget {
  const NewArrivalsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const Text("New Arrivals"), backgroundColor: Colors.black),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('watches')
                .orderBy('createdAt', descending: true)
                .limit(10)
                .snapshots(),
            builder: (c, s) {
              if (!s.hasData)
                return const Center(child: CircularProgressIndicator());
              var list = s.data!.docs
                  .map((d) => WatchModel.fromMap(d.data(), d.id))
                  .toList();
              return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12),
                  itemCount: list.length,
                  itemBuilder: (c, i) => WatchCard(watch: list[i]));
            }));
  }
}
