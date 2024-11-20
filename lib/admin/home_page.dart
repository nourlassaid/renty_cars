import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rentycars_nour/screens/favorites_page.dart';
import 'package:rentycars_nour/widgets/car_card.dart';
import '../widgets/app_drawer.dart';
import '../widgets/category_tab.dart';
import 'package:rentycars_nour/admin/car_detail_page_admin.dart';
import 'favorites_page.dart';
import 'profile_page.dart'; // Import ProfilePage
import 'package:http/http.dart' as http;

class RentCarsHomePage extends StatefulWidget {
  @override
  _RentCarsHomePageState createState() => _RentCarsHomePageState();
}

class _RentCarsHomePageState extends State<RentCarsHomePage> {
  String selectedCategory = 'All';
  int _selectedIndex = 0;

  // Nouvelle liste de voitures
  final List<Map<String, dynamic>> cars = [
    {
      'imageUrl': 'assets/images/day-exterior-4.png',
      'model': 'Toyota Camry',
      'location': 'Tunis Downtown',
      'price': '100DT per day',
      'rating': 4.3,
      'type': 'Sedan',
      'category': 'All',
    },
    {
      'imageUrl': 'assets/images/Mercedes-Benz C-Class.jpg',
      'model': 'Tesla Model S',
      'location': 'La Marsa',
      'price': '200DT per day',
      'rating': 4.9,
      'type': 'Luxury',
      'category': 'Luxury',
    },
    {
      'imageUrl': 'assets/images/suv_example.jpg',
      'model': 'Ford Escape',
      'location': 'Djerba',
      'price': '120DT per day',
      'rating': 4.5,
      'type': 'SUV',
      'category': 'SUV',
    },
  ];

  // Filtre les voitures en fonction de la catégorie sélectionnée
  List<Map<String, dynamic>> get filteredCars {
    if (selectedCategory == 'All') {
      return cars;
    }
    return cars.where((car) => car['category'] == selectedCategory).toList();
  }

  // Mise à jour de la catégorie sélectionnée
  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  // Fonction de recherche dans Firebase (exemple)
  Future<List<Map<String, dynamic>>> searchCarsFromFirebase(
      String query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('cars')
        .where('model', isGreaterThanOrEqualTo: query)
        .where('model', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Fonction de recherche dans une API externe (exemple)
  Future<List<Map<String, dynamic>>> searchCarsFromAPI(String query) async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List)
          .where((item) =>
              item['title'].toLowerCase().contains(query.toLowerCase()))
          .map((item) => {
                'model': item['title'],
                'description': item['body'],
              })
          .toList();
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  // Mise à jour de l'index du bas de la barre de navigation
  void _onItemTapped(int index) {
    if (index == 3) {
      // Favoris
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FavoritesPage()),
      );
    } else if (index == 4) {
      // Profil
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage()), // Naviguer vers ProfilePage
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              color: Colors.black,
            ),
            children: [
              TextSpan(text: 'Rent', style: TextStyle(color: Colors.black)),
              TextSpan(text: 'Cars', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by car model...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.grey[500]),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 16),
             Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    GestureDetector(
      onTap: () => updateCategory('All'),
      child: CategoryTab(
        label: 'All',
        icon: FontAwesomeIcons.car,
        isSelected: selectedCategory == 'All',
        onTap: () => updateCategory('All'), // Add this
      ),
    ),
    GestureDetector(
      onTap: () => updateCategory('SUV'),
      child: CategoryTab(
        label: 'SUV',
        icon: FontAwesomeIcons.truckMonster,
        isSelected: selectedCategory == 'SUV',
        onTap: () => updateCategory('SUV'), // Add this
      ),
    ),
    GestureDetector(
      onTap: () => updateCategory('Luxury'),
      child: CategoryTab(
        label: 'Luxury',
        icon: FontAwesomeIcons.gem,
        isSelected: selectedCategory == 'Luxury',
        onTap: () => updateCategory('Luxury'), // Add this
      ),
    ),
  ],
),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: filteredCars.map((car) {
                  return CarCard(
                    imageUrl: car['imageUrl'],
                    model: car['model'],
                    location: car['location'],
                    price: car['price'],
                    rating: car['rating'],
                    type: car['type'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailPage(
                            imageUrl: car['imageUrl'],
                            model: car['model'],
                            location: car['location'],
                            price: car['price'],
                            rating: car['rating'],
                            type: car['type'],
                          ),
                        ),
                      );
                    },
                    onFavoriteTap: () {
                      FirebaseFirestore.instance.collection('favorites').add({
                        'imageUrl': car['imageUrl'],
                        'model': car['model'],
                        'location': car['location'],
                        'price': car['price'],
                        'rating': car['rating'],
                        'type': car['type'],
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
