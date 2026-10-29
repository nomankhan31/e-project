import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProductListScreen extends StatelessWidget {
  const AdminProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Manage Products"),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/admin_add_product'),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('watches').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          var docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              var data = docs[i].data();
              return ListTile(
                leading: Image.network(
                  data['imageUrl'],
                  width: 50,
                  errorBuilder: (c, e, s) => const Icon(Icons.watch),
                ),
                title: Text(
                  data['name'],
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  "\$${data['price']} - ${data['brand']}",
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => FirebaseFirestore.instance
                      .collection('watches')
                      .doc(docs[i].id)
                      .delete(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
