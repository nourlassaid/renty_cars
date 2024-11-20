import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'car_management.dart'; // To navigate to the car edit/add page

class CarListPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Voitures'),
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        foregroundColor: const Color.fromARGB(255, 3, 3, 3),
        actions: [
          // Notification Icon in AppBar
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon tap (e.g., navigate to a notifications page)
              print("Notification icon tapped");
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('cars').snapshots(),  // Stream of car data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Aucune voiture disponible"));
          }

          var cars = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              var car = cars[index];

              // Safely access fields from Firestore document
              String imageUrl = car['imageUrl'] ?? 'https://example.com/default_image.jpg';
              String model = car['model'] ?? 'Model not available';
              String location = car['location'] ?? 'Not available';
              String price = car['price'] ?? 'Not available';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                elevation: 5,
                child: ListTile(
                  leading: Image.network(
                    imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(model),
                  subtitle: Text('Location: $location\nPrice: $price'),
                  onTap: () {
                    // Navigate to CarManagement page to edit the car
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarManagement(carIdToEdit: car.id),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Delete the car from Firestore
                      await _firestore.collection('cars').doc(car.id).delete();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Voiture supprimée"),
                      ));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the page to add a new car (with null carId)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarManagement(carIdToEdit: null),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
