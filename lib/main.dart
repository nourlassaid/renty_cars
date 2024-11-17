import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rentycars_nour/admin/AdminReservationManagementPage.dart';
import 'package:rentycars_nour/admin/AdminUserManagementPage.dart';
import 'package:rentycars_nour/admin/BlockUserPage.dart';
import 'package:rentycars_nour/admin/ModifyReservationPage%20.dart';
import 'package:rentycars_nour/admin/ViewCarsPage.dart';
import 'package:rentycars_nour/admin/add_car.dart';
import 'package:rentycars_nour/admin/admin_dashboard.dart';
import 'package:rentycars_nour/admin/admin_gestion_agence.dart';
import 'package:rentycars_nour/admin/admin_dashboard.dart';
import 'package:rentycars_nour/screens/ReservationsPage.dart';
import 'package:rentycars_nour/screens/home_page.dart';
import 'package:rentycars_nour/screens/payment_choice_page.dart';
import 'package:rentycars_nour/screens/profile_page.dart';
import 'package:rentycars_nour/screens/loginpage.dart';
import 'package:rentycars_nour/screens/create_account_page.dart';
import 'package:rentycars_nour/splash_screen.dart'; // Splash screen
import 'package:rentycars_nour/screens/ReservationFormPage.dart';
import 'package:rentycars_nour/screens/ReservationHistoryPage.dart';
import 'package:rentycars_nour/screens/SearchHistoryPage.dart';
import 'package:rentycars_nour/screens/settings_page.dart'; // Settings page
import 'package:rentycars_nour/screens/offerspage.dart'; // Offers page
import 'screens/ReviewPage.dart';
import 'package:rentycars_nour/screens/payment_choice_page.dart';

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
      // Définir une seule `initialRoute`
      initialRoute: '/splash', // Splash Screen comme route initiale

      routes: {
        '/splash': (context) => SplashScreen(), // Splash screen route
        '/': (context) => RentCarsHomePage(), // Home Page
        '/profile': (context) => ProfilePage(), // Profile Page
        '/login': (context) => LoginPage(), // Login Page
        '/create_account': (context) => CreateAccountPage(), // Create Account Page
        '/reservations': (context) => ReservationsPage(), // Reservations Page
        '/reservation_form': (context) => ReservationFormPage(), // Reservation Form
        '/reservation_history': (context) => ReservationHistoryPage(), // Reservation History
        '/search_history': (context) => SearchHistoryPage(), // Search History
        '/settings': (context) => SettingsPage(), // Settings Page
        '/offers': (context) => OffersPage(), // Offers Page
   '/admin_dashboard': (context) => AdminDashboard(),  // Dashboard Admin
        '/add_car': (context) => AddCarPage(),  // Ajouter une voiture
        '/view_cars': (context) => ViewCarsPage(),  // Voir les voitures
        '/admin_user_management': (context) => AdminUserManagementPage(),  // Gestion des utilisateurs
        '/admin_reservation_management': (context) => AdminReservationManagementPage(),  // Gestion des réservations
        '/block_user': (context) => BlockUserPage(),  // Bloquer un utilisateur
        '/modify_reservation': (context) => ModifyReservationPage(),  // Modifier une réservation
               '/payment': (context) => PaymentChoicePage(
  onPaymentConfirmed: () {
    // Logique lorsque le paiement est confirmé
    print("Le paiement a été confirmé!");
    // Vous pouvez également naviguer vers une autre page ou afficher un message ici
  },
),

      },
    );
    
  }
}
