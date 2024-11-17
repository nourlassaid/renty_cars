import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des utilisateurs"),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Aucun utilisateur trouvé"));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    user['name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    user['email'],
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.blueAccent),
                    onSelected: (value) {
                      switch (value) {
                        case 'accept':
                          _acceptUser(user.id);
                          break;
                        case 'reject':
                          _rejectUser(user.id);
                          break;
                        case 'block':
                          _blockUser(user.id);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'accept',
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Accepter', style: TextStyle(color: Colors.green)),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'reject',
                          child: Row(
                            children: [
                              Icon(Icons.cancel, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Refuser', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'block',
                          child: Row(
                            children: [
                              Icon(Icons.block, color: Colors.grey),
                              SizedBox(width: 8),
                              Text('Bloquer', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Logic to accept a user
  Future<void> _acceptUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'status': 'accepted',
      });
      print('User accepted');
    } catch (e) {
      print('Error accepting user: $e');
    }
  }

  // Logic to reject a user
  Future<void> _rejectUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'status': 'rejected',
      });
      print('User rejected');
    } catch (e) {
      print('Error rejecting user: $e');
    }
  }

  // Logic to block a user
  Future<void> _blockUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'status': 'blocked',
      });
      print('User blocked');
    } catch (e) {
      print('Error blocking user: $e');
    }
  }
}
