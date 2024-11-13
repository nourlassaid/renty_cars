import 'package:flutter/material.dart';
import 'package:rentycars_nour/screens/car_detail_page.dart';
import 'screens/home_page.dart';  // Import home page
import 'screens/profile_page.dart';  // Import profile page
import 'screens/loginpage.dart';  // Import login page
import 'screens/create_account_page.dart';  // Import create account page

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
        '/home': (context) => RentCarsHomePage(),
        '/profile': (context) => ProfilePage(),  // Profile page route
        '/login': (context) => LoginPage(),  // Login page route
        '/create_account': (context) => CreateAccountPage(),  // Create account page route
      },
    );
  }
}
