import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/agency_model.dart';

class AdminGestionAgencePage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addAgency(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ajouter une agence"),
        content: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nom de l'agence"),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: "Emplacement"),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Téléphone"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              firestore.collection('agencies').add({
                'name': nameController.text,
                'location': locationController.text,
                'phone': phoneController.text,
                'email': emailController.text,
                'carsAvailable': 0, 
                'rating': 0.0, 
              });
              Navigator.pop(context);
            },
            child: Text("Ajouter"),
          ),
        ],
      ),
    );
  }

  void deleteAgency(String agencyId) {
    firestore.collection('agencies').doc(agencyId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des Agences"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => addAgency(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('agencies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Aucune agence trouvée."));
          }

          final agencies = snapshot.data!.docs.map((doc) {
            return Agency.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: agencies.length,
            itemBuilder: (context, index) {
              final agency = agencies[index];
              return ListTile(
                title: Text(agency.name),
                subtitle: Text(agency.location),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteAgency(agency.id);
                  },
                ),
                onTap: () {
                  // Ajouter un comportement pour éditer l'agence ici, si nécessaire
                },
              );
            },
          );
        },
      ),
    );
  }
}
