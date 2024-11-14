import 'package:flutter/material.dart';
import 'package:rentycars_nour/screens/ReservationsPage.dart';
import 'package:rentycars_nour/screens/home_page.dart';  // Import home page
import 'package:rentycars_nour/screens/profile_page.dart';  // Import profile page
import 'package:rentycars_nour/screens/loginpage.dart';  // Import login page
import 'package:rentycars_nour/screens/create_account_page.dart';  // Import create account page
import 'package:rentycars_nour/widgets/app_drawer.dart';  // Import AppDrawer widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',  // Initial route (home page)
      routes: {
        '/': (context) => RentCarsHomePage(),  // Home page route
        '/profile': (context) => ProfilePage(),  // Profile page route
        '/login': (context) => LoginPage(),  // Login page route
        '/create_account': (context) => CreateAccountPage(),  // Create account page route
                '/reservations': (context) => ReservationsPage(),

      },
    );
  }
}
