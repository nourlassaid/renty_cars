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
            child: Center( // Centrer le contenu dans le DrawerHeader
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centrer la colonne verticalement
                crossAxisAlignment: CrossAxisAlignment.center, // Centrer la colonne horizontalement
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 30,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Créer un compte',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Roboto', // Custom font
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
                        color: Colors.blue,
                        fontFamily: 'Roboto', // Custom font
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text(
              'Notifications',
              style: TextStyle(
                fontFamily: 'Roboto', // Custom font
              ),
            ),
            onTap: () {}, // Implémenter la fonctionnalité
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              'Réserver une voiture',
              style: TextStyle(
                color: Colors.blue,
                fontFamily: 'Roboto', // Custom font
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/reservation_form'); // Naviguer vers le formulaire de réservation
            },
          ),
         
          ListTile(
            leading: Icon(Icons.history),
            title: Text(
              'Historique des recherches',
              style: TextStyle(
                fontFamily: 'Roboto', // Custom font
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/search_history');  // Naviguer vers la page de l'historique des recherches
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text(
              'Historique des réservations',
              style: TextStyle(
                fontFamily: 'Roboto', // Custom font
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/reservation_history');  // Naviguer vers la page de l'historique des réservations
            },
          ),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text(
              'Offres',
              style: TextStyle(
                fontFamily: 'Roboto', // Custom font
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/offers'); // Naviguer vers la page des offres
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(
              'Paiement',
              style: TextStyle(
                fontFamily: 'Roboto', // Custom font
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/payment'); // Naviguer vers la page de paiement
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Paramètres',
              style: TextStyle(
                fontFamily: 'Roboto', // Custom font
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/settings'); // Naviguer vers la page des paramètres
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text(
              'Centre d\'aide',
              style: TextStyle(
                fontFamily: 'Roboto', // Custom font
              ),
            ),
            onTap: () {}, // Implémenter la fonctionnalité
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text(
              'Rentcars',
              style: TextStyle(
                fontFamily: 'Roboto', // Custom font
              ),
            ),
            onTap: () {}, // Implémenter la fonctionnalité
          ),
        ],
      ),
    );
  }
}
