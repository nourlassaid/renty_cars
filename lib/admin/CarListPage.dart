import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'car_management.dart'; // Importez le formulaire de gestion des voitures

class CarListPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fonction pour supprimer une voiture de Firestore
  Future<void> _deleteCar(BuildContext context, String carId) async {
    try {
      await _firestore.collection('cars').doc(carId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Voiture supprimée"),
      ));
    } catch (e) {
      print("Erreur lors de la suppression : $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erreur lors de la suppression de la voiture"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Voitures'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Naviguer vers le formulaire de gestion des voitures pour ajouter une voiture
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarManagement(carIdToEdit: null)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('cars').snapshots(),  // Flux de voitures depuis Firestore
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("Aucune voiture disponible"));
            }

            final cars = snapshot.data!.docs;

            return ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return _buildCarCard(context, car);
              },
            );
          },
        ),
      ),
    );
  }

  // Fonction pour construire chaque carte de voiture dans la liste
  Widget _buildCarCard(BuildContext context, DocumentSnapshot car) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 5,
      child: ListTile(
        leading: Image.network(
          car['imageUrl'],
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(car['model']),
        subtitle: Text(car['location']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouton pour éditer la voiture
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () {
                // Naviguer vers le formulaire de gestion pour modifier la voiture
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarManagement(carIdToEdit: car.id),
                  ),
                );
              },
            ),
            // Bouton pour supprimer la voiture
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteCar(context, car.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
