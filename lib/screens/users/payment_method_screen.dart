import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar:
            AppBar(title: const Text("Payment"), backgroundColor: Colors.black),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              _payTile("Cash on Delivery", Icons.money, true),
              _payTile("Credit Card", Icons.credit_card, false),
              _payTile("JazzCash / Easypaisa", Icons.phone_android, false),
              const Spacer(),
              SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/order_success'),
                      child: const Text("PLACE ORDER")))
            ])));
  }

  Widget _payTile(String t, IconData i, bool sel) => Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: sel ? Border.all(color: Colors.white) : null),
      child: ListTile(
          leading: Icon(i, color: Colors.white),
          title: Text(t, style: const TextStyle(color: Colors.white)),
          trailing: sel
              ? const Icon(Icons.check_circle, color: Colors.green)
              : null));
}
