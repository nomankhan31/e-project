import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _controller,
        onPageChanged: (i) => setState(() => index = i),
        children: [
          _page("Welcome to WatchHub", "Discover luxury watches", Icons.watch),
          _page("Premium Collection", "Rolex, Omega, Patek & more", Icons.star),
          _page("Fast Delivery", "Get your watch in 2-3 days",
              Icons.local_shipping),
        ],
      ),
      bottomSheet: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                child: const Text("Skip")),
            ElevatedButton(
                onPressed: () {
                  if (index == 2) {
                    Navigator.pushReplacementNamed(context, '/login');
                  } else {
                    _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  }
                },
                child: Text(index == 2 ? "START" : "NEXT"))
          ])),
    );
  }

  Widget _page(String t, String d, IconData i) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(i, size: 100, color: Colors.white),
        const SizedBox(height: 20),
        Text(t,
            style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Text(d, style: const TextStyle(color: Colors.grey))
      ]);
}
