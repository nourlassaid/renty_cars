import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditCarPage extends StatefulWidget {
  final String carId;  // ID de la voiture à éditer

  EditCarPage({required this.carId});

  @override
  _EditCarPageState createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController modelController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController agencyController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  String? imageUrl;

  @override
  void initState() {
    super.initState();
    // Charger les données de la voiture depuis Firestore
    firestore.collection('cars').doc(widget.carId).get().then((snapshot) {
      var carData = snapshot.data();
      modelController.text = carData?['model'] ?? '';
      priceController.text = carData?['price'] ?? '';
      agencyController.text = carData?['agency'] ?? '';
      descriptionController.text = carData?['description'] ?? '';
      availabilityController.text = carData?['availability'] ?? '';
      imageUrl = carData?['imageUrl'];  // Récupérer l'URL de l'image
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      // Téléchargement de l'image et obtention de l'URL
      Reference storageRef = FirebaseStorage.instance.ref().child('car_images/${widget.carId}.jpg');
      await storageRef.putFile(File(imageFile.path));
      String downloadUrl = await storageRef.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;  // Mettre à jour l'URL de l'image
      });
    }
  }

  void updateCar() {
    final String model = modelController.text;
    final String price = priceController.text;
    final String agency = agencyController.text;
    final String description = descriptionController.text;
    final String availability = availabilityController.text;

    if (model.isEmpty || price.isEmpty || agency.isEmpty || description.isEmpty || availability.isEmpty || imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Veuillez remplir tous les champs.")));
      return;
    }

    firestore.collection('cars').doc(widget.carId).update({
      'model': model,
      'price': price,
      'agency': agency,
      'description': description,
      'availability': availability,
      'imageUrl': imageUrl,  // Mettre à jour l'URL de l'image
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Voiture mise à jour avec succès")));
      Navigator.pop(context);  // Retour à la page précédente après l'édition
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur lors de la mise à jour de la voiture : $e")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier la voiture"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: modelController,
                decoration: InputDecoration(labelText: "Modèle de la voiture"),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Prix par jour"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: agencyController,
                decoration: InputDecoration(labelText: "Nom de l'agence"),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: availabilityController,
                decoration: InputDecoration(labelText: "Disponibilité"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              imageUrl == null
                  ? ElevatedButton(
                      onPressed: pickImage,
                      child: Text("Choisir une image"),
                    )
                  : Image.network(
                      imageUrl!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateCar,
                child: Text("Mettre à jour la voiture"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
