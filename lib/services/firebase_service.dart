import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print("User created successfully");
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getCars() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('cars').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching cars: $e");
      return [];
    }
  }
}
