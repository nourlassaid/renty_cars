import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'payment_choice_page.dart';

class ReservationFormPage extends StatefulWidget {
  @override
  _ReservationFormPageState createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  final _formKey = GlobalKey<FormState>();
  String carName = '';
  String location = '';
  String returnLocation = '';
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now().add(Duration(days: 1));
  int numPassengers = 1;
  bool hasInsurance = false;
  String comment = '';
  bool hasChauffeur = false;
  String chauffeurName = '';
  String chauffeurPhone = '';
  String driversLicense = ''; // Champ ajouté pour le permis de conduire
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> carNames = ['Toyota Corolla', 'BMW X5', 'Tesla Model 3'];

  int get rentalDuration {
    return selectedEndDate.difference(selectedStartDate).inDays;
  }

  // Fonction pour soumettre la réservation
  Future<void> submitReservation() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestore.collection('reservations').add({
          'carName': carName,
          'location': location,
          'returnLocation': returnLocation,
          'startDate': selectedStartDate.toIso8601String(),
          'endDate': selectedEndDate.toIso8601String(),
          'rentalDuration': rentalDuration,
          'numPassengers': numPassengers,
          'hasInsurance': hasInsurance,
          'comment': comment,
          'chauffeur': hasChauffeur
              ? {'chauffeurName': chauffeurName, 'chauffeurPhone': chauffeurPhone}
              : null,
          'driversLicense': driversLicense, // Sauvegarde du permis de conduire
          'status': 'En attente',
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Succès'),
            content: Text('Votre réservation a été soumise avec succès !'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        print('Erreur : $e');
      }
    }
  }

  // Fonction pour traiter le paiement
  Future<void> processPayment() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentChoicePage(
          onPaymentConfirmed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
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
              ),
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
        title: Text('Formulaire de Réservation'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nom de la voiture
              _buildDropdownField(
                label: 'Nom de la voiture',
                value: carName,
                items: carNames,
                onChanged: (value) => setState(() => carName = value!),
              ),
              SizedBox(height: 15),
              // Lieu de récupération
              _buildTextField(
                label: 'Lieu de récupération',
                icon: Icons.location_on,
                onChanged: (value) => location = value,
                validator: (value) =>
                    value!.isEmpty ? 'Entrez le lieu de récupération' : null,
              ),
              SizedBox(height: 15),
              // Lieu de retour
              _buildTextField(
                label: 'Lieu de retour',
                icon: Icons.location_on,
                onChanged: (value) => returnLocation = value,
                validator: (value) =>
                    value!.isEmpty ? 'Entrez le lieu de retour' : null,
              ),
              SizedBox(height: 15),
              // Nombre de passagers
              _buildTextField(
                label: 'Nombre de passagers',
                icon: Icons.people,
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    numPassengers = int.tryParse(value) ?? 1,
                validator: (value) =>
                    value!.isEmpty ? 'Entrez le nombre de passagers' : null,
              ),
              SizedBox(height: 15),
              // Date de début
              _buildDatePicker(
                label: "Date de début",
                selectedDate: selectedStartDate,
                onDateSelected: (date) =>
                    setState(() => selectedStartDate = date),
              ),
              SizedBox(height: 15),
              // Date de fin avec durée maximale
              _buildDatePicker(
                label: "Date de fin",
                selectedDate: selectedEndDate,
                onDateSelected: (date) {
                  int maxDuration = 30; // Limitation par défaut à 30 jours
                  if (date.difference(selectedStartDate).inDays > maxDuration) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'La réservation ne peut pas dépasser $maxDuration jours.',
                        ),
                      ),
                    );
                  } else {
                    setState(() => selectedEndDate = date);
                  }
                },
              ),
              SizedBox(height: 15),
              // Assurance
              CheckboxListTile(
                title: Text('Souhaitez-vous souscrire à une assurance supplémentaire ?'),
                value: hasInsurance,
                onChanged: (value) =>
                    setState(() => hasInsurance = value ?? false),
              ),
              SizedBox(height: 15),
              // Commentaire
              _buildTextField(
                label: 'Commentaire (facultatif)',
                icon: Icons.comment,
                onChanged: (value) => comment = value,
              ),
              SizedBox(height: 15),
              // Chauffeur
              SwitchListTile(
                title: Text('Existe t-il un deuxieme chauffeur ?'),
                value: hasChauffeur,
                onChanged: (value) => setState(() => hasChauffeur = value),
              ),
              if (hasChauffeur) ...[
                _buildTextField(
                  label: 'Nom du chauffeur',
                  icon: Icons.person,
                  onChanged: (value) => chauffeurName = value,
                  validator: (value) => value!.isEmpty
                      ? 'Entrez le nom du chauffeur'
                      : null,
                ),
                SizedBox(height: 15),
                _buildTextField(
                  label: 'Téléphone du chauffeur',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => chauffeurPhone = value,
                  validator: (value) => value!.isEmpty
                      ? 'Entrez le numéro du chauffeur'
                      : null,
                ),
                SizedBox(height: 15),
              ],
              // Permis de conduire
              _buildTextField(
                label: 'Numéro de permis de conduire',
                icon: Icons.credit_card,
                onChanged: (value) => driversLicense = value,
                validator: (value) => value!.isEmpty
                    ? 'Entrez votre numéro de permis de conduire'
                    : null,
              ),
              SizedBox(height: 15),
              // Bouton de soumission
              _buildButton(
                label: 'Soumettre la réservation',
                color: Colors.blue,
                onPressed: submitReservation,
              ),
              SizedBox(height: 20),
              // Bouton de paiement
              _buildButton(
                label: 'Payer maintenant',
                color: Colors.green,
                onPressed: processPayment, // Maintenant défini correctement
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.directions_car),
      ),
      value: value.isNotEmpty ? value : null,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (value) =>
          value == null || value.isEmpty ? 'Sélectionnez une option' : null,
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.calendar_today),
      title: Text('$label: ${selectedDate.toLocal()}'.split(' ')[0]),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null && picked != selectedDate) {
          onDateSelected(picked);
        }
      },
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(label, style: TextStyle(fontSize: 16)),
    );
  }
}
