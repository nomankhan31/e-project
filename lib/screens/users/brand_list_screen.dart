import 'package:flutter/material.dart';

class BrandListScreen extends StatelessWidget {
  const BrandListScreen({super.key});
  final brands = const [
    "Rolex",
    "Omega",
    "Patek Philippe",
    "Audemars Piguet",
    "Seiko",
    "Casio",
    "Fossil",
    "Tissot"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const Text("All Brands"), backgroundColor: Colors.black),
        body: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemCount: brands.length,
            itemBuilder: (c, i) => GestureDetector(
                onTap: () => Navigator.pushNamed(c, '/brand_detail',
                    arguments: brands[i]),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                        child: Text(brands[i],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16)))))));
  }
}
