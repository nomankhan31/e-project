// TODO Implement this library.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Firebase Auth se current login user ka data le rahe hain
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black, // App ka black theme
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // User Profile Section (Dynamic)
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.black),
            ),
            const SizedBox(height: 12),
            Text(
              user?.email ??
                  "Guest User", // Firebase se user ka email dynamic show hoga
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),

            // Settings Options List
            _buildSettingTile(
              icon: Icons.location_on_outlined,
              title: "Shipping Address",
              onTap: () {
                Navigator.pushNamed(context, '/shipping_address');
              },
            ),
            _buildSettingTile(
              icon: Icons.favorite_border,
              title: "My Wishlist",
              onTap: () {
                Navigator.pushNamed(context, '/wishlist');
              },
            ),
            _buildSettingTile(
              icon: Icons.chat_bubble_outline,
              title: "Customer Support",
              onTap: () {
                Navigator.pushNamed(context, '/support_chat');
              },
            ),
            _buildSettingTile(
              icon: Icons.notifications_none_outlined,
              title: "Notifications",
              onTap: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Colors.white24, height: 40),
            ),

            // Sign Out Button (Dynamic)
            _buildSettingTile(
              icon: Icons.logout,
              title: "Sign Out",
              titleColor: Colors.redAccent,
              iconColor: Colors.redAccent,
              onTap: () async {
                // Firebase Auth se logout karne ki logic
                await FirebaseAuth.instance.signOut();

                if (!context.mounted) return;
                // Logout ke baad wapas Login/Signup screen par bhejne ke liye
                Navigator.pushReplacementNamed(context, '/signup');
              },
            ),
          ],
        ),
      ),
    );
  }

  // Setting Tile Builder Custom Widget
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color titleColor = Colors.white,
    Color iconColor = Colors.grey,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900], // Dark tile background
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: iconColor),
          title: Text(
            title,
            style: TextStyle(color: titleColor, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.arrow_forward_ios,
              color: Colors.white24, size: 16),
        ),
      ),
    );
  }
}
