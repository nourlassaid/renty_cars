import 'package:flutter/material.dart';

class PaymentChoicePage extends StatelessWidget {
  final Function onPaymentConfirmed;

  PaymentChoicePage({required this.onPaymentConfirmed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choisir un mode de paiement"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text("Carte de crédit / Débit"),
              onTap: () {
                // Confirmer le paiement et revenir à la page de réservation
                onPaymentConfirmed();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.paypal),
              title: Text("PayPal"),
              onTap: () {
                // Confirmer le paiement et revenir à la page de réservation
                onPaymentConfirmed();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text("Paiement en espèces"),
              onTap: () {
                // Confirmer le paiement et revenir à la page de réservation
                onPaymentConfirmed();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
