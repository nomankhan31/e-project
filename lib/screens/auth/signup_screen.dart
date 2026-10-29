import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool load = false;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const Text("Sign Up", style: TextStyle(color: Colors.black)),
            backgroundColor: const Color.fromARGB(255, 231, 225, 225)),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(
                  controller: email,
                  style: const TextStyle(
                      color: Colors.white), // Type karne par text white dikhega
                  decoration: _dec("Email")),
              const SizedBox(height: 12),
              TextField(
                  controller: pass,
                  obscureText: true,
                  style: const TextStyle(
                      color: Colors.white), // Type karne par text white dikhega
                  decoration: _dec("Password")),
              const SizedBox(height: 20),
              load
                  ? const CircularProgressIndicator(color: Colors.white)
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.white, // Button background white
                            foregroundColor: Colors.black, // Button text black
                          ),
                          onPressed: () async {
                            final emailText = email.text.trim();
                            final passText = pass.text.trim();

                            if (emailText.isEmpty || passText.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please fill all fields")));
                              return;
                            }

                            setState(() => load = true);
                            try {
                              await AuthService().signUp(emailText, passText);

                              // Async gap check for Navigator
                              if (!mounted) return;
                              Navigator.pushReplacementNamed(context, '/home');
                            } catch (e) {
                              // Async gap check for SnackBar
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            } finally {
                              // Finally block ensures loading safely stops if still mounted
                              if (mounted) {
                                setState(() => load = false);
                              }
                            }
                          },
                          child: const Text("SIGN UP",
                              style: TextStyle(fontWeight: FontWeight.bold)))),
            ])));
  }

  InputDecoration _dec(String h) => InputDecoration(
      hintText: h,
      hintStyle: const TextStyle(
          color: Colors.grey), // Hint text ka color saaf dikhega
      filled: true,
      fillColor: Colors.grey[900],
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
            color: Colors.white), // Click karne par border white hoga
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[800]!),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
}
