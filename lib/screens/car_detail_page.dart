import 'package:flutter/material.dart';
import '../screens/LoginPage.dart';

class CarDetailPage extends StatelessWidget {
  final String imageUrl;
  final String model;
  final String location;
  final String price;
  final double rating;
  final String type;

  // Assume this variable represents the user's login status
  final bool isLoggedIn = false; // Set this based on actual authentication status

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car image with favorite icon
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.favorite_border, color: Colors.red),
                          onPressed: () {
                            // Logic to add to favorites
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Car details
                      Text(
                        model,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        location,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange),
                          SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the ReviewPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ReviewPage()),
                              );
                            },
                            child: Text(
                              " (5 reviews)",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      // User info and amenities
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/user.png'),
                            radius: 20,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("nour lassaid", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text("NEW", style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.chat, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.phone, color: Colors.blue),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'This car is located at a convenient location and comes with the following features...',
                        style: TextStyle(color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.tv, color: Colors.black),
                          SizedBox(width: 8),
                          Text('TV'),
                          SizedBox(width: 16),
                          Icon(Icons.wifi, color: Colors.black),
                          SizedBox(width: 8),
                          Text('Wifi'),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom booking button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$price per day',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (!isLoggedIn) {
                        // Navigate to the LoginPage if not logged in
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      } else {
                        // Show reservation confirmation if logged in
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Reservation Confirmed'),
                              content: Text('You have successfully reserved the $model.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text('Reserve Now'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Define the ReviewPage
class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text("This is the reviews page"),
      ),
    );
  }
}

// Define the LoginPage
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text("This is the login page"),
      ),
    );
  }
}