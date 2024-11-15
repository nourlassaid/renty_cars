import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rentycars_nour/screens/home_page.dart'; // Import your home page

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
      Navigator.pushReplacementNamed(context, '/');
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
            // You can replace this with your app logo
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40,
              child: Icon(Icons.car_repair, size: 40, color: Colors.blue), // Your logo or icon here
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
