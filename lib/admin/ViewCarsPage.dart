import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewCarsPage extends StatefulWidget {
  @override
  _ViewCarsPageState createState() => _ViewCarsPageState();
}

class _ViewCarsPageState extends State<ViewCarsPage> {
  // Variable pour stocker les images récupérées depuis JSONPlaceholder
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();  // Appel de la fonction pour récupérer les images
  }

  // Fonction pour récupérer les images depuis l'API JSONPlaceholder
  Future<void> _fetchImages() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _imageUrls = data.map((photo) => photo['url'] as String).toList();
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  // Fonction pour récupérer les données des voitures depuis Firestore
  Stream<QuerySnapshot> _getCars() {
    return FirebaseFirestore.instance.collection('cars').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voir les voitures"),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucune voiture trouvée.'));
          }

          final cars = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              var car = cars[index];
              var imageUrl = car['imageUrl'] ?? '';

              // Récupérer une image depuis l'API pour l'affichage
              String apiImageUrl = _imageUrls.isNotEmpty ? _imageUrls[index % _imageUrls.length] : '';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: imageUrl.isNotEmpty || apiImageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl.isNotEmpty ? imageUrl : apiImageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red),
                        )
                      : Image.asset(
                          'assets/default_image.png', // Image par défaut en cas d'erreur
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                  title: Text(car['model'] ?? 'Modèle inconnu'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Marque: ${car['brand']}'),
                      Text('Prix: ${car['price']}'),
                      Text('Type: ${car['type']}'),
                      Text('Couleur: ${car['color']}'),
                      Text('Disponibilité: ${car['availability'] ? 'Disponible' : 'Indisponible'}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Ajouter une fonctionnalité pour supprimer la voiture
                      FirebaseFirestore.instance
                          .collection('cars')
                          .doc(car.id)
                          .delete()
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Voiture supprimée avec succès'),
                        ));
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Erreur lors de la suppression de la voiture: $error'),
                        ));
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
