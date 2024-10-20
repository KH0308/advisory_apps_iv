import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../widgets/toast_bar_widget.dart';

class DatabaseService {
  ToastBarWidget toastBarWidget = ToastBarWidget();
  final String baseUrl = 'http://interview.advisoryapps.com/index.php';

  Future<Map<String, dynamic>> authSignIn(String email, String password) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/login'));

      request.fields['email'] = email;
      request.fields['password'] = password;

      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
      });

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      final responseBody = json.decode(response.body);

      if (responseBody['status']['code'] == 200) {
        debugPrint('${responseBody['status']['message']} 200');

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('id', responseBody['id']);
        prefs.setString('token', responseBody['token']);

        return responseBody;
      } else if (responseBody['status']['code'] == 400) {
        debugPrint('${responseBody['status']['message']} 400');
        return responseBody;
      } else if (response.statusCode == 404 || response.statusCode == 500) {
        debugPrint('${responseBody['status']['message']} 404/500');
        return responseBody;
      } else {
        throw Exception('Failed to sign in');
      }
    } catch (e) {
      debugPrint('Error signing in: $e');
      throw Exception('Error signing in');
    }
  }

  Future<Map<String, dynamic>> authSignInFB(
      String email, String password, String picFB) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/login'));

      request.fields['email'] = email;
      request.fields['password'] = password;

      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
      });

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      final responseBody = json.decode(response.body);

      if (responseBody['status']['code'] == 200) {
        debugPrint('${responseBody['status']['message']} 200');

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('id', responseBody['id']);
        prefs.setString('token', responseBody['token']);
        prefs.setString('picFB', picFB);

        return responseBody;
      } else if (responseBody['status']['code'] == 400) {
        debugPrint('${responseBody['status']['message']} 400');
        return responseBody;
      } else if (response.statusCode == 404 || response.statusCode == 500) {
        debugPrint('${responseBody['status']['message']} 404/500');
        return responseBody;
      } else {
        throw Exception('Failed to sign in');
      }
    } catch (e) {
      debugPrint('Error signing in: $e');
      throw Exception('Error signing in');
    }
  }

  Future<Map<String, dynamic>> fetchListData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String idStore = prefs.getString('id') ?? '';
      final String tokenStore = prefs.getString('token') ?? '';

      final url = Uri.parse('$baseUrl/listing?id=$idStore&token=$tokenStore');

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      final responseBody = json.decode(response.body);

      if (responseBody['status']['code'] == 200) {
        debugPrint('$responseBody');
        return responseBody;
      } else if (responseBody['status']['code'] == 400) {
        debugPrint('Invalid Token');
        debugPrint('$responseBody');
        return responseBody;
      } else if (response.statusCode == 404 || response.statusCode == 500) {
        debugPrint('Page Not Found or Server down');
        debugPrint('$responseBody');
        return responseBody;
      } else {
        throw Exception('Failed to load list data');
      }
    } catch (e) {
      debugPrint('Error fetching list data: $e');
      throw Exception('Error fetching list data');
    }
  }
}
