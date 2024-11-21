import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.blueAccent,
                    size: 40,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Créer un compte',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'Ou se connecter',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text(
              'Notifications',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            onTap: () {
              // Logique pour afficher les notifications
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              'Réserver une voiture',
              style: TextStyle(
                color: Colors.blue,
                fontFamily: 'Roboto',
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/reservation_form');
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text(
              'Historique des recherches',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/search_history');
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text(
              'Historique des réservations',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/reservation_history');
            },
          ),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text(
              'Offres',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/offers');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(
              'Paiement',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/payment');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Paramètres',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text(
              'Centre d\'aide',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            onTap: () {
              // Implémenter la logique d'aide
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text(
              'Partager Rentcars',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            onTap: () {
              // Implémenter la logique de partage
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Déconnexion',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/login'); // Rediriger vers la page de connexion
            },
          ),
        ],
      ),
    );
  }
}
