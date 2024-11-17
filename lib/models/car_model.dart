class CarModel {
  String id;
  String model;
  String location;
  String price;
  double rating;
  String type;
  String imageUrl;

  CarModel({
    required this.id,
    required this.model,
    required this.location,
    required this.price,
    required this.rating,
    required this.type,
    required this.imageUrl,
  });

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'],
      model: map['model'],
      location: map['location'],
      price: map['price'],
      rating: map['rating'],
      type: map['type'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'model': model,
      'location': location,
      'price': price,
      'rating': rating,
      'type': type,
      'imageUrl': imageUrl,
    };
  }
}
