import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchCarsPage extends StatefulWidget {
  @override
  _SearchCarsPageState createState() => _SearchCarsPageState();
}

class _SearchCarsPageState extends State<SearchCarsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedLocation = '';
  String selectedModel = '';
  List<QueryDocumentSnapshot> availableCars = [];

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();

  Future<void> _fetchCars() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('cars')
          .where('status', isEqualTo: 'available') // Filtrer par disponibilité
          .get();

      List<QueryDocumentSnapshot> cars = snapshot.docs;

      // Filtrer les résultats par localisation et modèle
      availableCars = cars.where((car) {
        var data = car.data() as Map<String, dynamic>;
        bool matchesLocation = selectedLocation.isEmpty ||
            data['location']
                .toString()
                .toLowerCase()
                .contains(selectedLocation.toLowerCase());
        bool matchesModel = selectedModel.isEmpty ||
            data['model']
                .toString()
                .toLowerCase()
                .contains(selectedModel.toLowerCase());
        return matchesLocation && matchesModel;
      }).toList();

      setState(() {});
    } catch (e) {
      print("Error fetching cars: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la récupération des voitures")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche de voitures'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Localisation',
                hintText: 'Entrez la localisation',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  selectedLocation = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _modelController,
              decoration: InputDecoration(
                labelText: 'Modèle',
                hintText: 'Entrez le modèle de la voiture',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  selectedModel = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchCars,
              child: Text('Rechercher'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: availableCars.isEmpty
                  ? Center(
                      child: Text(
                        'Aucune voiture disponible.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: availableCars.length,
                      itemBuilder: (context, index) {
                        var car = availableCars[index];
                        var data = car.data() as Map<String, dynamic>;
                        return Card(
                          elevation: 2.0,
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: ListTile(
                            leading: data['imageUrl'] != null
                                ? Image.network(
                                    data['imageUrl'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.directions_car, size: 50),
                            title: Text(data['model']),
                            subtitle: Text(
                              "Localisation: ${data['location']}\n"
                              "Prix: ${data['pricePerDay']}€/jour",
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              // Détails de la voiture
                              _showCarDetails(data);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCarDetails(Map<String, dynamic> car) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Détails de la voiture'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (car['imageUrl'] != null)
                Image.network(
                  car['imageUrl'],
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 10),
              Text("Modèle: ${car['model']}"),
              Text("Localisation: ${car['location']}"),
              Text("Prix par jour: ${car['pricePerDay']}€"),
              Text("Statut: ${car['status']}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
