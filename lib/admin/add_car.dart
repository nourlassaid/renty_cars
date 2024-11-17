import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Fonction pour ajouter la voiture
  void _addCar() async {
    if (_formKey.currentState!.validate()) {
      try {
        String imageUrl = _imageUrlController.text;

        // Vérification de l'URL de l'image
        if (imageUrl.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez entrer une URL valide pour l\'image.')));
          return;
        }

        // Ajout des données de la voiture dans Firestore
        FirebaseFirestore.instance.collection('cars').add({
          'model': _modelController.text,
          'brand': _brandController.text,
          'price': double.parse(_priceController.text),
          'type': _typeController.text,
          'color': _colorController.text,
          'availability': _isAvailable,
          'imageUrl': imageUrl, // URL de l'image
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Voiture ajoutée avec succès')));
          Navigator.pop(context); // Fermer la page d'ajout
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout: $error')));
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
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
                  // Champ de l'URL de l'image
                  _buildTextFormField(
                    controller: _imageUrlController,
                    labelText: 'URL de l\'image',
                    icon: Icons.image,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une URL de l\'image';
                      }
                      Uri? uri = Uri.tryParse(value);
                      if (uri == null || !uri.isAbsolute) {
                        return 'Veuillez entrer une URL valide';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  // Champ de modèle
                  _buildTextFormField(
                    controller: _modelController,
                    labelText: 'Modèle',
                    icon: Icons.directions_car,
                    validator: (value) => value!.isEmpty ? 'Veuillez entrer le modèle' : null,
                  ),
                  // Champ de marque
                  _buildTextFormField(
                    controller: _brandController,
                    labelText: 'Marque',
                    icon: Icons.branding_watermark,
                    validator: (value) => value!.isEmpty ? 'Veuillez entrer la marque' : null,
                  ),
                  // Champ de prix
                  _buildTextFormField(
                    controller: _priceController,
                    labelText: 'Prix par jour',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Veuillez entrer le prix' : null,
                  ),
                  // Champ de type de voiture
                  _buildTextFormField(
                    controller: _typeController,
                    labelText: 'Type de voiture',
                    icon: Icons.car_repair,
                    validator: (value) => value!.isEmpty ? 'Veuillez entrer le type de voiture' : null,
                  ),
                  // Champ de couleur
                  _buildTextFormField(
                    controller: _colorController,
                    labelText: 'Couleur',
                    icon: Icons.color_lens,
                    validator: (value) => value!.isEmpty ? 'Veuillez entrer la couleur' : null,
                  ),
                  // Disponibilité de la voiture
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
                  // Bouton d'ajout centré et stylisé
                  Center(
                    child: ElevatedButton(
                      onPressed: _addCar,
                      child: Text('Ajouter', style: TextStyle(fontSize: 18, color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 30.30),
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

  // Fonction de construction du champ de texte
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
        labelStyle: TextStyle(color: Colors.black), // Text couleur noire
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
