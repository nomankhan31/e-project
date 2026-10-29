import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isAddingToCart = false;
  bool _isAddingToWishlist = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _formatPrice(dynamic price) {
    if (price == null) return '0.00';

    if (price is num) {
      return price.toStringAsFixed(2);
    }

    final parsed = num.tryParse(price.toString());

    return parsed?.toStringAsFixed(2) ?? price.toString();
  }

  String _productId(Map<String, dynamic> product) {
    final id = product['id']?.toString();

    if (id != null && id.isNotEmpty) {
      return id;
    }

    final name = product['name']?.toString();

    if (name != null && name.isNotEmpty) {
      return name;
    }

    return 'unknown_product';
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  // Add product to Firebase cart.
  Future<void> _addToCart(Map<String, dynamic> product) async {
    final user = _auth.currentUser;

    if (user == null) {
      _showSnackBar('Please login to add items to your cart.');
      return;
    }

    if (_isAddingToCart) return;

    setState(() => _isAddingToCart = true);

    try {
      final id = _productId(product);

      final cartRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(id);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(cartRef);

        if (snapshot.exists) {
          final currentQuantity =
              (snapshot.data()?['quantity'] as num?)?.toInt() ?? 1;

          transaction.update(cartRef, {
            'quantity': currentQuantity + 1,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          transaction.set(cartRef, {
            'id': id,
            'name': product['name'] ?? 'Premium Watch',
            'price': product['price'] ?? 0,
            'image': product['image'] ?? '',
            'quantity': 1,
            'addedAt': FieldValue.serverTimestamp(),
          });
        }
      });

      _showSnackBar('Product added to cart successfully!');
    } catch (e) {
      _showSnackBar('Unable to add product to cart. Please try again.');
      debugPrint('Add to cart error: $e');
    } finally {
      if (mounted) {
        setState(() => _isAddingToCart = false);
      }
    }
  }

  // Add product to Firebase wishlist.
  Future<void> _addToWishlist(
    Map<String, dynamic> product,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      _showSnackBar('Please login to use your wishlist.');
      return;
    }

    if (_isAddingToWishlist) return;

    setState(() => _isAddingToWishlist = true);

    try {
      final id = _productId(product);

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .doc(id)
          .set({
        'id': id,
        'name': product['name'] ?? 'Premium Watch',
        'price': product['price'] ?? 0,
        'image': product['image'] ?? '',
        'addedAt': FieldValue.serverTimestamp(),
      });

      _showSnackBar('Product added to wishlist!');
    } catch (e) {
      _showSnackBar('Unable to update wishlist. Please try again.');
      debugPrint('Wishlist error: $e');
    } finally {
      if (mounted) {
        setState(() => _isAddingToWishlist = false);
      }
    }
  }

  Widget _buildProductImage(dynamic image) {
    final imageUrl = image?.toString() ?? '';

    return Container(
      width: double.infinity,
      height: 300,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;

                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.watch_outlined,
                      size: 100,
                      color: Colors.white38,
                    ),
                  );
                },
              )
            : const Center(
                child: Icon(
                  Icons.watch_outlined,
                  size: 100,
                  color: Colors.white38,
                ),
              ),
      ),
    );
  }

  Widget _buildFeature(
    IconData icon,
    String title,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.amber, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    final Map<String, dynamic> product =
        arguments is Map<String, dynamic> ? arguments : {};

    final productName = product['name']?.toString() ?? 'Premium Watch';

    final description = product['description']?.toString() ??
        'A premium luxury watch crafted for elegance, '
            'style, and everyday comfort.';

    final price = _formatPrice(product['price']);

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Wishlist',
            onPressed:
                _isAddingToWishlist ? null : () => _addToWishlist(product),
            icon: _isAddingToWishlist
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
          ),
        ],
      ),

      // Scrollable page prevents content overflow.
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(product['image']),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PREMIUM COLLECTION',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      productName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$$price',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Why You Will Love It',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildFeature(
                          Icons.verified_outlined,
                          'Premium Quality',
                        ),
                        _buildFeature(
                          Icons.watch_outlined,
                          'Elegant Design',
                        ),
                        _buildFeature(
                          Icons.local_shipping_outlined,
                          'Delivery Available',
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: Colors.amber.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed:
                            _isAddingToCart ? null : () => _addToCart(product),
                        child: _isAddingToCart
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_bag_outlined),
                                  SizedBox(width: 10),
                                  Text(
                                    'ADD TO CART',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'Secure shopping with WatchHub',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
