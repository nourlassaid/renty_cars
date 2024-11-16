import 'package:flutter/material.dart';
class CarCard extends StatelessWidget {
  final String imageUrl;
  final String model;
  final String location;
  final String price;
  final double rating;
  final String type;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap; // Callback pour les favoris

  CarCard({
    required this.imageUrl,
    required this.model,
    required this.location,
    required this.price,
    required this.rating,
    required this.type,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Image.asset(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(location, style: TextStyle(color: Colors.grey)),
                  Text(price, style: TextStyle(color: Colors.blue)),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 16),
                      Text(rating.toString(), style: TextStyle(color: Colors.grey)),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.favorite_border, color: Colors.red),
                        onPressed: onFavoriteTap, // Appel lors du clic
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
