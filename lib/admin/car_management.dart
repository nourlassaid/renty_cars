import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des voitures"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cars').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final cars = snapshot.data!.docs;
          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return ListTile(
                title: Text(car['model']),
                subtitle: Text(car['brand']),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      // Modifier la voiture
                    } else if (value == 'delete') {
                      FirebaseFirestore.instance.collection('cars').doc(car.id).delete();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text("Modifier"),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text("Supprimer"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_car');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
