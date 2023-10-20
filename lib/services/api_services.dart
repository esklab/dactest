import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/userModel.dart';

class RandomUser {
  static const apiUrl = "https://randomuser.me/api/";

  Future<List<User>?> fetchUserData() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?results=100'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'];
        if (results is List) {
          return results.map((user) => User.cast(user)).toList();
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }
}