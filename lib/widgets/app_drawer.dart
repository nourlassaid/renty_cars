import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 30,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  'Créer un compte',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'ou se connecter',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                 
                    SizedBox(width: 8),
                    
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {}, // Implement functionality
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Réserver une voiture', style: TextStyle(color: Colors.blue)),
            onTap: () {}, // Implement functionality
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Mes Réservations'),
            onTap: () {
              Navigator.pushNamed(context, '/reservations');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text('Mon portefeuille'),
            onTap: () {}, // Implement functionality
          ),
          ListTile(
            leading: Icon(Icons.emoji_events),
            title: Text('RentRewards'),
            onTap: () {}, // Implement functionality
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Historique de recherche'),
            onTap: () {}, // Implement functionality
          ),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Offres'),
            onTap: () {}, // Implement functionality
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Paramètres'),
            onTap: () {}, // Implement functionality
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Politique de confidentialité'),
            onTap: () {}, // Implement functionality
          ),
          ListTile(
            leading: Icon(Icons.check_box),
            title: Text('Termes et Conditions'),
            onTap: () {}, // Implement functionality
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Centre d\'aide'),
            onTap: () {}, // Implement functionality
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Rentcars'),
            onTap: () {}, // Implement functionality
          ),
        ],
      ),
    );
  }
}
