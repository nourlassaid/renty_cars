import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des Réservations"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('reservations').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucune réservation trouvée.'));
          }

          final reservations = snapshot.data!.docs;
          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index].data() as Map<String, dynamic>;
              final reservationId = reservations[index].id;

              return ReservationTile(
                reservationId: reservationId,
                carModel: reservation['carModel'] ?? 'Modèle inconnu',
                clientName: reservation['clientName'] ?? 'Client inconnu',
                status: reservation['status'] ?? 'Statut inconnu',
                reservationDate: reservation['reservationDate'] ?? 'Date inconnue',
              );
            },
          );
        },
      ),
    );
  }
}

class ReservationTile extends StatelessWidget {
  final String reservationId;
  final String carModel;
  final String clientName;
  final String status;
  final String reservationDate;

  ReservationTile({
    required this.reservationId,
    required this.carModel,
    required this.clientName,
    required this.status,
    required this.reservationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(Icons.car_rental, size: 40, color: Colors.blue),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carModel,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text('Client: $clientName'),
                  Text('Date: $reservationDate'),
                  SizedBox(height: 10),
                  Text(
                    'Statut: $status',
                    style: TextStyle(
                      color: status == 'Acceptée' ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      // Accept or Cancel buttons (optional based on status)
                      if (status == 'En attente') ...[
                        ElevatedButton(
                          onPressed: () {
                            _updateReservationStatus(reservationId, 'Acceptée');
                          },
                          child: Text('Accepter'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            _updateReservationStatus(reservationId, 'Annulée');
                          },
                          child: Text('Annuler'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        ),
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

  // Function to update reservation status
  Future<void> _updateReservationStatus(String reservationId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('reservations').doc(reservationId).update({
        'status': newStatus,
      });
      print('Reservation status updated to $newStatus');
    } catch (e) {
      print('Failed to update reservation status: $e');
    }
  }
}
