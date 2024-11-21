import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentycars_nour/admin/requests_page.dart';
import 'package:rentycars_nour/admin/reservations_page.dart';
import 'car_management.dart';  // Assurez-vous d'importer la page de gestion des voitures
import 'profile_page.dart';  // Importez la page du profil de l'admin
import 'home_page.dart'; // RentCarsHomePage should be imported correctly
import 'package:rentycars_nour/admin/home_page.dart';  // Add import for RentCarsHomePage if not already

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  // Pages associées à chaque index de la bottom navigation
  final List<Widget> _pages = [
    RentCarsHomePage(),  // Make sure RentCarsHomePage is the first page
    CarManagement(),
    ReservationsPage(),
    ProfilePage(),
    RequestsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
 File? _imageFile; // Pour stocker l'image sélectionnée

  // Instancier l'image picker
  final picker = ImagePicker();

  // Fonction pour sélectionner l'image
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Galerie ou prendre photo (ImageSource.camera)
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Fonction pour télécharger l'image dans Firebase Storage
  Future<String> _uploadImage() async {
    if (_imageFile == null) return ''; // Pas d'image à télécharger

    // Créer un chemin unique pour l'image dans Firebase Storage
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child('car_images/$fileName');
      UploadTask uploadTask = storageReference.putFile(_imageFile!);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Erreur lors du téléchargement de l'image: $e");
      return '';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: _pages[_selectedIndex], // Display the page based on selected index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'Cars',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Reservations',
          ),
            
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Requests',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // To show more than 3 items without scroll
      ),
    );
  }
}
