import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/cart_provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const Text("Wishlist"), backgroundColor: Colors.black),
        body: provider.wishlist.isEmpty
            ? const Center(
                child: Text("No Wishlist",
                    style: TextStyle(color: Colors.white70)))
            : ListView.builder(
                itemCount: provider.wishlist.length,
                itemBuilder: (c, i) {
                  var w = provider.wishlist[i];
                  return ListTile(
                      leading: Image.network(w.imageUrl, width: 50),
                      title: Text(w.name,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text("\$${w.price}",
                          style: const TextStyle(color: Colors.grey)),
                      trailing: IconButton(
                          icon: const Icon(Icons.shopping_cart,
                              color: Colors.white),
                          onPressed: () => provider.addToCart(w)));
                }));
  }
}
