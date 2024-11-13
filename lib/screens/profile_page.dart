// TODO Implement this library.import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Settings action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://example.com/your-profile-picture.jpg', // replace with actual profile image URL or asset
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Aymen Missaoui', // replace with user name
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Djerba houmet essaouk', // replace with user location
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            ToggleButtons(
              borderColor: Colors.grey,
              selectedBorderColor: Colors.orange,
              borderRadius: BorderRadius.circular(20),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('My Cars'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Bookings'),
                ),
              ],
              isSelected: [true, false], // Default selection
              onPressed: (int index) {
                // Toggle button functionality
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileOption(
                    icon: Icons.info_outline,
                    title: 'Personal info',
                    subtitle: 'Provide personal details and how we can reach you',
                  ),
                  _buildProfileOption(
                    icon: Icons.car_rental,
                    title: 'List Your Car',
                    subtitle: 'List your car for rent and start earning',
                  ),
                  _buildProfileOption(
                    icon: Icons.verified_user_outlined,
                    title: 'Verify your account',
                    subtitle: 'Verify your identity for better trust',
                  ),
                  _buildProfileOption(
                    icon: Icons.campaign_outlined,
                    title: 'Promote your car',
                    subtitle: 'Boost your car listing to reach more renters',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // Profile tab index
        onTap: (index) {
          // Handle navigation to different pages
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  Widget _buildProfileOption({required IconData icon, required String title, required String subtitle}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: () {
          // Add navigation or actions here
        },
      ),
    );
  }
}
