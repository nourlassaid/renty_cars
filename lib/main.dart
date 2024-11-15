import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rentycars_nour/screens/ReservationsPage.dart';
import 'package:rentycars_nour/screens/home_page.dart';
import 'package:rentycars_nour/screens/profile_page.dart';
import 'package:rentycars_nour/screens/loginpage.dart';
import 'package:rentycars_nour/screens/create_account_page.dart';
import 'package:rentycars_nour/splash_screen.dart';
import 'package:rentycars_nour/splash_screen.dart';  // Import the splash screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAyIPvr6Bu5oKJdVA92_uRp5rbMPhCt6aE",
        appId: "1:586390612591:web:7fed672aa9e4f2df85bb9a",
        messagingSenderId: "586390612591",
        projectId: "renty2nour",
        authDomain: "renty2nour.firebaseapp.com",
        storageBucket: "renty2nour.appspot.com",
      ),
    );
    print("Firebase Initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',  // Initial route to Splash Screen
      routes: {
        '/splash': (context) => SplashScreen(),  // Splash screen route
        '/': (context) => RentCarsHomePage(),  // Home Page
        '/profile': (context) => ProfilePage(),  // Profile Page
        '/login': (context) => LoginPage(),  // Login Page
        '/create_account': (context) => CreateAccountPage(),  // Create Account Page
        '/reservations': (context) => ReservationsPage(),  // Reservations Page
      },
    );
  }
}
