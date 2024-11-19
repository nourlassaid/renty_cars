import 'package:flutter/material.dart';
import 'package:rentycars_nour/screens/home_page.dart'; // Import your home page
import 'package:rentycars_nour/admin/admin_home_page.dart';  // Ensure this is correct


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the Home Page after a delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/'); // Navigate to the HomePage
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Background color of the splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Replace this with your custom logo
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              child: Image.asset(
                'assets/images/1.jpg', // Path to your logo image
                width: 60, // Adjust the size as needed
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "RentyCars",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
