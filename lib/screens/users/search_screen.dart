// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watchhub/models/watch_card.dart';

import '../../models/watch_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  String searchQuery = "";
  String selectedBrand = "All";
  double maxPrice = 50000;

  final List<String> brands = [
    "All",
    "Rolex",
    "Omega",
    "Patek Philippe",
    "Audemars Piguet",
    "Seiko",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search watches...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (val) {
            setState(() => searchQuery = val.toLowerCase());
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('watches').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          var docs = snapshot.data!.docs;
          List<WatchModel> allWatches = docs
              .map(
                (d) =>
                    WatchModel.fromMap(d.data() as Map<String, dynamic>, d.id),
              )
              .toList();

          // Filtering Logic
          List<WatchModel> filtered = allWatches.where((watch) {
            bool matchesSearch = searchQuery.isEmpty ||
                watch.name.toLowerCase().contains(searchQuery) ||
                watch.brand.toLowerCase().contains(searchQuery);
            bool matchesBrand =
                selectedBrand == "All" || watch.brand == selectedBrand;
            bool matchesPrice = watch.price <= maxPrice;
            return matchesSearch && matchesBrand && matchesPrice;
          }).toList();

          if (filtered.isEmpty) {
            return Center(
              child: Text(
                "No results for '$searchQuery'",
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          return Column(
            children: [
              // Active Filter Show
              if (selectedBrand != "All" || maxPrice < 50000)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      if (selectedBrand != "All")
                        Chip(
                          label: Text(selectedBrand),
                          onDeleted: () =>
                              setState(() => selectedBrand = "All"),
                        ),
                      const SizedBox(width: 8),
                      if (maxPrice < 50000)
                        Chip(
                          label: Text("Under \$${maxPrice.toInt()}"),
                          onDeleted: () => setState(() => maxPrice = 50000),
                        ),
                    ],
                  ),
                ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      WatchCard(watch: filtered[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter By",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Brand", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: brands.map((brand) {
                      bool isSelected = selectedBrand == brand;
                      return ChoiceChip(
                        label: Text(brand),
                        selected: isSelected,
                        onSelected: (val) {
                          setModalState(() => selectedBrand = brand);
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Max Price",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Slider(
                    value: maxPrice,
                    min: 1000,
                    max: 50000,
                    divisions: 49,
                    label: "\$${maxPrice.toInt()}",
                    onChanged: (val) {
                      setModalState(() => maxPrice = val);
                      setState(() {});
                    },
                  ),
                  Text(
                    "Up to \$${maxPrice.toInt()}",
                    style: const TextStyle(color: Colors.amber),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("APPLY FILTERS"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
