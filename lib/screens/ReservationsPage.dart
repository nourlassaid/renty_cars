import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReservationsPage extends StatefulWidget {
  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Car Reservations',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
            Tab(text: 'Canceled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReservationsList('Pending'), // Tab for "Pending" reservations
          _buildReservationsList('Accepted'), // Tab for "Accepted" reservations
          _buildReservationsList('Canceled'), // Tab for "Canceled" reservations
        ],
      ),
    );
  }

  Widget _buildReservationsList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reservations')
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No $status reservations found.'));
        }

        final reservations = snapshot.data!.docs;

        return ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index].data() as Map<String, dynamic>;
            return _buildReservationItem(
              dateRange: reservation['reservationDate'] ?? 'Unknown Date',
              carModel: reservation['carModel'] ?? 'Unknown Model',
              location: reservation['location'] ?? 'Unknown Location',
              clientName: reservation['userName'] ?? 'Unknown Client',
              price: reservation['price'] ?? 'Unknown Price',
              imageUrl: reservation['imageUrl'] ?? 'assets/images/default_car.png', // Fallback image
            );
          },
        );
      },
    );
  }

  Widget _buildReservationItem({
    required String dateRange,
    required String carModel,
    required String location,
    required String clientName,
    required String price,
    required String imageUrl,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Image.asset(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateRange, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(carModel, style: TextStyle(fontSize: 16)),
                  Text('Location: $location', style: TextStyle(color: Colors.grey)),
                  Text('Client: $clientName', style: TextStyle(color: Colors.grey)),
                  Text(price, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
