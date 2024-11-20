import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rentycars_nour/widgets/car_card.dart';
import '../widgets/app_drawer.dart';
import '../widgets/category_tab.dart';
import 'package:rentycars_nour/screens/car_detail_page.dart';
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
  bool isLoading = true; // State for loading indicator
  bool isLoadingMore = false; // State for loading more cars
  ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> cars = [
    {'imageUrl': 'assets/images/day-exterior-4.png', 'model': 'Toyota Corolla', 'location': 'Tunis Center', 'price': '70DT per day', 'rating': 4.5, 'type': 'Sedan', 'category': 'All'},
    {'imageUrl': 'assets/images/Mercedes-Benz C-Class.jpg', 'model': 'Mercedes-Benz C-Class', 'location': 'Sfax Downtown', 'price': '150DT per day', 'rating': 4.8, 'type': 'Luxury', 'category': 'Luxury'},
    {'imageUrl': 'assets/images/suv_example.jpg', 'model': 'Jeep Wrangler', 'location': 'Djerba Beach', 'price': '90DT per day', 'rating': 4.7, 'type': 'SUV', 'category': 'SUV'},
    {'imageUrl': 'assets/images/toyota_camry.jpg', 'model': 'Toyota Camry', 'location': 'Tunis', 'price': '80DT per day', 'rating': 4.6, 'type': 'Sedan', 'category': 'All'},
    {'imageUrl': 'assets/images/mercedes_benz_s_class.jpg', 'model': 'Mercedes-Benz S-Class', 'location': 'Monastir', 'price': '200DT per day', 'rating': 5.0, 'type': 'Luxury', 'category': 'Luxury'},
    {'imageUrl': 'assets/images/honda_crv.jpg', 'model': 'Honda CR-V', 'location': 'Sousse', 'price': '85DT per day', 'rating': 4.4, 'type': 'SUV', 'category': 'SUV'},
    {'imageUrl': 'assets/images/lexus_rx.jpg', 'model': 'Lexus RX', 'location': 'Tunis', 'price': '120DT per day', 'rating': 4.7, 'type': 'Luxury', 'category': 'Luxury'},
    {'imageUrl': 'assets/images/toyota_rav4.jpg', 'model': 'Toyota RAV4', 'location': 'Nabeul', 'price': '95DT per day', 'rating': 4.6, 'type': 'SUV', 'category': 'SUV'},
    {'imageUrl': 'assets/images/bmw_3_series.jpg', 'model': 'BMW 3 Series', 'location': 'Sfax', 'price': '110DT per day', 'rating': 4.8, 'type': 'Sedan', 'category': 'All'},
    {'imageUrl': 'assets/images/ford_mustang.jpg', 'model': 'Ford Mustang', 'location': 'Hammamet', 'price': '150DT per day', 'rating': 4.9, 'type': 'Luxury', 'category': 'Luxury'},
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

  // Simulate loading more cars (You can replace this with Firebase or API call)
  Future<void> loadMoreCars() async {
    setState(() {
      isLoadingMore = true;
    });

    // Simulate network delay for fetching more data
    await Future.delayed(Duration(seconds: 2), () {
      // Add more cars to the list
      List<Map<String, dynamic>> newCars = [
        {'imageUrl': 'assets/images/suv_example.jpg', 'model': 'Jeep Wrangler', 'location': 'Djerba Beach', 'price': '90DT per day', 'rating': 4.7, 'type': 'SUV', 'category': 'SUV'},
        {'imageUrl': 'assets/images/toyota_camry.jpg', 'model': 'Toyota Camry', 'location': 'Tunis', 'price': '80DT per day', 'rating': 4.6, 'type': 'Sedan', 'category': 'All'},
        {'imageUrl': 'assets/images/mercedes_benz_s_class.jpg', 'model': 'Mercedes-Benz S-Class', 'location': 'Monastir', 'price': '200DT per day', 'rating': 5.0, 'type': 'Luxury', 'category': 'Luxury'},
        {'imageUrl': 'assets/images/honda_crv.jpg', 'model': 'Honda CR-V', 'location': 'Sousse', 'price': '85DT per day', 'rating': 4.4, 'type': 'SUV', 'category': 'SUV'},
        // New set of cars to add
      ];

      setState(() {
        cars.addAll(newCars); // Add new cars to the list
        isLoadingMore = false; // Hide loading indicator after loading new cars
      });
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
  void initState() {
    super.initState();
    // Initial loading
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });

    // Adding scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoadingMore) {
        loadMoreCars(); // Load more cars when reaching the bottom
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            // Show loading indicator if data is loading
            isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading spinner
                : Expanded(
                    child: ListView(
                      controller: _scrollController,
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
            if (isLoadingMore)
              Center(child: CircularProgressIndicator()), // Loading indicator at the bottom
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Requests',
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
            icon: CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage(
                  'assets/images/profile_picture.png'), // Profile picture placeholder
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
