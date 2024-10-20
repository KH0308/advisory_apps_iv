import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/toast_bar_widget.dart';

class DatabaseService {
  ToastBarWidget toastBarWidget = ToastBarWidget();
  final String baseUrl = 'http://interview.advisoryapps.com/index.php';
  final storage = const FlutterSecureStorage();

  // Future<Map<String, dynamic>> authSignIn(String email, String password) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/login'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       'email': email,
  //       'password': password,
  //     }),
  //   );

  //   final responseBody = json.decode(response.body);

  //   if (responseBody['status']['code'] == 200) {
  //     debugPrint('${responseBody['status']['message']} 200');

  //     await storage.write(key: 'idToken', value: responseBody['id']);
  //     await storage.write(key: 'token', value: responseBody['token']);

  //     return responseBody;
  //   } else if (responseBody['status']['code'] == 400) {
  //     debugPrint('${responseBody['status']['message']} 400');
  //     // debugPrint(responseBody['status']['code']);
  //     return responseBody;
  //   } else if (response.statusCode == 404 || response.statusCode == 500) {
  //     debugPrint('${responseBody['status']['message']} 404/500');
  //     return responseBody;
  //   } else {
  //     throw Exception('Failed to sign in');
  //   }
  // }

  Future<Map<String, dynamic>> authSignIn(String email, String password) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/login'));

      // Add form data fields
      request.fields['email'] = email;
      request.fields['password'] = password;

      // Add headers if needed
      request.headers.addAll({
        'Content-Type':
            'multipart/form-data', // Inform the server you're sending form data
      });

      // Send the request
      var streamedResponse = await request.send();

      // Get the response as a string
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response body
      final responseBody = json.decode(response.body);

      if (responseBody['status']['code'] == 200) {
        debugPrint('${responseBody['status']['message']} 200');

        await storage.write(key: 'id', value: responseBody['status']['id']);
        await storage.write(
            key: 'token', value: responseBody['status']['token']);

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

  // Future<Map<String, dynamic>> fetchListData() async {
  //   final String token = await storage.read(key: 'token') ?? '';
  //   final String idToken = await storage.read(key: 'id') ?? '';

  //   final response = await http
  //       .get(Uri.parse('$baseUrl/listing?id=$idToken&token=$token'), headers: {
  //     'Content-Type': 'application/json',
  //   });

  //   final responseBody = json.decode(response.body);

  //   if (responseBody['status']['code'] == 200) {
  //     return responseBody;
  //   } else if (responseBody['status']['code'] == 400) {
  //     debugPrint('Invalid Token');
  //     return responseBody;
  //   } else if (response.statusCode == 404 || response.statusCode == 500) {
  //     debugPrint('Page Not Found or Server down');
  //     return responseBody;
  //   } else {
  //     throw Exception('Failed to load novels');
  //   }
  // }

  Future<Map<String, dynamic>> fetchListData() async {
    try {
      final String token = await storage.read(key: 'token') ?? '';
      final String idToken = await storage.read(key: 'id') ?? '';

      // Ensure that token and idToken are available
      if (token.isEmpty || idToken.isEmpty) {
        throw Exception('Missing token or ID');
      }

      // Build the URL with query parameters
      final url = Uri.parse('$baseUrl/listing?id=$idToken&token=$token');

      // Send the GET request
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      // Parse the response body
      final responseBody = json.decode(response.body);

      // Handle the response based on status code
      if (responseBody['status']['code'] == 200) {
        return responseBody;
      } else if (responseBody['status']['code'] == 400) {
        debugPrint('Invalid Token');
        return responseBody;
      } else if (response.statusCode == 404 || response.statusCode == 500) {
        debugPrint('Page Not Found or Server down');
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
