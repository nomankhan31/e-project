// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? _shippingAddress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAddressAndCart();
  }

  void _fetchAddressAndCart() async {
    if (_user == null) return;
    try {
      DocumentSnapshot addressDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.toString())
          .collection('address')
          .doc('shipping')
          .get();

      if (addressDoc.exists) {
        setState(() {
          _shippingAddress = addressDoc.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _placeOrder(double totalAmount) async {
    if (_shippingAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please add shipping address first")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Get all cart items
      var cartSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('cart')
          .get();
      List<Map<String, dynamic>> orderItems = [];

      for (var doc in cartSnapshot.docs) {
        orderItems.add(doc.data());
      }

      // 2. Create Global Order
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': _user!.uid,
        'items': orderItems,
        'totalAmount': totalAmount,
        'address': _shippingAddress,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Clear User Cart database safely
      for (var doc in cartSnapshot.docs) {
        await doc.reference.delete();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order Placed Successfully! 🎉")));
      Navigator.popUntil(context, ModalRoute.withName('/home'));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount =
        ModalRoute.of(context)!.settings.arguments as double? ?? 0.0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        title: const Text("Checkout",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Shipping Address Details",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _shippingAddress == null
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              const Text("No address found!",
                                  style: TextStyle(color: Colors.white70)),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(
                                        context, '/shipping_address')
                                    .then((_) => _fetchAddressAndCart()),
                                child: const Text("Add Address",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_shippingAddress!['fullName'] ?? '',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(_shippingAddress!['phone'] ?? '',
                                  style:
                                      const TextStyle(color: Colors.white70)),
                              Text(
                                  "${_shippingAddress!['addressDetails'] ?? ''}, ${_shippingAddress!['city'] ?? ''}",
                                  style:
                                      const TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                  const Spacer(),
                  // Price details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Order Total:",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      Text("\$${totalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black),
                      onPressed: () => _placeOrder(totalAmount),
                      child: const Text("PLACE ORDER",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
