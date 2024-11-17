import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarFormPage extends StatefulWidget {
  final String? carId;
  final Map<String, dynamic>? carData;

  CarFormPage({this.carId, this.carData});

  @override
  _CarFormPageState createState() => _CarFormPageState();
}

class _CarFormPageState extends State<CarFormPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.carData != null) {
      _modelController.text = widget.carData!['model'];
      _priceController.text = widget.carData!['price'];
      _locationController.text = widget.carData!['location'];
    }
  }

  void saveCar() {
    if (_formKey.currentState!.validate()) {
      final carData = {
        'model': _modelController.text,
        'price': _priceController.text,
        'location': _locationController.text,
        'imageUrl': 'path_to_image', // You may use image picker here
      };

      if (widget.carId == null) {
        // Add new car
        FirebaseFirestore.instance.collection('cars').add(carData);
      } else {
        // Edit existing car
        FirebaseFirestore.instance
            .collection('cars')
            .doc(widget.carId)
            .update(carData);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.carId == null ? 'Add Car' : 'Edit Car'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _modelController,
                decoration: InputDecoration(labelText: 'Car Model'),
                validator: (value) => value!.isEmpty ? 'Please enter car model' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) => value!.isEmpty ? 'Please enter price' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value!.isEmpty ? 'Please enter location' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveCar,
                child: Text(widget.carId == null ? 'Add Car' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
