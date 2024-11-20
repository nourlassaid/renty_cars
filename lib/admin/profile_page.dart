import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white, 
         actions: [
          // Notification Icon in AppBar
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon tap (e.g., navigate to a notifications page)
              print("Notification icon tapped");
            },
          ),
        ],// Make the app bar more vibrant
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                children: [
                  // Profile picture with a border and shadow
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(
                        'assets/profile_picture.png'), // Profile picture placeholder
                    backgroundColor: Colors.grey[200],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // Add functionality to change the profile picture
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Name text with larger font size and bold
            Text(
              "John Doe",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            // Email with smaller and lighter font
            Text(
              "johndoe@example.com",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            // Buttons for updating info and logging out with improved spacing and styling
            ElevatedButton(
              onPressed: () {
                // Action to update information
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Update Info',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Action to log out
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Log Out',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
