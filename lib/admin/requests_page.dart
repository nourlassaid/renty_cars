import 'package:flutter/material.dart';

class RequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation History'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Section Title
            Text(
              'Completed Reservations',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),

            // List of historical requests
            Expanded(
              child: ListView(
                children: [
                  HistoryCard(
                    rentalPeriod: '2023/11/01 - 2023/11/07',
                    carModel: 'Tesla Model S',
                    customerName: 'Sarah Connor',
                    passengers: 3,
                    imageUrl:
                        'https://example.com/tesla_model_s.jpg', // Replace with actual image URL
                    status: 'Completed',
                    completionDate: '2023/11/07',
                  ),
                  HistoryCard(
                    rentalPeriod: '2023/10/15 - 2023/10/22',
                    carModel: 'Audi A6',
                    customerName: 'Peter Parker',
                    passengers: 4,
                    imageUrl:
                        'https://example.com/audi_a6.jpg', // Replace with actual image URL
                    status: 'Completed',
                    completionDate: '2023/10/22',
                  ),
                  // Add more completed reservations here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String rentalPeriod;
  final String carModel;
  final String customerName;
  final int passengers;
  final String imageUrl;
  final String status;
  final String completionDate;

  HistoryCard({
    required this.rentalPeriod,
    required this.carModel,
    required this.customerName,
    required this.passengers,
    required this.imageUrl,
    required this.status,
    required this.completionDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),

            // Reservation details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carModel,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  SizedBox(height: 4),
                  Text(
                    rentalPeriod,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Customer: $customerName',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$passengers passenger(s)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Completed on $completionDate',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
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