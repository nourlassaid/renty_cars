import 'package:flutter/material.dart';

class OffersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offres', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
         backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            OfferCard(
              title: 'Réduction sur la première réservation',
              description: 'Obtenez une réduction de 20% sur votre première réservation.',
              offerCode: 'FIRST20',
              validity: 'Valide jusqu\'au 31 décembre 2024',
            ),
            OfferCard(
              title: 'Offre de fidélité',
              description: 'Réservez 5 voitures et obtenez 1 réservation gratuite.',
              offerCode: 'LOYALTY1',
              validity: 'Valide jusqu\'au 30 novembre 2024',
            ),
            OfferCard(
              title: 'Réduction sur les réservations longues',
              description: 'Réservez pour plus de 7 jours et bénéficiez de 15% de réduction.',
              offerCode: 'LONGTERM15',
              validity: 'Valide jusqu\'au 31 janvier 2025',
            ),
          ],
        ),
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final String title;
  final String description;
  final String offerCode;
  final String validity;

  OfferCard({
    required this.title,
    required this.description,
    required this.offerCode,
    required this.validity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Code de l\'offre: ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Text(
                  offerCode,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Validité: $validity',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey,),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Add functionality for redeeming the offer
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: Text(
                'Réclamer l\'offre',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
