import 'package:flutter/material.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const Text("Analytics"), backgroundColor: Colors.black),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _box("Total Sales", "\$45,200", Colors.green),
                  _box("Total Orders", "128", Colors.blue),
                  _box("Total Users", "342", Colors.amber),
                  _box("Products", "56", Colors.purple),
                ])));
  }

  Widget _box(String t, String v, Color c) => Container(
      decoration: BoxDecoration(
          color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(v,
            style:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: c)),
        Text(t, style: const TextStyle(color: Colors.white70))
      ]));
}
