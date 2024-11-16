import 'package:flutter/material.dart';
import '../screens/LoginPage.dart';
import '../screens/ReservationFormPage.dart';  // Importation de la page ReservationFormPage
import '../screens/ReviewPage.dart';  // Importation de la page des avis

class CarDetailPage extends StatelessWidget {
  final String imageUrl;
  final String model;
  final String location;
  final String price;
  final double rating;
  final String type;

  // Simuler l'état de connexion de l'utilisateur
  final bool isLoggedIn = false; // Mettez à jour avec l'état réel de l'authentification

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
                // Image de la voiture avec l'icône des favoris
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
                            // Logique pour ajouter aux favoris
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
                          Icon(Icons.star, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Naviguer vers la page des avis
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ReviewPage(postId: '',)),
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
                        // Naviguer vers la page de connexion si l'utilisateur n'est pas connecté
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReservationFormPage()),
                        );
                      } else {
                        // Naviguer vers la page de réservation après la connexion
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
