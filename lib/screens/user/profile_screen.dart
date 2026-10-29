// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          "My Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: user == null
          ? const Center(
              child: Text(
                "Please login to view profile",
                style: TextStyle(color: Colors.white),
              ),
            )
          : StreamBuilder<DocumentSnapshot>(
              // Firestore se user document ka live dynamic data stream le rahe hain
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                Map<String, dynamic>? userData;
                String memberSince = "N/A";

                if (snapshot.hasData && snapshot.data!.exists) {
                  userData = snapshot.data!.data() as Map<String, dynamic>?;

                  // Timestamp ko formatted date mein badalna
                  if (userData?['createdAt'] != null) {
                    Timestamp timestamp = userData!['createdAt'];
                    DateTime date = timestamp.toDate();
                    memberSince = "${date.day}/${date.month}/${date.year}";
                  }
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // Profile Avatar
                      const Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child:
                              Icon(Icons.person, size: 60, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // User Info Cards (Dynamic Data)
                      _buildInfoTile(
                          "Email", user.email ?? "N/A", Icons.email_outlined),
                      const SizedBox(height: 12),
                      _buildInfoTile("User ID", user.uid, Icons.fingerprint),
                      const SizedBox(height: 12),
                      _buildInfoTile("Member Since", memberSince,
                          Icons.calendar_today_outlined),

                      const SizedBox(height: 40),

                      // Quick Navigation Buttons
                      _buildActionRow(
                        context,
                        title: "Edit Shipping Address",
                        icon: Icons.local_shipping_outlined,
                        route: '/shipping_address',
                      ),
                      const SizedBox(height: 12),
                      _buildActionRow(
                        context,
                        title: "View My Wishlist",
                        icon: Icons.favorite_border,
                        route: '/wishlist',
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // Info Tile Builder
  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey, // Dark theme box
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Navigation Row Builder
  Widget _buildActionRow(BuildContext context,
      {required String title, required IconData icon, required String route}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white54, size: 14),
          ],
        ),
      ),
    );
  }
}
