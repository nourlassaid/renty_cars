import 'package:flutter/material.dart';
import '../screens/LoginPage.dart';
import '../screens/ReservationFormPage.dart';  // Import the ReservationFormPage

class CarDetailPage extends StatelessWidget {
  final String imageUrl;
  final String model;
  final String location;
  final String price;
  final double rating;
  final String type;

  // Simulating login status
  final bool isLoggedIn = false; // Update based on actual authentication status

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
                          Icon(Icons.star, color:Colors.blue),
                          SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
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
                        // Navigate to LoginPage if not logged in
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => LoginPage()),
                      //   );
                      // } else {
                        // Navigate to the reservation form page after login
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReservationFormPage()),
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

// Define ReviewPage
class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text("This is the reviews page"),
      ),
    );
  }
}
