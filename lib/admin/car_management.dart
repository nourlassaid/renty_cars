import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentycars_nour/admin/cars_list_page.dart';

class CarManagement extends StatefulWidget {
  final String? carIdToEdit; // ID of the car to edit, null if adding a new car

  CarManagement({this.carIdToEdit});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<CarManagement> {
  TextEditingController modelController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isEditing = false;
  String? carIdToEdit;

  @override
  void initState() {
    super.initState();

    if (widget.carIdToEdit != null) {
      isEditing = true;
      carIdToEdit = widget.carIdToEdit;
      _loadCarData(carIdToEdit!);
    }
  }

  Future<void> _loadCarData(String carId) async {
    try {
      DocumentSnapshot carDoc = await _firestore.collection('cars').doc(carId).get();
      setState(() {
        modelController.text = carDoc['model'];
        locationController.text = carDoc['location'];
        priceController.text = carDoc['price'];
        ratingController.text = carDoc['rating'].toString();
        typeController.text = carDoc['type'];
        categoryController.text = carDoc['category'];
        imageUrlController.text = carDoc['imageUrl'];
      });
    } catch (e) {
      print("Erreur lors du chargement des données de la voiture : $e");
    }
  }

  Future<void> _addOrUpdateCar() async {
    final model = modelController.text;
    final location = locationController.text;
    final price = priceController.text;
    final rating = double.tryParse(ratingController.text) ?? 0.0;
    final type = typeController.text;
    final category = categoryController.text;
    final imageUrl = imageUrlController.text;

    if (model.isEmpty || location.isEmpty || price.isEmpty || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Veuillez remplir tous les champs"),
      ));
      return;
    }

    try {
      if (isEditing && carIdToEdit != null) {
        // Mise à jour de la voiture
        await _firestore.collection('cars').doc(carIdToEdit).update({
          'model': model,
          'location': location,
          'price': price,
          'rating': rating,
          'type': type,
          'category': category,
          'imageUrl': imageUrl,
        });
      } else {
        // Ajout de la voiture
        await _firestore.collection('cars').add({
          'model': model,
          'location': location,
          'price': price,
          'rating': rating,
          'type': type,
          'category': category,
          'imageUrl': imageUrl,
        });
      }

      // Réinitialiser les champs après ajout ou mise à jour
      setState(() {
        modelController.clear();
        locationController.clear();
        priceController.clear();
        ratingController.clear();
        typeController.clear();
        categoryController.clear();
        imageUrlController.clear();
        isEditing = false;
        carIdToEdit = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isEditing ? "Voiture mise à jour !" : "Voiture ajoutée !"),
      ));
    } catch (e) {
      print("Erreur lors de l'ajout de la voiture : $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erreur lors de l'ajout/modification de la voiture"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier une Voiture' : 'Ajouter une Voiture'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.blueAccent,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildHeading('Informations sur la voiture'),
            SizedBox(height: 12),
            _buildTextField(modelController, 'Modèle'),
            _buildTextField(locationController, 'Emplacement'),
            _buildTextField(priceController, 'Prix par jour', isNumber: true),
            _buildTextField(ratingController, 'Note (de 0 à 5)', isNumber: true),
            _buildTextField(typeController, 'Type (ex: SUV, Sedan)'),
            _buildTextField(categoryController, 'Catégorie (ex: Luxe)'),
            _buildTextField(imageUrlController, 'URL de l\'image'),
            SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _addOrUpdateCar,
                    icon: Icon(isEditing ? Icons.update : Icons.add),
                    label: Text(isEditing ? 'Mettre à jour' : 'Ajouter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to CarListPage after adding or updating the car
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CarListPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    child: Text('Retour à la liste des voitures'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  Widget _buildHeading(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
