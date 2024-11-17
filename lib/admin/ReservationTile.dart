import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ReservationTile extends StatelessWidget {
  final String reservationId;
  final String carModel;
  final String clientName;
  final String status;
  final dynamic reservationDate; // It can be dynamic to handle multiple types

  ReservationTile({
    required this.reservationId,
    required this.carModel,
    required this.clientName,
    required this.status,
    required this.reservationDate,
  });

  @override
  Widget build(BuildContext context) {
    // Convert reservationDate to string if it's a Timestamp
    String formattedDate = '';
    if (reservationDate is Timestamp) {
      DateTime dateTime = (reservationDate as Timestamp).toDate();
      formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } else {
      formattedDate = reservationDate.toString(); // fallback if it's not a Timestamp
    }

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
                  Text('Date: $formattedDate'), // Display formatted date
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
