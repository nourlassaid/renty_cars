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
  bool isFavorite = false;  // Etat du favori (ajouté ou non)

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();  // Vérifie si la voiture est déjà marquée comme favorite
  }

  // Vérifie si la voiture est déjà dans les favoris de l'utilisateur
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
          isFavorite = true;  // La voiture est déjà dans les favoris
        });
      }
    }
  }

  // Fonction pour ajouter ou supprimer un favori
  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final carRef = FirebaseFirestore.instance
          .collection('favorites')
          .doc(user.uid)
          .collection('cars')
          .doc(widget.model);

      if (isFavorite) {
        await carRef.delete();  // Supprime du favori
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
        isFavorite = !isFavorite;  // Met à jour l'état du favori
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),  // Redirige vers la page de connexion
      );
    }
  }

  // Fonction pour envoyer un message
  Future<void> _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final receiverId = 'ownerId'; // Remplacez par l'ID réel du propriétaire
      await FirebaseFirestore.instance.collection('messages').add({
        'senderId': user.uid,
        'receiverId': receiverId,
        'message': 'Hello, I am interested in this car!',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Affichage de la boîte de dialogue de confirmation
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Message Sent'),
            content: Text('Votre message a été envoyé au propriétaire du véhicule.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);  // Fermer la boîte de dialogue
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),  // Redirige vers la page de connexion
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        widget.imageUrl,
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
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border, 
                            color: Colors.red
                          ),
                          onPressed: _toggleFavorite,  // Appel à la fonction pour ajouter ou supprimer des favoris
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
                        widget.model,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.location,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(
                            widget.rating.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
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
                              Text("Nour Lassaid", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text("NEW", style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.chat, color: Colors.blue),
                            onPressed: _sendMessage,  // Envoie un message
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
                    '${widget.price} per day',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReservationFormPage()),
                      );
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
