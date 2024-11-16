import 'package:flutter/material.dart';

class ReservationHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Exemple de données pour les réservations
    final List<Map<String, String>> reservations = [
      {
        'carModel': 'Toyota Corolla',
        'reservationDate': '2024-10-01',
        'status': 'Terminée',
      },
      {
        'carModel': 'Mercedes-Benz C-Class',
        'reservationDate': '2024-10-15',
        'status': 'En attente',
      },
      {
        'carModel': 'Jeep Wrangler',
        'reservationDate': '2024-11-01',
        'status': 'Terminée',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historique de Réservation',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(
                    Icons.directions_car,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  reservation['carModel']!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  'Date : ${reservation['reservationDate']}',
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Chip(
                  label: Text(
                    reservation['status']!,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: reservation['status'] == 'Terminée'
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
