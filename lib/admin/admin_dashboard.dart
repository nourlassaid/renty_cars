// lib/admin/admin_dashboard.dart
import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
      ),
      body: Center(
        child: Text("Welcome to the Admin Dashboard"),
      ),
    );
  }
}
