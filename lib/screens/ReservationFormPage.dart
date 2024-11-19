import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'payment_choice_page.dart'; // Ensure to import the payment choice page

class ReservationFormPage extends StatefulWidget {
  @override
  _ReservationFormPageState createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  final _formKey = GlobalKey<FormState>();
  String carModel = '';
  String location = '';
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now().add(Duration(days: 1));
  String userName = '';
  String userPhone = '';
  bool hasChauffeur = false;
  String chauffeurName = '';
  String chauffeurPhone = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Calculate rental duration in days
  int get rentalDuration {
    return selectedEndDate.difference(selectedStartDate).inDays;
  }

  // Submit reservation to Firestore
  Future<void> submitReservation() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Add reservation to Firestore
        await _firestore.collection('reservations').add({
          'carModel': carModel,
          'location': location,
          'startDate': selectedStartDate.toIso8601String(),
          'endDate': selectedEndDate.toIso8601String(),
          'rentalDuration': rentalDuration,
          'userName': userName,
          'userPhone': userPhone,
          'chauffeur': hasChauffeur ? {
            'chauffeurName': chauffeurName,
            'chauffeurPhone': chauffeurPhone,
          } : null,
          'status': 'En attente', // Default status
        });

        // Show success dialog
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
                    Navigator.pop(context); // Return to the previous page
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

  // Payment process simulation
  Future<void> processPayment() async {
    // Navigate to the payment choice page
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentChoicePage(
          onPaymentConfirmed: () {
            // Simulate payment success
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
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Formulaire de Réservation",
          style: TextStyle(
            color: Colors.black, // Title color
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
           
          ),
        ),
      ),
      body: Padding(
         
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              
              // Add logo at the top
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/1.jpg', // Ensure to add the logo in assets folder
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Car Model Field
              _buildTextField(
                label: 'Modèle de voiture',
                icon: Icons.directions_car,
                onChanged: (value) => carModel = value,
                validator: (value) => value!.isEmpty ? 'Entrez le modèle de voiture' : null,
              ),
              SizedBox(height: 15),
              // Location Field
              _buildTextField(
                label: 'Lieu de prise en charge',
                icon: Icons.location_on,
                onChanged: (value) => location = value,
                validator: (value) => value!.isEmpty ? 'Entrez le lieu' : null,
              ),
              SizedBox(height: 15),
              // User Name Field
              _buildTextField(
                label: 'Votre nom',
                icon: Icons.person,
                onChanged: (value) => userName = value,
                validator: (value) => value!.isEmpty ? 'Entrez votre nom' : null,
              ),
              SizedBox(height: 15),
              // User Phone Field
              _buildTextField(
                label: 'Votre téléphone',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                onChanged: (value) => userPhone = value,
                validator: (value) => value!.isEmpty ? 'Entrez votre numéro de téléphone' : null,
              ),
              SizedBox(height: 15),
              // Start Date Picker
              _buildDatePicker(
                label: "Date de début",
                selectedDate: selectedStartDate,
                onDateSelected: (date) {
                  setState(() {
                    selectedStartDate = date;
                  });
                },
              ),
              SizedBox(height: 15),
              // End Date Picker
              _buildDatePicker(
                label: "Date de fin",
                selectedDate: selectedEndDate,
                onDateSelected: (date) {
                  setState(() {
                    selectedEndDate = date;
                  });
                },
              ),
              SizedBox(height: 15),
              // Rental Duration Display
              Text(
                "Durée de location: $rentalDuration jour(s)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 15),
              // Chauffeur Option
              SwitchListTile(
                title: Text('Souhaitez-vous un chauffeur ?'),
                value: hasChauffeur,
                onChanged: (bool value) {
                  setState(() {
                    hasChauffeur = value;
                  });
                },
              ),
              if (hasChauffeur) ...[
                // Chauffeur Name Field
                _buildTextField(
                  label: 'Nom du chauffeur',
                  icon: Icons.person,
                  onChanged: (value) => chauffeurName = value,
                  validator: (value) => value!.isEmpty ? 'Entrez le nom du chauffeur' : null,
                ),
                SizedBox(height: 15),
                // Chauffeur Phone Field
                _buildTextField(
                  label: 'Téléphone du chauffeur',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => chauffeurPhone = value,
                  validator: (value) => value!.isEmpty ? 'Entrez le numéro du chauffeur' : null,
                ),
                SizedBox(height: 15),
              ],
              // Submit Reservation Button
              _buildButton(
                label: 'Soumettre la réservation',
                color: Colors.blue,
                onPressed: submitReservation,
              ),
              SizedBox(height: 20),
              // Payment Button
              _buildButton(
                label: 'Payer maintenant',
                color: Colors.green,
                onPressed: processPayment,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for TextField widget
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    required String? Function(String?) validator,
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

  // Helper method for Date Picker widget
  Widget _buildDatePicker({
    required String label,
    required DateTime selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return ListTile(
      title: Text("$label: ${selectedDate.toLocal()}".split(' ')[0]),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
    );
  }

  // Helper method for button styling
  Widget _buildButton({
    required String label,
    required Color color,
    required void Function() onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 5,
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
