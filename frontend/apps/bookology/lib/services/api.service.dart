import 'dart:convert';

import 'package:bookology/models/book.model.dart';
import 'package:bookology/models/notification.model.dart';
import 'package:bookology/models/user.model.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final cacheStorage = GetStorage();
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
        return true;
      } else {
        print(message);
        return message;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<UserModel?> getUserProfile({required String userID}) async {
    try {
      final requestURL = Uri.parse('$apiURL/users/$userID?with_books=true');
      final request = await client.get(
        requestURL,
        headers: <String, String>{
          'user-identifier-key': await _firestoreService.getAccessToken()
        },
      );
      final response = jsonDecode(request.body);
      final cacheData = jsonDecode(request.body);

      cacheService.setCurrentUser(
          userName: cacheData['user_information']['username'],
          isVerified: cacheData['user_information']['verified']);
      final userData = UserModel.fromJson(response);
      return userData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<List<BookModel>?> getBooks() async {
    try {
      final requestURL = Uri.parse('$apiURL/books/');
      final request = await client.get(
        requestURL,
        headers: <String, String>{
          'user-identifier-key': await _firestoreService.getAccessToken()
        },
      );
      final Iterable response = jsonDecode(request.body);

      final books = List<BookModel>.from(
        response
            .map(
              (book) => BookModel.fromJson(book),
            )
            .toList(),
      );
      return books;
    } catch (error) {
      print(error);
      return null;
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
      print('data is $receivedData');
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

  Future<List<NotificationModel>?> getUserNotifications() async {
    try {
      final requestURL = Uri.parse('$apiURL/notifications');
      final request = await http.get(
        requestURL,
        headers: {
          'user-identifier-key': await _firestoreService.getAccessToken(),
          'Content-type': 'application/json',
        },
      );
      final Iterable response = jsonDecode(request.body);
      if (request.statusCode == 200) {
        final notifications = List<NotificationModel>.from(
          response
              .map(
                (notification) => NotificationModel.fromJson(notification),
              )
              .toList(),
        );

        return notifications;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<dynamic> sendEnquiryNotification(
      {required String userID,
      required String receiverID,
      required String userName}) async {
    try {
      final requestURL = Uri.parse(
          '${apiURL}/notifications/send?type=book_enquiry_notification');
      final request = await http.post(
        requestURL,
        headers: {
          'access-key': apiToken.toString(),
          'user-identifier-key': await _firestoreService.getAccessToken(),
          'receiver-user-id': receiverID,
          'sender-user-id': userID,
          'sender-username': userName,
          'Content-type': 'application/json',
        },
        body: jsonEncode(
          {},
        ),
      );
      final response = jsonDecode(request.body);
      if (response['result']['status_code'] == 200) {
        return true;
      }
      return false;
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
