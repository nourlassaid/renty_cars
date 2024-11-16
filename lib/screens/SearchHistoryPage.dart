import 'package:flutter/material.dart';

class SearchHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Exemple de données pour l'historique de recherche
    final List<String> searchHistory = [
      'Toyota Corolla',
      'Mercedes-Benz C-Class',
      'Jeep Wrangler',
      'BMW X5',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historique de Recherche',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vos recherches récentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: searchHistory.isEmpty
                  ? Center(
                      child: Text(
                        'Aucun historique de recherche disponible.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: searchHistory.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                          child: ListTile(
                            leading: Icon(
                              Icons.history,
                              color: Colors.blue,
                            ),
                            title: Text(
                              searchHistory[index],
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 16,
                            ),
                            onTap: () {
                              // Implémentez une action pour effectuer une nouvelle recherche
                              print('Recherche sélectionnée : ${searchHistory[index]}');
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
