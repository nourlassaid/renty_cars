import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_stats.dart';

class DashboardService {
  Future<DashboardStats> fetchDashboardStats() async {
    final response = await http.get(Uri.parse('https://api.example.com/stats'));

    if (response.statusCode == 200) {
      return DashboardStats.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load dashboard stats');
    }
  }
}
