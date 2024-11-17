import 'package:flutter/material.dart';
import 'package:rentycars_nour/admin/add_car_page.dart';
import 'package:rentycars_nour/admin/manage_cars_page.dart';
import 'package:rentycars_nour/admin/admin_dashboard.dart';  // Ensure it's correctly imported

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/admin/add_car':
              return MaterialPageRoute(builder: (_) => AddCarPage());
            case '/admin/manage_cars':
              return MaterialPageRoute(builder: (_) => ManageCarsPage());
            default:
              return MaterialPageRoute(builder: (_) => AdminDashboardPage()); // Default Admin Dashboard
          }
        },
      ),
    );
  }
}
