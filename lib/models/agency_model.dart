class Agency {
  final String id;
  final String name;
  final String location;
  final String phone;
  final String email;
  final int carsAvailable;
  final double rating;

  Agency({
    required this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.email,
    required this.carsAvailable,
    required this.rating,
  });

  // Conversion de Firestore à objet Agency
  factory Agency.fromFirestore(Map<String, dynamic> data, String id) {
    return Agency(
      id: id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      carsAvailable: data['carsAvailable'] ?? 0,
      rating: data['rating'] ?? 0.0,
    );
  }

  // Conversion d'un objet Agency à Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'phone': phone,
      'email': email,
      'carsAvailable': carsAvailable,
      'rating': rating,
    };
  }
}
