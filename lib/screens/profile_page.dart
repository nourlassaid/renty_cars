import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser; // Utilisateur actuel

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut(); // Déconnexion
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
            onPressed: () => logout(context), // Action pour déconnexion
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar de profil
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : AssetImage('assets/images/default_avatar.jpg') as ImageProvider,
            ),
            SizedBox(height: 10),
            // Nom d'utilisateur
            Text(
              user?.displayName ?? 'nour lassaid',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Email de l'utilisateur
            Text(
              user?.email ?? 'nour@gmail.com',
              style: TextStyle(color: const Color.fromARGB(255, 255, 253, 253)),
            ),
            SizedBox(height: 20),

            // Toggle Buttons
            ToggleButtons(
              borderColor: Colors.grey,
              selectedBorderColor: Colors.blue,
              borderRadius: BorderRadius.circular(20),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Mes voitures'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Réservations'),
                ),
              ],
              isSelected: [true, false], // Sélection par défaut
              onPressed: (int index) {
                // Fonctionnalité des boutons toggle
              },
            ),
            SizedBox(height: 20),

            // Liste des options
            Expanded(
              child: ListView(
                children: [
                  _buildProfileOption(
                    icon: Icons.info_outline,
                    title: 'Infos personnelles',
                    subtitle: 'Mettez à jour vos informations personnelles',
                    onTap: () {
                      // Action pour infos personnelles
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.car_rental,
                    title: 'Lister ma voiture',
                    subtitle: 'Ajoutez votre voiture à la location',
                    onTap: () {
                      // Action pour lister une voiture
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.verified_user_outlined,
                    title: 'Vérifier mon compte',
                    subtitle: 'Renforcez la confiance en vérifiant votre identité',
                    onTap: () {
                      // Action pour vérification
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.campaign_outlined,
                    title: 'Promouvoir ma voiture',
                    subtitle: 'Améliorez la visibilité de votre voiture',
                    onTap: () {
                      // Action pour promouvoir une voiture
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // Onglet actif
        onTap: (index) {
          // Navigation entre les pages
          if (index == 0) Navigator.pushNamed(context, '/');
          if (index == 1) Navigator.pushNamed(context, '/search');
          if (index == 2) Navigator.pushNamed(context, '/favorites');
          if (index == 3) Navigator.pushNamed(context, '/notifications');
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
