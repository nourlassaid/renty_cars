import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'payment_choice_page.dart'; // Assurez-vous d'importer la page de choix de paiement

class ReservationFormPage extends StatefulWidget {
  @override
  _ReservationFormPageState createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  final _formKey = GlobalKey<FormState>();
  String carModel = '';
  String location = '';
  DateTime selectedDate = DateTime.now();
  String userName = '';
  String userPhone = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Soumettre la réservation
  Future<void> submitReservation() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Ajouter la réservation dans Firestore
        await _firestore.collection('reservations').add({
          'carModel': carModel,
          'location': location,
          'reservationDate': selectedDate.toIso8601String(),
          'userName': userName,
          'userPhone': userPhone,
          'status': 'En attente', // Statut par défaut
        });

        // Afficher un dialogue de succès
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Succès'),
              content: Text('Votre réservation a été soumise avec succès !'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context); // Retour à la page précédente
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Erreur lors de la soumission de la réservation : $e');
      }
    }
  }

  // Fonction de traitement de paiement (simulation)
  Future<void> processPayment() async {
    // Naviguer vers la page de choix de paiement
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentChoicePage(
          onPaymentConfirmed: () {
            // Simuler le succès du paiement
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Paiement réussi'),
                  content: Text('Votre paiement a été effectué avec succès !'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulaire de Réservation"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Ajouter un logo en haut
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: Image.asset(
                    'assets/images/1.jpg', // Assurez-vous d'ajouter le logo dans le dossier assets
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Modèle de voiture',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_car),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Entrez le modèle de voiture' : null,
                onChanged: (value) => carModel = value,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Lieu de prise en charge',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Entrez le lieu' : null,
                onChanged: (value) => location = value,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Votre nom',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Entrez votre nom' : null,
                onChanged: (value) => userName = value,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Votre téléphone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Entrez votre numéro de téléphone' : null,
                onChanged: (value) => userPhone = value,
              ),
              SizedBox(height: 15),
              ListTile(
                title: Text(
                  "Date de réservation : ${selectedDate.toLocal()}".split(' ')[0],
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() => selectedDate = pickedDate);
                  }
                },
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: submitReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Soumettre la réservation',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Processus de paiement
                  await processPayment();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Payer maintenant',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
