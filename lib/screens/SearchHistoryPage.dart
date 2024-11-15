import 'package:flutter/material.dart';

class SearchHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data for search history
    final List<String> searchHistory = [
      'Toyota Corolla',
      'Mercedes-Benz C-Class',
      'Jeep Wrangler',
      'BMW X5',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Historique de Recherche'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: searchHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(searchHistory[index]),
            onTap: () {
              // You can implement a search action or re-search the selected query
            },
          );
        },
      ),
    );
  }
}
