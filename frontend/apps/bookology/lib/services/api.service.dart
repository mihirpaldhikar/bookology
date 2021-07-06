import 'dart:convert';

import 'package:bookology/services/firestore.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
      SharedPreferences userPrefs = await SharedPreferences.getInstance();

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
        userPrefs.setString('username', email.toString().split('@')[0]);
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
      SharedPreferences userPrefs = await SharedPreferences.getInstance();

      final requestURL = Uri.parse(
          '$apiURL/users/${userPrefs.getString('username')}?with_books=true');
      final response = await client.get(
        requestURL,
        headers: <String, String>{
          'user-identifier-key': await _firestoreService.getAccessToken()
        },
      );
      return jsonDecode(response.body);
    } catch (error) {
      print(error);
      return error;
    }
  }

  Future<dynamic> postBookData({
    required String isbn,
    required String bookName,
    required String bookAuthor,
    required String bookPublisher,
    required String bookDescription,
    required String originalPrice,
    required String sellingPrice,
    required String bookCondition,
  }) async {
    try {
      final requestURL = Uri.parse('${apiURL}/books/publish');
      final response = await http.post(requestURL, headers: {
        'user-identifier-key': await _firestoreService.getAccessToken()
      }, body: {
        "isbn": isbn,
        "book_name": bookName,
        "book_author": bookAuthor,
        "book_publisher": bookPublisher,
        "description": bookDescription,
        "original_price": originalPrice,
        "selling_price": sellingPrice,
        "book_condition": bookCondition,
        "book_images_urls": "https://google.com",
      });
      print(response.body);
    } catch (error) {
      print(error);
      return error;
    }
  }
}
