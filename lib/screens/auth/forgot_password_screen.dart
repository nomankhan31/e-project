import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const Text("Forgot Password"),
            backgroundColor: Colors.black),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              TextField(
                  controller: email,
                  decoration: InputDecoration(
                      hintText: "Enter Email",
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Reset Email Sent")));
                        Navigator.pop(context);
                      },
                      child: const Text("SEND RESET LINK")))
            ])));
  }
}

class FirebaseAuth {
  static get instance => null;
}
