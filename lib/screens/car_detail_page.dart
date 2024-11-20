import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rentycars_nour/screens/Loginpage.dart';
import 'package:rentycars_nour/screens/ReservationFormPage.dart';
import 'package:rentycars_nour/screens/ReviewPage.dart';

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
  bool isLoading = false;
  PageController _pageController = PageController();
  Timer? _carouselTimer;

  final List<String> fallbackImages = [
    'assets/car_default.jpg',
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
      try {
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
      } catch (e) {
        print("Error checking favorite status: $e");
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
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
      } catch (e) {
        print("Error toggling favorite status: $e");
      }
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

  Future<bool> _showLoginDialog(BuildContext context) async {
    return await showDialog<bool>(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Login Required'),
        content: Text('You need to log in to reserve this car.'),
        actions: <Widget>[
          TextButton(onPressed: () { Navigator.pop(context, false); }, child: Text('Cancel')),
          TextButton(onPressed: () { Navigator.pop(context, true); }, child: Text('Login')),
        ],
      );
    }) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [widget.imageUrl, ...fallbackImages];
    final String description = getCarDescription();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
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
                      final image = index == 0 ? widget.imageUrl : fallbackImages[index - 1];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: image.startsWith('http')
                            ? Image.network(image, fit: BoxFit.cover)
                            : Image.asset(image, fit: BoxFit.cover),
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
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(widget.rating.toString(), style: TextStyle(fontSize: 16)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ReviewPage(postId: '',)),
                              );
                            },
                            child: Text(" (5 reviews)", style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(widget.model, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(widget.location, style: TextStyle(fontSize: 16, color: Colors.grey)),
                      SizedBox(height: 16),
                      Divider(),
                      Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(description, style: TextStyle(fontSize: 16, color: Colors.black87)),
                      SizedBox(height: 16),
                      Divider(),
                      Text("Available Colors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        children: colors.map((color) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: {
                                'Red': Colors.red,
                                'Blue': Colors.blue,
                                'Black': Colors.black,
                                'White': Colors.white,
                              }[color] ?? Colors.grey,
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      Text("Specifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: specifications.map((spec) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(spec["icon"], color: Colors.blue, size: 40),
                              SizedBox(height: 4),
                              Text(spec["value"]),
                            ],
                          );
                        }).toList(),
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
            Text('${widget.price} per day', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;

                if (user != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationFormPage()));
                } else {
                  bool shouldLogin = await _showLoginDialog(context);
                  if (shouldLogin) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Reserve Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
