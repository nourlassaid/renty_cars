import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReservationsPage extends StatefulWidget {
  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  int selectedTabIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch reservations based on the selected tab index
  Future<List<Map<String, dynamic>>> _fetchReservations() async {
    try {
      String statusFilter = '';
      if (selectedTabIndex == 0) {
        statusFilter = 'Pending';
      } else if (selectedTabIndex == 1) {
        statusFilter = 'Accepted';
      } else if (selectedTabIndex == 2) {
        statusFilter = 'Canceled';
      }

      // Fetching reservations based on the selected tab filter
      QuerySnapshot snapshot = await _firestore
          .collection('reservations')
          .where('status', isEqualTo: statusFilter)
          .get();
      
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
        title: Text('Car Reservations'),
                backgroundColor: const Color.fromARGB(255, 254, 254, 255),

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
                        return ReservationCard(
                          rentalPeriod: reservation['rentalPeriod'] ?? 'Unknown',
                          carModel: reservation['carModel'] ?? 'Unknown',
                          customerName: reservation['customerName'] ?? 'Unknown',
                          passengers: reservation['passengers'] ?? 0,
                          imageUrl: reservation['imageUrl'] ?? '',
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tab Button UI
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
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.car_rental,
                      size: 60,
                      color: Colors.grey,
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
