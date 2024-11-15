import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('favorites').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No favorites found.'));
          }

          final favoriteCars = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favoriteCars.length,
            itemBuilder: (context, index) {
              final car = favoriteCars[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.network(car['imageUrl'], width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(car['model'] ?? 'Unknown Model'),
                  subtitle: Text(
                    '${car['location'] ?? 'Unknown Location'}\n${car['price'] ?? ''}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: Text('${car['rating'] ?? ''} ⭐'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
