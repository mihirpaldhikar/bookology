import 'dart:convert';

import 'package:bookology/services/cache.service.dart';
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
  final cacheService = CacheService();
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
        await _firestoreService.uploadFCMToken();
        return true;
      } else {
        print(message);
        return message;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> getUserProfile({required String userID}) async {
    try {
      final requestURL = Uri.parse('$apiURL/users/$userID?with_books=true');
      final response = await client.get(
        requestURL,
        headers: <String, String>{
          'user-identifier-key': await _firestoreService.getAccessToken()
        },
      );
      final receivedData = jsonDecode(response.body);

      cacheService.setCurrentUser(
          userName: receivedData['user_information']['username'],
          isVerified: receivedData['user_information']['verified']);

      return receivedData;
    } catch (error) {
      print(error);
      return error;
    }
  }

  Future<dynamic> getBooks() async {
    try {
      final requestURL = Uri.parse('$apiURL/books/');
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

  Future<dynamic> getBookByID({required String bookID}) async {
    try {
      final requestURL = Uri.parse('$apiURL/books/$bookID');
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

  Future<dynamic> deleteBook({required String bookID}) async {
    try {
      final requestURL = Uri.parse('$apiURL/books/delete/$bookID');
      final response = await client.delete(
        requestURL,
        headers: <String, String>{
          'Content-type': 'application/json',
          'user-identifier-key': await _firestoreService.getAccessToken(),
        },
      );

      final receivedData = jsonDecode(response.body);
      if (receivedData['result']['status_code'] == 200) {
        return true;
      } else {
        return receivedData;
      }
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
    required String location,
    required String imagesCollectionID,
    required String imageDownloadURL1,
    required String imageDownloadURL2,
    required String imageDownloadURL3,
    required String imageDownloadURL4,
  }) async {
    try {
      final requestURL = Uri.parse('${apiURL}/books/publish');
      final response = await http.post(
        requestURL,
        headers: {
          'user-identifier-key': await _firestoreService.getAccessToken(),
          'Content-type': 'application/json',
        },
        body: jsonEncode(
          {
            "isbn": isbn,
            "name": bookName,
            "author": bookAuthor,
            "publisher": bookPublisher,
            "description": bookDescription,
            "original_price": originalPrice,
            "selling_price": sellingPrice,
            "condition": bookCondition,
            "images_collection_id": imagesCollectionID,
            "images": [
              imageDownloadURL1.toString(),
              imageDownloadURL2.toString(),
              imageDownloadURL3.toString(),
              imageDownloadURL4.toString(),
            ],
            "location": location
          },
        ),
      );
      final statusCode = jsonDecode(response.body)['result']['status_code'];
      if (statusCode == 201) {
        return true;
      }
    } catch (error) {
      print(error);
      return error;
    }
  }

  Future<dynamic> updateUserProfile({
    required String userID,
    required String userName,
    required String firstName,
    required String lastName,
    required String bio,
    required String profilePicture,
  }) async {
    try {
      final requestURL = Uri.parse('$apiURL/users/$userID');
      final response = await client.put(
        requestURL,
        headers: <String, String>{
          'user-identifier-key': await _firestoreService.getAccessToken(),
          'Content-type': 'application/json',
        },
        body: jsonEncode(
          {
            "username": userName,
            "bio": bio,
            "profile_picture_url": profilePicture,
            "first_name": firstName,
            "last_name": lastName,
          },
        ),
      );
      final receivedData = jsonDecode(response.body);
      cacheService.setCurrentUser(userName: userName);
      if (receivedData['result']['status_code'] == 200) {
        return true;
      }
    } catch (error) {
      print(error);
      return error;
    }
  }
}
