import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _selectedItem = '';

  // This function is called whenever an item is tapped in the drawer
  void _onTap(String item) {
    setState(() {
      _selectedItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 254, 255, 255),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bienvenue',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.logo_dev, // Custom logo placeholder
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
          
          // Create Account Option
          ListTile(
            title: Text(
              'Créer un compte',
              style: TextStyle(
                color: _selectedItem == 'create_account' ? Colors.orange : Colors.black,
                fontWeight: _selectedItem == 'create_account' ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onTap: () {
              _onTap('create_account');
              Navigator.pushNamed(context, '/create_account');  // Navigate to create account page
            },
          ),
          
          // Login Option
          ListTile(
            title: Text(
              'Se connecter',
              style: TextStyle(
                color: _selectedItem == 'login' ? Colors.orange : Colors.black,
                fontWeight: _selectedItem == 'login' ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onTap: () {
              _onTap('login');
              Navigator.pushNamed(context, '/login');  // Navigate to login page
            },
          ),
          
          // Divider
          Divider(),
          
          // Profile Option
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.account_circle,
                  color: _selectedItem == 'profile' ? Colors.orange : Colors.black,
                ),
                SizedBox(width: 10),
                Text('Mon Profil'),
              ],
            ),
            onTap: () {
              _onTap('profile');
              Navigator.pushNamed(context, '/profile');  // Navigate to profile page
            },
          ),
          
          // Reservations Option
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.bookmark,
                  color: _selectedItem == 'reservations' ? Colors.orange : Colors.black,
                ),
                SizedBox(width: 10),
                Text('Réservations'),
              ],
            ),
            onTap: () {
              _onTap('reservations');
              Navigator.pushNamed(context, '/reservations');  // Navigate to reservations page
            },
          ),

          // Offers Option
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.local_offer,
                  color: _selectedItem == 'offers' ? Colors.orange : Colors.black,
                ),
                SizedBox(width: 10),
                Text('Offres'),
              ],
            ),
            onTap: () {
              _onTap('offers');
              Navigator.pushNamed(context, '/offers');  // Navigate to offers page
            },
          ),

          // History Option
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.history,
                  color: _selectedItem == 'history' ? Colors.orange : Colors.black,
                ),
                SizedBox(width: 10),
                Text('Historique'),
              ],
            ),
            onTap: () {
              _onTap('history');
              Navigator.pushNamed(context, '/history');  // Navigate to history page
            },
          ),

          // Divider
          Divider(),
          
          // Settings Option
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.settings,
                  color: _selectedItem == 'settings' ? Colors.orange : Colors.black,
                ),
                SizedBox(width: 10),
                Text('Paramètres'),
              ],
            ),
            onTap: () {
              _onTap('settings');
              Navigator.pushNamed(context, '/settings');  // Navigate to settings page
            },
          ),
          
          // Payments Option
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.payment,
                  color: _selectedItem == 'payments' ? Colors.orange : Colors.black,
                ),
                SizedBox(width: 10),
                Text('Paiements'),
              ],
            ),
            onTap: () {
              _onTap('payments');
              Navigator.pushNamed(context, '/payments');  // Navigate to payments page
            },
          ),

          // Divider
          Divider(),

          // Logout Option
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: _selectedItem == 'logout' ? Colors.orange : Colors.black,
                ),
                SizedBox(width: 10),
                Text('Déconnexion'),
              ],
            ),
            onTap: () {
              _onTap('logout');
              // Handle logout action (clear session, etc.)
              Navigator.pushNamed(context, '/login');  // Navigate to login page after logout
            },
          ),
        ],
      ),
    );
  }
}
