import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/toast_bar_widget.dart';

class DatabaseService {
  ToastBarWidget toastBarWidget = ToastBarWidget();
  final String baseUrl = 'http://interview.advisoryapps.com/index.php';
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> authSignIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final responseBody = json.decode(response.body);

    if (responseBody['status']['code'] == 200) {
      debugPrint(responseBody['status']['message']);

      await storage.write(key: 'idToken', value: responseBody['id']);
      await storage.write(key: 'token', value: responseBody['token']);

      return responseBody;
    } else if (responseBody['status']['code'] == 400) {
      debugPrint(responseBody['status']['message']);
      return responseBody;
    } else if (response.statusCode == 404 || response.statusCode == 500) {
      debugPrint(responseBody['status']['message']);
      return responseBody;
    } else {
      throw Exception('Failed to sign in');
    }
  }

  Future<Map<String, dynamic>> fetchListData() async {
    final String token = await storage.read(key: 'token') ?? '';
    final String idToken = await storage.read(key: 'idToken') ?? '';

    final response = await http
        .get(Uri.parse('$baseUrl/listing?id=$idToken&token=$token'), headers: {
      'Content-Type': 'application/json',
    });

    final responseBody = json.decode(response.body);

    if (responseBody['status']['code'] == 200) {
      return responseBody;
    } else if (responseBody['status']['code'] == 400) {
      debugPrint('Invalid Token');
      return responseBody;
    } else if (response.statusCode == 404 || response.statusCode == 500) {
      debugPrint('Page Not Found or Server down');
      return responseBody;
    } else {
      throw Exception('Failed to load novels');
    }
  }
}
