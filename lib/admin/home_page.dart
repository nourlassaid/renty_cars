import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
     body: StreamBuilder<QuerySnapshot>(

  stream: FirebaseFirestore.instance.collection('cars').snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Center(child: Text('No cars found.'));
    }

    final cars = snapshot.data!.docs;

    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];
        final data = car.data() as Map<String, dynamic>?; // Cast explicite

        // Gestion des données nulles ou manquantes
        final title = data?['title'] ?? 'Unknown';
        final location = data?['location'] ?? 'Unknown';
        final price = data?['price'] != null ? "${data!['price']}DT per day" : 'N/A';
        final rating = data?['rating'] != null ? (data!['rating'] as num).toDouble() : 0.0;

        // Conversion explicite en List<String>
        final images = data?['images'] != null
            ? List<String>.from(data!['images'] as List)
            : [];

        return CarCard(
          title: title,
          location: location,
          price: price,
          rating: rating, images: [],
        
        );
      },
    );
  },
),


    );
  }
}

class CarCard extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final double rating;
  final List<String> images;

  CarCard({
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (images.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                images.first,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(location, style: TextStyle(color: Colors.grey)),
                SizedBox(height: 8),
                Text(price, style: TextStyle(fontSize: 16, color: Colors.blue)),
                SizedBox(height: 8),
                Row(
                  children: List.generate(
                    rating.round(),
                    (index) => Icon(Icons.star, color: Colors.yellow, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
