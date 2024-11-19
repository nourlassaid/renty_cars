import 'package:flutter/material.dart';

class PaymentChoicePage extends StatelessWidget {
  final Function onPaymentConfirmed;

  PaymentChoicePage({required this.onPaymentConfirmed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Choisir un mode de paiement",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title section with padding for spacing
            Text(
              "Veuillez choisir votre mode de paiement",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20), // Adds spacing between title and options

            // Payment Options
            _buildPaymentOption(
              icon: Icons.credit_card,
              title: "Carte de crédit / Débit",
              onTap: () {
                onPaymentConfirmed();
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 15), // Space between options
            _buildPaymentOption(
              icon: Icons.paypal,
              title: "PayPal",
              onTap: () {
                onPaymentConfirmed();
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 15), // Space between options
            _buildPaymentOption(
              icon: Icons.money,
              title: "Paiement en espèces",
              onTap: () {
                onPaymentConfirmed();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build individual payment option cards
  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required Function() onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        leading: Icon(
          icon,
          color: Colors.blue,
          size: 30,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: Colors.blue,
        ),
        onTap: onTap,
      ),
    );
  }
}
