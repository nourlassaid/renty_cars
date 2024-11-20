import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  String _role = 'client'; // Default role

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Color blueColor = Colors.blue;

  Future<void> addUser() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmpasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
        );
        return;
      }

      try {
        await users.add({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'phone': phoneController.text,
          'role': _role, // Save the role
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compte créé avec succès')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création du compte : $error')),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un compte'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 5),
                Text(
                  "Créez un nouveau compte",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                _buildTextField(
                  controller: nameController,
                  label: "Nom",
                  icon: Icons.person,
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer votre nom' : null,
                ),
                SizedBox(height: 15),
                _buildTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                _buildTextField(
                  controller: phoneController,
                  label: "Téléphone",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer votre numéro de téléphone' : null,
                ),
                SizedBox(height: 15),
                _buildTextField(
                  controller: passwordController,
                  label: "Mot de passe",
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer un mot de passe' : null,
                ),
                SizedBox(height: 15),
                _buildTextField(
                  controller: confirmpasswordController,
                  label: "Confirmer le mot de passe",
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Veuillez confirmer votre mot de passe' : null,
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _role,
                  decoration: InputDecoration(
                    labelText: 'Rôle',
                    prefixIcon: Icon(Icons.person, color: blueColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['client', 'agent']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _role = value!;
                    });
                  },
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () => addUser(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    "CRÉER UN COMPTE",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    "Vous avez déjà un compte ? Connectez-vous",
                    style: TextStyle(
                      color: blueColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color.fromARGB(255, 198, 199, 201)),
        prefixIcon: Icon(icon, color: blueColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }
}
