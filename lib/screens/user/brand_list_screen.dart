// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({super.key});

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  // Default selected watch brand
  String _selectedBrand = "Rolex";

  // Famous watch brands list selection
  final List<String> _brands = ["Rolex", "Omega", "Casio", "Seiko", "Tissot"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // App ka black theme
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Watch Brands",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Horizontal Scrollable Brand List Chips Selector
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _brands.length,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemBuilder: (context, index) {
                final brandName = _brands[index];
                bool isSelected = _selectedBrand == brandName;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(brandName),
                    selected: isSelected,
                    selectedColor: Colors.white,
                    backgroundColor: Colors.grey[900], // Dark grey element item
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          _selectedBrand = brandName;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Available Collections",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),

          // 2. Dynamic Real-time Live Firestore Brand Filtered Products Grid
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // Firestore query for tracking filtered brand key dynamically
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('brand', isEqualTo: _selectedBrand)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                final products = snapshot.data!.docs;

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final productRef = products[index];
                    final data = productRef.data() as Map<String, dynamic>;
                    data['id'] =
                        productRef.id; // Map object reference setting identity

                    return GestureDetector(
                      onTap: () {
                        // Routing dynamic pass data logic mapping inside app manager
                        Navigator.pushNamed(context, '/product_details',
                            arguments: data);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors
                              .grey, // Premium Dark Grey Grid Card Background
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Network Dynamic Image Layout view box
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                color: Colors.grey,
                                child: data['image'] != null
                                    ? Image.network(data['image'],
                                        fit: BoxFit.cover)
                                    : const Icon(Icons.watch,
                                        size: 50, color: Colors.white54),
                              ),
                            ),
                            // Text Details Card Section Info
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'] ?? 'Premium Watch',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "\$${data['price'] ?? '0'}",
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.workspace_premium_outlined,
              size: 70, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            "No Watches found for $_selectedBrand",
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          const Text(
            "Please check out other luxury brand list tabs.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
