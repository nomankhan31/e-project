// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BrandDetailsScreen extends StatelessWidget {
  const BrandDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Pichli screen se bheja gaya selected brand data dynamic receive karna
    // Isme {'brandName': 'Rolex', 'description': '...', 'banner': '...'} pass hoga
    final brandData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
            {};
    final String brandName = brandData['brandName'] ?? 'Brand';

    return Scaffold(
      backgroundColor: Colors.black, // App ka black theme
      body: StreamBuilder<QuerySnapshot>(
        // Firestore query se is specific brand ki saari watches live stream fetch kar rahe hain
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('brand', isEqualTo: brandName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          final productDocs = snapshot.hasData ? snapshot.data!.docs : [];

          return CustomScrollView(
            slivers: [
              // 1. Dynamic Expanding AppBar / Brand Banner
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.black,
                leading: IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    brandName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      brandData['banner'] != null
                          ? Image.network(brandData['banner'],
                              fit: BoxFit.cover)
                          : Container(color: Colors.grey[900]),
                      // Shadow overlay tint taake title text saaf nazar aaye
                      Container(color: Colors.black),
                    ],
                  ),
                ),
              ),

              // 2. Brand Description Section Info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "About the Brand",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        brandData['description'] ??
                            "Experience the heritage of exquisite luxury watchmaking. Engineered with timeless aesthetics and precision mechanics tailored for prestige perfection.",
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 14, height: 1.5),
                      ),
                      const Divider(color: Colors.white12, height: 40),
                      Text(
                        "Collection (${productDocs.length})",
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Dynamic Products Grid List Logic
              productDocs.isEmpty
                  ? SliverToBoxAdapter(child: _buildEmptyCollectionState())
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final productRef = productDocs[index];
                            final data =
                                productRef.data() as Map<String, dynamic>;
                            data['id'] = productRef
                                .id; // Injecting doc id reference identity

                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/product_details',
                                    arguments: data);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors
                                      .grey[900], // Premium deep layout box
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.grey,
                                        child: data['image'] != null
                                            ? Image.network(data['image'],
                                                fit: BoxFit.cover)
                                            : const Icon(Icons.watch,
                                                size: 50,
                                                color: Colors.white54),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['name'] ?? 'Premium Model',
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
                          childCount: productDocs.length,
                        ),
                      ),
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCollectionState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Center(
        child: Column(
          children: const [
            Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No Catalog Found",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 4),
            Text(
              "Watches under this brand will appear soon.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
