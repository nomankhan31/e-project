import 'package:flutter/material.dart';

class ShippingAddressScreen extends StatelessWidget {
  const ShippingAddressScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const Text("Shipping Address"),
            backgroundColor: Colors.black),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              _field("Full Name"),
              const SizedBox(height: 12),
              _field("Phone"),
              const SizedBox(height: 12),
              _field("Address"),
              const SizedBox(height: 12),
              _field("City"),
              const SizedBox(height: 12),
              _field("Postal Code"),
              const Spacer(),
              SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/payment'),
                      child: const Text("CONTINUE")))
            ])));
  }

  Widget _field(String h) => TextField(
      decoration: InputDecoration(
          hintText: h,
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
}
