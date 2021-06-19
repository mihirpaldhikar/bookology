import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final apiURL = dotenv.env['API_URL'];
  final apiToken = dotenv.env['API_TOKEN'];

  final client = http.Client();

  Future<dynamic> createUser({
    required String? uuid,
    required String? email,
    required String? password,
    required String? profilePhotoUrl,
    required String? firstName,
    required String? lastName,
    required String? authProvider,
  }) async {
    try {
      final requestURL = Uri.parse(
          '$apiURL/auth/signup?token=$apiToken&auth_provider=$authProvider');

      final response = await client.post(requestURL, body: {
        "id": uuid,
        "username": email.toString().split('@')[0],
        "email": email,
        "password": password,
        "profile_picture_url": profilePhotoUrl,
        "first_name": firstName,
        "last_name": lastName,
      });
      final statusCode = jsonDecode(response.body)['result']['status_code'];
      final message = jsonDecode(response.body)['result']['message'];
      if (statusCode == 201) {
        return true;
      } else {
        print(message);
        return message;
      }
    } catch (error) {
      throw error;
    }
  }
}
