import 'package:flutter/material.dart';

class ReservationsPage extends StatefulWidget {
  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Reservations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tab selection for reservation status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton('Pending', 0),
                _buildTabButton('Accepted', 1),
                _buildTabButton('Canceled', 2),
              ],
            ),
            SizedBox(height: 16),

            // Reservations list
            Expanded(
              child: ListView(
                children: [
                  ReservationCard(
                    rentalPeriod: '2024/11/01 - 2024/11/08',
                    carModel: 'BMW X5',
                    customerName: 'John Doe',
                    passengers: 5,
                    imageUrl:
                        'https://example.com/bmw_x5.jpg', // Replace with a valid car image URL
                  ),
                  ReservationCard(
                    rentalPeriod: '2024/12/01 - 2024/12/07',
                    carModel: 'Mercedes GLA',
                    customerName: 'Jane Smith',
                    passengers: 4,
                    imageUrl:
                        'https://example.com/mercedes_gla.jpg', // Replace with a valid car image URL
                  ),
                  // Add more reservations here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    bool isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTabIndex = index;
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? Colors.orange : Colors.grey[200],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ReservationCard extends StatelessWidget {
  final String rentalPeriod;
  final String carModel;
  final String customerName;
  final int passengers;
  final String imageUrl;

  ReservationCard({
    required this.rentalPeriod,
    required this.carModel,
    required this.customerName,
    required this.passengers,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12),

            // Car rental details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rentalPeriod,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    carModel,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '👤 Customer: $customerName',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Text(
                    '$passengers passenger(s)',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}