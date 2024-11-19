import 'package:flutter/material.dart';

class CarManagementPage extends StatefulWidget {
  @override
  _CarManagementPageState createState() => _CarManagementPageState();
}

class _CarManagementPageState extends State<CarManagementPage> {
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false; // Toggle for edit mode
  String? carModel;
  String? carMake;
  String? carYear;
  String? carPrice;
  String? carImageUrl;

  // For simplicity, assuming this is the selected car being edited
  String? selectedCarModel = 'BMW X5'; // Example selected model

  // For demonstration purposes only
  List<String> carMakes = ['BMW', 'Mercedes', 'Audi'];
  List<String> carYears = ['2020', '2021', '2022', '2023'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Car' : 'Add Car'),
        actions: [
          if (isEditing)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteCar,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Car Model
              _buildTextField(
                label: 'Car Model',
                icon: Icons.directions_car,
                initialValue: isEditing ? (selectedCarModel ?? '') : '',
                onSaved: (value) => carModel = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the car model';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Car Make
              _buildDropdown(
                label: 'Car Make',
                value: carMake,
                items: carMakes,
                onChanged: (value) {
                  setState(() {
                    carMake = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Car Year
              _buildDropdown(
                label: 'Car Year',
                value: carYear,
                items: carYears,
                onChanged: (value) {
                  setState(() {
                    carYear = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Car Price
              _buildTextField(
                label: 'Price (per day)',
                icon: Icons.attach_money,
                initialValue: isEditing ? carPrice : '',
                onSaved: (value) => carPrice = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the car price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Car Image URL
              _buildTextField(
                label: 'Image URL',
                icon: Icons.image,
                initialValue: isEditing ? carImageUrl : '',
                onSaved: (value) => carImageUrl = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid image URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Save button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(isEditing ? 'Save Changes' : 'Add Car'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String? initialValue,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      onChanged: onChanged,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a $label';
        }
        return null;
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Process the car data (e.g., save it to the database)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditing ? 'Car updated!' : 'Car added!')),
      );
    }
  }

  void _deleteCar() {
    // Delete the car logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Car deleted!')),
    );
  }
}