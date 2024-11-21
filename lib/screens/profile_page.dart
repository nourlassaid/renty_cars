// lib/screens/profile_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_edit_page.dart'; // Assurez-vous d'importer le fichier

class ProfilePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : AssetImage('assets/images/default_avatar.jpg') as ImageProvider,
            ),
            SizedBox(height: 10),
            Text(
              user?.displayName ?? 'nour lassaid',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? 'nour@gmail.com',
              style: TextStyle(color: const Color.fromARGB(255, 255, 253, 253)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileEditPage(user: user)),
                );
              },
              child: Text('Modifier le profil'),
            ),
          ],
        ),
      ),
    );
  }
}
