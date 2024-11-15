import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ApiServices{

  getRequest() async {
    var res = await get(Uri.parse("https://jsonplaceholder.typicode.com/posts/2"));
    var decodedData = json.decode(res.body);
    print(decodedData);
  }
  getComments() async {
    final res = await get(Uri.parse("https://jsonplaceholder.typicode.com/posts/1/comments"));
    return json.decode(res.body);
    
  }
}



