import 'dart:async';
import 'package:flutter/material.dart';

class CarDetailPage extends StatefulWidget {
  final String imageUrl;
  final String model;
  final String location;
  final String price;
  final double rating;
  final String type;

  const CarDetailPage({
    Key? key,
    required this.imageUrl,
    required this.model,
    required this.location,
    required this.price,
    required this.rating,
    required this.type,
  }) : super(key: key);

  @override
  _CarDetailPageState createState() => _CarDetailPageState();
}

class _CarDetailPageState extends State<CarDetailPage> {
  PageController _pageController = PageController();
  Timer? _carouselTimer;

  final List<String> fallbackImages = [
    'assets/images/car_default.jpg',
    'assets/images/toyota.jpg', // Placeholder image
    'assets/car2.jpg'
  ];

  final List<Map<String, dynamic>> specifications = [
    {
      "icon": Icons.speed,
      "value": "200 km/h",
      "description": "Top speed of 200 km/h."
    },
    {
      "icon": Icons.local_gas_station,
      "value": "Petrol",
      "description": "Uses petrol for fuel."
    },
    {
      "icon": Icons.people,
      "value": "4 Seats",
      "description": "Comfortable seating for up to 4 people."
    },
    {
      "icon": Icons.ac_unit,
      "value": "Automatic AC",
      "description": "Equipped with automatic air conditioning."
    },
    {
      "icon": Icons.bolt,
      "value": "Electric Option",
      "description": "Available with an electric option for efficiency."
    },
  ];

  final List<String> colors = ['Red', 'Blue', 'Black', 'White'];

  @override
  void initState() {
    super.initState();
    _startCarousel();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startCarousel() {
    _carouselTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        _pageController.animateToPage(
          nextPage % fallbackImages.length,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  String getCarDescription() {
    switch (widget.type) {
      case "SUV":
        return "This SUV offers exceptional comfort and power, making it perfect for long journeys or family trips.";
      case "Sedan":
        return "This Sedan is the epitome of elegance and performance, ideal for city rides and business purposes.";
      case "Electric":
        return "This Electric car is environmentally friendly with cutting-edge technology and impressive efficiency.";
      default:
        return "This vehicle is a great choice for any occasion, offering reliability, style, and excellent performance.";
    }
  }

  void _showSpecificationDescription(String description) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full screen for bottom sheet
      backgroundColor:
          Colors.transparent, // Transparent background to show design
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            height: 300, // Larger height for a more spacious bottom sheet
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Specification Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  description,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      widget.imageUrl,
      ...fallbackImages,
    ];

    final String description = getCarDescription();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar with Image Background (no favorite icon)
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.model,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.location,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 8),
                      // Description
                      Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 8),
                      // Available Colors
                      Text(
                        "Available Colors",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: colors.map((color) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: color == 'Red'
                                  ? Colors.red
                                  : color == 'Blue'
                                      ? Colors.blue
                                      : color == 'Black'
                                          ? Colors.black
                                          : Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 8),
                      // Specifications
                      Text(
                        "Specifications",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: specifications.length,
                          itemBuilder: (context, index) {
                            final spec = specifications[index];
                            return GestureDetector(
                              onTap: () => _showSpecificationDescription(
                                  spec["description"]),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      spec["icon"],
                                      color: Colors.blue,
                                      size: 40,
                                    ),
                                    SizedBox(height: 4),
                                    Text(spec["value"]),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.price} per day',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
