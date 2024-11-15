import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationsEnabled = true;
  bool _isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          // Notifications setting
          ListTile(
            title: Text('Notifications'),
            trailing: Switch(
              value: _isNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _isNotificationsEnabled = value;
                });
              },
            ),
          ),
          Divider(),

          // Dark Mode setting
          ListTile(
            title: Text('Mode sombre'),
            trailing: Switch(
              value: _isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _isDarkModeEnabled = value;
                });
                // You can implement dark mode switching logic here
              },
            ),
          ),
          Divider(),

          // Privacy Policy setting
          ListTile(
            title: Text('Politique de confidentialité'),
            onTap: () {
              // Navigate to Privacy Policy page
              Navigator.pushNamed(context, '/privacy_policy');
            },
          ),
          Divider(),

          // Terms and Conditions setting
          ListTile(
            title: Text('Termes et Conditions'),
            onTap: () {
              // Navigate to Terms and Conditions page
              Navigator.pushNamed(context, '/terms_conditions');
            },
          ),
          Divider(),

          // Language setting
          ListTile(
            title: Text('Langue'),
            onTap: () {
              // Open language selection options
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Sélectionner la langue'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('Français'),
                          onTap: () {
                            // Change language to French
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Anglais'),
                          onTap: () {
                            // Change language to English
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          Divider(),

          // Logout button
          ListTile(
            title: Text('Se déconnecter'),
            onTap: () {
              // Handle logout functionality
              Navigator.pushReplacementNamed(context, '/login'); // Redirect to login page
            },
          ),
        ],
      ),
    );
  }
}
