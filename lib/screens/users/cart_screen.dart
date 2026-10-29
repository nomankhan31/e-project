import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.black,
      ),
      body: cart.cartItems.isEmpty
          ? const Center(
              child: Text(
                "Cart is Empty",
                style: TextStyle(color: Colors.white),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cart.cartItems[index];
                      return ListTile(
                        leading: Image.network(item.watch.imageUrl, width: 60),
                        title: Text(
                          item.watch.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          "\$${item.watch.price} x ${item.quantity}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => cart.removeFromCart(item.watch.id),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.grey[900],
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total:"),
                          Text(
                            "\$${cart.totalPrice}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/checkout'),
                          child: const Text("CHECKOUT"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
