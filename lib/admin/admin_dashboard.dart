import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // AppBar bleu
        title: Text("Tableau de bord Admin"),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Action pour les notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Action pour les paramètres
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Section Statistiques
              Card(
                elevation: 5,
                margin: EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Coins arrondis
                ),
                color: Colors.white, // Fond blanc
                child: ListTile(
                  leading: Icon(Icons.analytics, color: Colors.blue),
                  title: Text(
                    "Statistiques",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Titre bleu
                    ),
                  ),
                  subtitle: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('stats').doc('dashboard').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Text("Aucune donnée disponible");
                      }

                      final data = snapshot.data!;
                      final totalCars = data['totalCars'] ?? 0;
                      final ongoingRentals = data['ongoingRentals'] ?? 0;
                      final totalRevenue = data['totalRevenue'] ?? 0.0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Voitures disponibles: $totalCars"),
                          Text("Locations en cours: $ongoingRentals"),
                          Text("Revenus générés: \$${totalRevenue.toStringAsFixed(2)}"),
                        ],
                      );
                    },
                  ),
                ),
              ),
              
              // Section Gestion des Voitures
              Card(
                elevation: 5,
                margin: EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Coins arrondis
                ),
                color: Colors.white, // Fond blanc
                child: ListTile(
                  leading: Icon(Icons.car_repair, color: Colors.blue),
                  title: Text(
                    "Gestion des Voitures",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Bouton bleu
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Coins arrondis
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/add_car');
                        },
                        child: Text("Ajouter une Voiture", style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(height: 10), // Espacement vertical entre les boutons
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue, // Bouton bleu clair
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/view_cars');
                        },
                        child: Text("Voir les Voitures", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),

              // Section Gestion des Utilisateurs
              Card(
                elevation: 5,
                margin: EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white, 
                child: ListTile(
                  leading: Icon(Icons.supervisor_account, color: Colors.blue),
                  title: Text("Gestion des Utilisateurs", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Bouton bleu
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/admin_user_management');
                        },
                        child: Text("Voir les Utilisateurs", style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(height: 10), // Espacement vertical
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent, // Bouton bleu foncé
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/block_user');
                        },
                        child: Text("Bloquer un Utilisateur", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),

              // Section Gestion des Réservations
              Card(
                elevation: 5,
                margin: EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white, 
                child: ListTile(
                  leading: Icon(Icons.book_online, color: Colors.blue),
                  title: Text("Gestion des Réservations", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Bouton bleu
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/admin_reservation_management');
                        },
                        child: Text("Voir les Réservations", style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(height: 10), // Espacement vertical
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent, // Nouveau bleu clair
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/modify_reservation');
                        },
                        child: Text("Modifier une Réservation", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
