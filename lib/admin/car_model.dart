import 'dart:ui';

class Car {
  final String id;
  final String title;
  final String location;
  final String price;
  final double rating;
  final List<String> images;
  final List<Color> colors;

  Car({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.images,
    required this.colors,
  });

  factory Car.fromFirestore(Map<String, dynamic> data, String id) {
    return Car(
      id: id,
      title: data['title'],
      location: data['location'],
      price: data['price'],
      rating: data['rating'],
      images: List<String>.from(data['images']),
      colors: (data['colors'] as List).map((color) => Color(color)).toList(),
    );
  }
}