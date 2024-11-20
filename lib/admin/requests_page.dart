import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchReservations() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('reservations').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching reservations: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation History'),
        backgroundColor: const Color.fromARGB(255, 254, 254, 255),
        elevation: 0,
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
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchReservations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading data'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No reservations found'));
            } else {
              List<Map<String, dynamic>> reservations = snapshot.data!;

              return ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  var reservation = reservations[index];
                  return HistoryCard(
                    rentalPeriod: reservation['rentalPeriod'] ?? 'Unknown',
                    carModel: reservation['carModel'] ?? 'Unknown',
                    customerName: reservation['customerName'] ?? 'Unknown',
                    passengers: reservation['passengers'] ?? 0,
                    imageUrl: reservation['imageUrl'] ?? '',
                    status: reservation['status'] ?? 'Pending',
                    completionDate: reservation['completionDate'] ?? 'N/A',
                  );
                },
              );
            }
          },
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
    Color statusColor = status == 'Completed' ? Colors.green : Colors.yellow;

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
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.car_rental,
                      size: 80,
                      color: Colors.grey,
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
                      color: Colors.black87,
                    ),
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
                        color: statusColor,
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
