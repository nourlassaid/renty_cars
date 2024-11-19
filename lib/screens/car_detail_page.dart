import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rentycars_nour/screens/Loginpage.dart';
import 'package:rentycars_nour/screens/ReservationFormPage.dart';

class CarDetailPage extends StatefulWidget {
  final String imageUrl;
  final String model;
  final String location;
  final String price;
  final double rating;
  final String type;

  const CarDetailPage({
    Key? key,
    required this.imageUrl,
    required this.model,
    required this.location,
    required this.price,
    required this.rating,
    required this.type,
  }) : super(key: key);

  @override
  _CarDetailPageState createState() => _CarDetailPageState();
}

class _CarDetailPageState extends State<CarDetailPage> {
  bool isFavorite = false;
  PageController _pageController = PageController();
  Timer? _carouselTimer;

  final List<String> fallbackImages = [
    'assets/car_default.jpg', // Placeholder image
    'assets/car2.jpg'
  ];

  final List<Map<String, dynamic>> specifications = [
    {"icon": Icons.speed, "value": "200 km/h"},
    {"icon": Icons.local_gas_station, "value": "Petrol"},
    {"icon": Icons.people, "value": "4 Seats"},
    {"icon": Icons.ac_unit, "value": "Automatic AC"},
    {"icon": Icons.bolt, "value": "Electric Option"},
  ];

  final List<String> colors = ['Red', 'Blue', 'Black', 'White'];

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
    _startCarousel();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startCarousel() {
    _carouselTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        _pageController.animateToPage(
          nextPage % fallbackImages.length,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  Future<void> _checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final carRef = FirebaseFirestore.instance
          .collection('favorites')
          .doc(user.uid)
          .collection('cars')
          .doc(widget.model);

      final docSnapshot = await carRef.get();
      if (docSnapshot.exists) {
        setState(() {
          isFavorite = true;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final carRef = FirebaseFirestore.instance
          .collection('favorites')
          .doc(user.uid)
          .collection('cars')
          .doc(widget.model);

      if (isFavorite) {
        await carRef.delete();
      } else {
        await carRef.set({
          'imageUrl': widget.imageUrl,
          'model': widget.model,
          'price': widget.price,
          'location': widget.location,
          'rating': widget.rating,
        });
      }

      setState(() {
        isFavorite = !isFavorite;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  String getCarDescription() {
    switch (widget.type) {
      case "SUV":
        return "This SUV offers exceptional comfort and power, making it perfect for long journeys or family trips.";
      case "Sedan":
        return "This Sedan is the epitome of elegance and performance, ideal for city rides and business purposes.";
      case "Electric":
        return "This Electric car is environmentally friendly with cutting-edge technology and impressive efficiency.";
      default:
        return "This vehicle is a great choice for any occasion, offering reliability, style, and excellent performance.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      widget.imageUrl,
      ...fallbackImages,
    ];

    final String description = getCarDescription();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar with Image Background and Favorite Icon on Top
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          images[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.model,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.location,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 8),
                      // Description
                      Text(
                        "Description",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 8),
                      // Available Colors
                      Text(
                        "Available Colors",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: colors.map((color) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: color == 'Red'
                                  ? Colors.red
                                  : color == 'Blue'
                                      ? Colors.blue
                                      : color == 'Black'
                                          ? Colors.black
                                          : Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 8),
                      // Specifications
                      Text(
                        "Specifications",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: specifications.length,
                          itemBuilder: (context, index) {
                            final spec = specifications[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  Icon(
                                    spec["icon"],
                                    color: Colors.blue,
                                    size: 40,
                                  ),
                                  SizedBox(height: 4),
                                  Text(spec["value"]),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.price} per day',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () async {
                // Vérifier si l'utilisateur est connecté
                final user = FirebaseAuth.instance.currentUser;
                
                if (user != null) {
                  // L'utilisateur est connecté, on passe à la page de réservation
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReservationFormPage()),
                  );
                } else {
                  // L'utilisateur n'est pas connecté, afficher un message de connexion
                  bool shouldLogin = await _showLoginDialog(context);
                  if (shouldLogin) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Reserve Now',
                style: TextStyle(
                  fontFamily: 'Roboto', // Using custom font
                  fontSize: 16,         // Font size
                  fontWeight: FontWeight.bold, // Font weight
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction d'affichage du dialogue de connexion
  Future<bool> _showLoginDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Required'),
          content: Text('You need to log in to reserve this car.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // L'utilisateur choisit de ne pas se connecter
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // L'utilisateur choisit de se connecter
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    ) ?? false; // Par défaut, on retourne false si le dialogue est annulé
  }
}
