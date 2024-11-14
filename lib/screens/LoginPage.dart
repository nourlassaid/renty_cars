import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
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
            // Tabs for 'Se connecter avec' and 'Créer un compte'
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
            
            // Email field
            TextField(
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            
            // Password field with visibility icon
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                suffixIcon: Icon(Icons.visibility),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            
            // Login button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50), // Full-width button
              ),
              onPressed: () {
                // Handle login
              },
              child: Text('Connexion'),
            ),
            
            // Forgot password link
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
            
            // Google sign-in button
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
            
            // Privacy policy note
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
