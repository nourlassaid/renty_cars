import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  final String imageUrl;
  final String model;
  final String location;
  final String price;
  final double rating;
  final VoidCallback onTap;

  CarCard({
    required this.imageUrl,
    required this.model,
    required this.location,
    required this.price,
    required this.rating,
    required this.onTap, required Null Function() onFavoriteTap, required type,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Image.network(
              imageUrl,
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(location),
                Text(price, style: TextStyle(color: Colors.blue)),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      color: index < rating ? Colors.orange : Colors.grey,
                      size: 18,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
