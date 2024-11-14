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
        title: Text('Car Reservations', style: TextStyle(color: Colors.black)),
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
          _buildReservationList(), // For "Pending" reservations
          _buildReservationList(), // For "Accepted" reservations
          _buildReservationList(), // For "Canceled" reservations
        ],
      ),
    );
  }

  Widget _buildReservationList() {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        _buildReservationItem(
          dateRange: '2024/08/01 - 2024/08/08',
          carModel: 'Toyota Corolla',
          location: 'Tunis Center',
          clientName: 'nour lassaid',
          price: '70DT per day',
          imageUrl: 'assets/images/day-exterior-4.png', // Replace with actual car image
        ),
        _buildReservationItem(
          dateRange: '2024/09/01 - 2024/09/15',
          carModel: 'Mercedes-Benz C-Class',
          location: 'Sfax Downtown',
          clientName: 'nour lassaid',
          price: '150DT per day',
          imageUrl: 'assets/images/Mercedes-Benz C-Class.jpg', // Replace with actual car image
        ),
        // Add more car reservations as needed
      ],
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
