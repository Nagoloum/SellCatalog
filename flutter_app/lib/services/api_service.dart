import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/user.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // Android emulator: http://10.0.2.2:5000
  // Desktop/web or iOS simulator: http://localhost:5000
  static const String baseUrl = 'http://localhost:5000';

  final http.Client _client;

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Identifiants invalides');
    }

    return AppUser.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Product>> fetchProducts() async {
    final response = await _client.get(Uri.parse('$baseUrl/api/produits'));

    if (response.statusCode != 200) {
      throw Exception('Impossible de charger les produits');
    }

    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
