import 'package:flutter/material.dart';

class OffersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offres'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
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
      margin: EdgeInsets.all(10),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Code de l\'offre: $offerCode',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Validité: $validity',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
