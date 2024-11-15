import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  Future<void> submitReservation() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestore.collection('reservations').add({
          'carModel': carModel,
          'location': location,
          'reservationDate': selectedDate.toIso8601String(),
          'userName': userName,
          'userPhone': userPhone,
          'status': 'Pending', // Default status
        });

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Reservation submitted successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context); // Retourner à la page précédente
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error submitting reservation: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservation Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Car Model'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter car model' : null,
                onChanged: (value) => carModel = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter location' : null,
                onChanged: (value) => location = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Your Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
                onChanged: (value) => userName = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Your Phone'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your phone' : null,
                onChanged: (value) => userPhone = value,
              ),
              ListTile(
                title: Text("Reservation Date: ${selectedDate.toLocal()}".split(' ')[0]),
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
              ElevatedButton(
                onPressed: submitReservation,
                child: Text('Submit'),
              ),
              ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/reservations');
  },
  child: Text('View Reservations'),
),

            ],
            
          ),
        ),
      ),
    );
  }
}
