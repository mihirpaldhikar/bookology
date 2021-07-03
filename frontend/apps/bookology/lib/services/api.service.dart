import 'dart:convert';

import 'package:bookology/services/firestore.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final apiURL = dotenv.env['API_URL'];
  final apiToken = dotenv.env['API_TOKEN'];
  final _fireUser = FirebaseAuth.instance.currentUser;
  final _firestoreService = new FirestoreService(FirebaseFirestore.instance);
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
      final requestURL =
          Uri.parse('$apiURL/auth/signup?auth_provider=$authProvider');

      final response = await client.post(
        requestURL,
        headers: {
          "access-key": apiToken.toString(),
        },
        body: {
          "id": uuid,
          "username": email.toString().split('@')[0],
          "email": email,
          "password": password,
          "profile_picture_url": profilePhotoUrl,
          "first_name": firstName,
          "last_name": lastName,
        },
      );
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

  Future<dynamic> userInfo() async {
    try {
      final requestURL = Uri.parse('$apiURL/user/${_fireUser!.uid}');

      final response = await client.get(
        requestURL,
        headers: <String, String>{'access-token': apiToken.toString()},
      );

      final statusCode = jsonDecode(response.body)['result']['status_code'];
      final message = jsonDecode(response.body)['result']['message'];
      if (statusCode == 201) {
        return true;
      } else {
        print(message);
        return message;
      }
    } catch (error) {
      print(error);
      return error;
    }
  }

  Future<dynamic> postBookData() async {
    try {
      final requestURL = Uri.parse('${apiURL}/books/publish');
      final response = await http.post(requestURL, headers: {
        'user-identifier-key': await _firestoreService.getAccessToken()
      }, body: {
        "isbn": '1234567',
        "book_name": 'bookName',
        "orignal_price": '1234',
        "current_price": '1234',
        "book_condition": 'bookCondition',
        "book_image_url": "https://google.com",
        "is_used": 'true'
      });
      print(response.body);
    } catch (error) {
      print(error);
      return error;
    }
  }
}
