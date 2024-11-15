import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  Future<void> login(BuildContext context) async {
    try {
      QuerySnapshot querySnapshot = await users
          .where('email', isEqualTo: emailController.text)
          .where('password', isEqualTo: passwordController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // User found
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        String userId = querySnapshot.docs.first.id; // Get the user ID
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
           // builder: (context) => PersonalDataPage(userId: userId, userData: userData),
            builder: (context) => RentCarsHomePage(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User successfully logged in')));
      } else {
        // User not found
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email or password')));
      }
    } catch (error) {
      print("Failed to log in user: $error");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log in user: $error')));
    }
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
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                suffixIcon: Icon(Icons.visibility),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
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
}
