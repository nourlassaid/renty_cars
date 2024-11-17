import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCarPage extends StatefulWidget {
  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _formKey = GlobalKey<FormState>();
  final _modelController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _typeController = TextEditingController();
  final _colorController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isAvailable = true;

  // List to store image URLs
  List<String> _imageUrls = [];

  // Function to fetch images from JSONPlaceholder API
  Future<void> _fetchImages() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        setState(() {
          _imageUrls = data.map((item) => item['url'] as String).toList();
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur de chargement des images')));
    }
  }

  // Function to add the car data
  void _addCar() async {
    if (_formKey.currentState!.validate()) {
      try {
        String imageUrl = _imageUrlController.text;

        if (imageUrl.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez entrer une URL valide pour l\'image.')));
          return;
        }

        // Add car data to Firestore
        FirebaseFirestore.instance.collection('cars').add({
          'model': _modelController.text,
          'brand': _brandController.text,
          'price': double.parse(_priceController.text),
          'type': _typeController.text,
          'color': _colorController.text,
          'availability': _isAvailable,
          'imageUrl': imageUrl,
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Voiture ajoutée avec succès')));
          Navigator.pop(context);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout: $error')));
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchImages(); // Fetch images on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une voiture"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image selection from the fetched URLs
                  _buildDropdownField(),
                  SizedBox(height: 10),
                  // Model input
                  _buildTextFormField(
                    controller: _modelController,
                    labelText: 'Modèle',
                    icon: Icons.directions_car,
                    validator: (value) => value!.isEmpty ? 'Veuillez entrer le modèle' : null,
                  ),
                  // Brand input
                  _buildTextFormField(
                    controller: _brandController,
                    labelText: 'Marque',
                    icon: Icons.branding_watermark,
                    validator: (value) => value!.isEmpty ? 'Veuillez entrer la marque' : null,
                  ),
                  // Price input
                  _buildTextFormField(
                    controller: _priceController,
                    labelText: 'Prix par jour',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Veuillez entrer le prix' : null,
                  ),
                  // Type of car input
                  _buildTextFormField(
                    controller: _typeController,
                    labelText: 'Type de voiture',
                    icon: Icons.car_repair,
                    validator: (value) => value!.isEmpty ? 'Veuillez entrer le type de voiture' : null,
                  ),
                  // Color input
                  _buildTextFormField(
                    controller: _colorController,
                    labelText: 'Couleur',
                    icon: Icons.color_lens,
                    validator: (value) => value!.isEmpty ? 'Veuillez entrer la couleur' : null,
                  ),
                  // Availability checkbox
                  Row(
                    children: [
                      Text('Disponible:', style: TextStyle(fontSize: 16, color: Colors.black)),
                      Checkbox(
                        value: _isAvailable,
                        onChanged: (bool? value) {
                          setState(() {
                            _isAvailable = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Add button
                  Center(
                    child: ElevatedButton(
                      onPressed: _addCar,
                      child: Text('Ajouter', style: TextStyle(fontSize: 18, color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Dropdown to select image URL
  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _imageUrls.isNotEmpty ? _imageUrls[0] : null,
      decoration: InputDecoration(
        labelText: 'Choisir une image',
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(Icons.image, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
      onChanged: (String? newValue) {
        setState(() {
          _imageUrlController.text = newValue!;
        });
      },
      items: _imageUrls.map((String url) {
        return DropdownMenuItem<String>(
          value: url,
          child: Text('Image URL'),
        );
      }).toList(),
    );
  }

  // Function to create the text form fields
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
