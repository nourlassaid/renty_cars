import 'package:flutter/material.dart';

class ReservationHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data for reservations
    final List<Map<String, String>> reservations = [
      {
        'carModel': 'Toyota Corolla',
        'reservationDate': '2024-10-01',
        'status': 'Completed',
      },
      {
        'carModel': 'Mercedes-Benz C-Class',
        'reservationDate': '2024-10-15',
        'status': 'Pending',
      },
      {
        'carModel': 'Jeep Wrangler',
        'reservationDate': '2024-11-01',
        'status': 'Completed',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Historique de Réservation'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          return ListTile(
            title: Text(reservation['carModel']!),
            subtitle: Text('Date: ${reservation['reservationDate']}'),
            trailing: Chip(
              label: Text(reservation['status']!),
              backgroundColor: reservation['status'] == 'Completed' ? Colors.green : Colors.orange,
            ),
          );
        },
      ),
    );
  }
}
