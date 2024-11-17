import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rentycars_nour/admin/admin_dashboard.dart';
import 'package:rentycars_nour/screens/create_account_page.dart';
import 'package:rentycars_nour/services/api.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiServices apiServices = ApiServices(); // Create an instance of ApiServices

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Color blueColor = Colors.blue;
Future<void> login(BuildContext context) async {
  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez remplir tous les champs')),
    );
    return;
  }

  try {
    QuerySnapshot querySnapshot = await users
        .where('email', isEqualTo: emailController.text)
        .where('password', isEqualTo: passwordController.text)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // User found
      var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      String role = userData['role']; // Get the role of the user

      if (role == 'admin') {
        // Navigate to admin dashboard if user is an admin
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AdminDashboard() // Admin page
          ),
        );
      } else {
        // Navigate to home page if user is a client
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RentCarsHomePage(),
          ),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connexion réussie')),
      );
    } else {
      // User not found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email ou mot de passe invalide')),
      );
    }
  } catch (error) {
    print("Échec de la connexion de l'utilisateur: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur de connexion: $error')),
    );
  }
}

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Identifiez-vous ou inscrivez-vous"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Se connecter avec',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/create_account');
                  },
                  child: Text(
                    'Créer un compte',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.blue, thickness: 2),
            SizedBox(height: 20),
            _buildTextField(
              controller: emailController,
              label: "E-mail",
              icon: Icons.email,
              validator: (value) => value!.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value) ? 'Veuillez entrer un email valide' : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: passwordController,
              label: "Mot de passe",
              icon: Icons.lock,
              obscureText: true,
              validator: (value) => value!.isEmpty ? 'Veuillez entrer un mot de passe' : null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () => login(context),
              child: Text('Connexion'),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // Handle forgot password
                },
                child: Text('J\'ai oublié mon mot de passe'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(FontAwesomeIcons.google),
              label: Text("Connectez-vous avec Google"),
              onPressed: () {
                // Google sign-in logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
                side: BorderSide(color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "En vous connectant, vous acceptez la Politique de confidentialité de Rentcars",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
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
