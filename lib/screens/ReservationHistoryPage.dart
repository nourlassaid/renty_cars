import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class ReservationHistoryPage extends StatefulWidget {
  @override
  _ReservationHistoryPageState createState() => _ReservationHistoryPageState();
}

class _ReservationHistoryPageState extends State<ReservationHistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> upcomingReservations = [];
  List<QueryDocumentSnapshot> pastReservations = [];

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }
Future<void> _fetchReservations() async {
  try {
    // Fetch reservations from Firestore
    QuerySnapshot snapshot = await _firestore.collection('reservations').get();
    List<QueryDocumentSnapshot> allReservations = snapshot.docs;

    DateTime now = DateTime.now();

    // Separate reservations into upcoming and past based on endDate
    upcomingReservations = allReservations.where((reservation) {
      // Safely check if 'endDate' field exists by casting data to Map<String, dynamic>
      var data = reservation.data() as Map<String, dynamic>;
      if (data.containsKey('endDate')) {
        DateTime endDate = DateTime.parse(data['endDate']);
        return endDate.isAfter(now);
      }
      return false; // If 'endDate' doesn't exist, consider it as past
    }).toList();

    pastReservations = allReservations.where((reservation) {
      // Safely check if 'endDate' field exists by casting data to Map<String, dynamic>
      var data = reservation.data() as Map<String, dynamic>;
      if (data.containsKey('endDate')) {
        DateTime endDate = DateTime.parse(data['endDate']);
        return endDate.isBefore(now);
      }
      return false; // If 'endDate' doesn't exist, consider it as past
    }).toList();

    setState(() {});  // Refresh the UI after fetching the data
  } catch (e) {
    print("Error fetching reservations: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error fetching reservations")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des Réservations'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle('Réservations à venir'),
            _buildReservationList(upcomingReservations),
            _buildSectionTitle('Réservations passées'),
            _buildReservationList(pastReservations),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildReservationList(List<QueryDocumentSnapshot> reservations) {
    if (reservations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Aucune réservation disponible.'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        var reservation = reservations[index];
        DateTime startDate = DateTime.parse(reservation['startDate']);
        DateTime endDate = DateTime.parse(reservation['endDate']);
        String carName = reservation['carName'];
        String location = reservation['location'];
        String returnLocation = reservation['returnLocation'];
        String status = reservation['status'];

        // Format the dates for display
        String formattedStartDate = DateFormat('d MMM y').format(startDate);
        String formattedEndDate = DateFormat('d MMM y').format(endDate);

        return Card(
          elevation: 2.0,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: ListTile(
            title: Text(carName),
            subtitle: Text(
              "Lieu: $location\nRetour: $returnLocation\n"
              "Du: $formattedStartDate au $formattedEndDate\nStatut: $status",
              style: TextStyle(fontSize: 14),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Show reservation details when tapped
              _showReservationDetails(reservation);
            },
          ),
        );
      },
    );
  }

  void _showReservationDetails(QueryDocumentSnapshot reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Détails de la réservation'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nom de la voiture: ${reservation['carName']}"),
              Text("Lieu de récupération: ${reservation['location']}"),
              Text("Lieu de retour: ${reservation['returnLocation']}"),
              Text("Date de début: ${DateFormat('d MMM y').format(DateTime.parse(reservation['startDate']))}"),
              Text("Date de fin: ${DateFormat('d MMM y').format(DateTime.parse(reservation['endDate']))}"),
              Text("Statut: ${reservation['status']}"),
              Text("Commentaire: ${reservation['comment'] ?? 'Aucun'}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
