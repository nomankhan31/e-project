import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watchhub/models/watch_card.dart';
import '../../models/watch_model.dart';

class BrandDetailScreen extends StatelessWidget {
  const BrandDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final brand = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: Text(brand), backgroundColor: Colors.black),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('watches')
                .where('brand', isEqualTo: brand)
                .snapshots(),
            builder: (c, s) {
              if (!s.hasData)
                return const Center(child: CircularProgressIndicator());
              var watches = s.data!.docs
                  .map((d) => WatchModel.fromMap(d.data(), d.id))
                  .toList();
              return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12),
                  itemCount: watches.length,
                  itemBuilder: (c, i) => WatchCard(watch: watches[i]));
            }));
  }
}
