import 'package:flutter/material.dart';

class CarDetailPage extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String description;
  final List<String> images;
  final List<Color> colors;

  CarDetailPage({
    required this.title,
    required this.location,
    required this.price,
    required this.description,
    required this.images,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Car details for $title'),
      ),
    );
  }
}