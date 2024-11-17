import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/app_drawer.dart';
import '../widgets/category_tab.dart';
import '../widgets/car_card.dart';
import 'car_detail_page.dart';
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

  final List<Map<String, dynamic>> cars = [
    {
      'imageUrl': 'assets/images/day-exterior-4.png',
      'model': 'Toyota Corolla',
      'location': 'Tunis Center',
      'price': '70DT per day',
      'rating': 4.5,
      'type': 'Sedan',
      'category': 'All',
    },
    {
      'imageUrl': 'assets/images/Mercedes-Benz C-Class.jpg',
      'model': 'Mercedes-Benz C-Class',
      'location': 'Sfax Downtown',
      'price': '150DT per day',
      'rating': 4.8,
      'type': 'Luxury',
      'category': 'Luxury',
    },
    {
      'imageUrl': 'assets/images/suv_example.jpg',
      'model': 'Jeep Wrangler',
      'location': 'Djerba Beach',
      'price': '90DT per day',
      'rating': 4.7,
      'type': 'SUV',
      'category': 'SUV',
    },
  ];

  List<Map<String, dynamic>> get filteredCars {
    if (selectedCategory == 'All') {
      return cars;
    }
    return cars.where((car) => car['category'] == selectedCategory).toList();
  }

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  // Firebase search function (example)
  Future<List<Map<String, dynamic>>> searchCarsFromFirebase(String query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('cars')
        .where('model', isGreaterThanOrEqualTo: query)
        .where('model', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // External API search function (example API placeholder)
  Future<List<Map<String, dynamic>>> searchCarsFromAPI(String query) async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List)
          .where((item) => item['title'].toLowerCase().contains(query.toLowerCase()))
          .map((item) => {
                'model': item['title'],
                'description': item['body'],
              })
          .toList();
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  // Update the onItemTapped function to navigate to ProfilePage
  void _onItemTapped(int index) {
    if (index == 3) {  // Favorites
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FavoritesPage()),
      );
    } else if (index == 4) {  // Profile
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()), // Navigate to ProfilePage
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
        fontSize: 24, // Définir la taille de la police ici
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto', // Définir la famille de la police ici
        color: Colors.black, // Couleur du texte
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
            onPressed: () {
              // Handle notifications icon tap here
            },
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
                  onPressed: () {
                    // Handle filter action here
                  },
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
                  ),
                ),
                GestureDetector(
                  onTap: () => updateCategory('SUV'),
                  child: CategoryTab(
                    label: 'SUV',
                    icon: FontAwesomeIcons.truckMonster,
                    isSelected: selectedCategory == 'SUV',
                  ),
                ),
                GestureDetector(
                  onTap: () => updateCategory('Luxury'),
                  child: CategoryTab(
                    label: 'Luxury',
                    icon: FontAwesomeIcons.gem,
                    isSelected: selectedCategory == 'Luxury',
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${car['model']} added to favorites.')),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Swap',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile', // Profile item in BottomNavigationBar
          ),
        ],
      ),
    );
  }
}
