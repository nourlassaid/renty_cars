import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCarPage extends StatefulWidget {
  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _formKey = GlobalKey<FormState>();
  String? model, location, price, category, imageUrl;

  void _saveCar() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FirebaseFirestore.instance.collection('cars').add({
        'model': model,
        'location': location,
        'price': price,
        'category': category,
        'imageUrl': imageUrl,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Voiture ajoutée avec succès.")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une Voiture"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Modèle"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer le modèle";
                  }
                  return null;
                },
                onSaved: (value) => model = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Lieu"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer le lieu";
                  }
                  return null;
                },
                onSaved: (value) => location = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Prix"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer le prix";
                  }
                  return null;
                },
                onSaved: (value) => price = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Catégorie"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer la catégorie";
                  }
                  return null;
                },
                onSaved: (value) => category = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "URL de l'image"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer l'URL de l'image";
                  }
                  return null;
                },
                onSaved: (value) => imageUrl = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCar,
                child: Text("Ajouter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
