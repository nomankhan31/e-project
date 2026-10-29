import 'package:flutter/foundation.dart';

import '../models/cart_model.dart';
import '../models/watch_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartModel> _cartItems = [];
  final List<WatchModel> _wishlist = [];

  List<CartModel> get cartItems => List.unmodifiable(_cartItems);

  List<WatchModel> get wishlist => List.unmodifiable(_wishlist);

  double get totalPrice {
    double total = 0;

    for (final item in _cartItems) {
      total += item.watch.price * item.quantity;
    }

    return total;
  }

  void addToCart(WatchModel watch) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.watch.id == watch.id,
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity++;
    } else {
      _cartItems.add(CartModel(watch: watch));
    }

    notifyListeners();
  }

  void removeFromCart(String id) {
    _cartItems.removeWhere((item) => item.watch.id == id);

    notifyListeners();
  }

  void addToWishlist(WatchModel watch) {
    final alreadyExists = _wishlist.any((item) => item.id == watch.id);

    if (!alreadyExists) {
      _wishlist.add(watch);
      notifyListeners();
    }
  }

  void removeFromWishlist(String id) {
    _wishlist.removeWhere((watch) => watch.id == id);

    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
