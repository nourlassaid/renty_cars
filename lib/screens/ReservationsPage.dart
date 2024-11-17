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

  // Function to update the status of a reservation
  Future<void> _updateReservationStatus(String reservationId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('reservations').doc(reservationId).update({
        'status': newStatus,
      });
      print('Reservation status updated to $newStatus');
    } catch (e) {
      print('Failed to update reservation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Réservations de Voitures',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.orange,
          tabs: [
            Tab(text: 'En attente'),
            Tab(text: 'Acceptées'),
            Tab(text: 'Annulées'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReservationsList('En attente'), // Tab "En attente"
          _buildReservationsList('Acceptée'),   // Tab "Acceptées"
          _buildReservationsList('Annulée'),    // Tab "Annulées"
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
          return Center(child: Text('Aucune réservation $status.'));
        }

        final reservations = snapshot.data!.docs;

        return ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index].data() as Map<String, dynamic>;
            final reservationId = reservations[index].id;

            return _buildReservationItem(
              reservationId: reservationId,
              dateRange: reservation['reservationDate'] ?? 'Date inconnue',
              carModel: reservation['carModel'] ?? 'Modèle inconnu',
              location: reservation['location'] ?? 'Lieu inconnu',
              clientName: reservation['userName'] ?? 'Client inconnu',
              price: reservation['price'] ?? 'Prix inconnu',
              imageUrl: reservation['imageUrl'] ?? 'assets/images/default_car.png', // Image par défaut
              status: reservation['status'] ?? 'Statut inconnu',
            );
          },
        );
      },
    );
  }

  Widget _buildReservationItem({
    required String reservationId,
    required String dateRange,
    required String carModel,
    required String location,
    required String clientName,
    required String price,
    required String imageUrl,
    required String status,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateRange,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  SizedBox(height: 5),
                  Text(
                    carModel,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text('Lieu : $location', style: TextStyle(color: Colors.grey)),
                  Text('Client : $clientName', style: TextStyle(color: Colors.grey)),
                  Text('Prix : $price', style: TextStyle(color: Colors.orange)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      if (status == 'En attente') ...[
                        ElevatedButton(
                          onPressed: () => _updateReservationStatus(reservationId, 'Acceptée'),
                          child: Text('Accepter'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _updateReservationStatus(reservationId, 'Annulée'),
                          child: Text('Annuler'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        ),
                      ],
                      if (status == 'Acceptée') ...[
                        Text('Réservation acceptée', style: TextStyle(color: Colors.green)),
                      ],
                      if (status == 'Annulée') ...[
                        Text('Réservation annulée', style: TextStyle(color: Colors.red)),
                      ],
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
