import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  // Récupérer un commentaire spécifique (exemple d'API)
  Future<Map<String, dynamic>> getRequest() async {
    var res = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts/2"));
    var decodedData = json.decode(res.body);
    return decodedData;
  }

  // Récupérer la liste des commentaires pour un post
  Future<List<Map<String, dynamic>>> getComments(String postId) async {
    final res = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts/1/comments"));
    return List<Map<String, dynamic>>.from(json.decode(res.body));
  }

  // Ajouter un commentaire (notez que JSONPlaceholder est une API fictive, donc cette action ne persiste pas réellement)
  Future<void> addComment(String postId, String name, String email, String body) async {
    final response = await http.post(
      Uri.parse("https://jsonplaceholder.typicode.com/comments"),
      body: json.encode({
        "postId": postId,
        "name": name,
        "email": email,
        "body": body,
      }),
    );
    if (response.statusCode == 201) {
      print("Comment added successfully");
    } else {
      throw Exception('Failed to add comment');
    }
  }
}




