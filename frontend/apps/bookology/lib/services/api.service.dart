/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the
 *  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is furnished
 *  to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 *  or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'dart:convert';

import 'package:bookology/managers/secrets.manager.dart';
import 'package:bookology/models/book.model.dart' as book;
import 'package:bookology/models/book.model.dart';
import 'package:bookology/models/notification.model.dart' as notification;
import 'package:bookology/models/notification.model.dart';
import 'package:bookology/models/room.model.dart';
import 'package:bookology/models/user.model.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

class ApiService {
  final _firestoreService = FirestoreService(FirebaseFirestore.instance);
  final _cacheService = PreferencesManager();
  final SecretsManager _secretsManager = SecretsManager();
  final client = http.Client();

  Future<dynamic> createUser({
    required String? uuid,
    required String? email,
    required String? profilePhotoUrl,
    required String? firstName,
    required String? lastName,
    required String? authProvider,
  }) async {
    try {
      final String? apiURL = await _secretsManager.getApiUrl();
      final String? apiKey = await _secretsManager.getApiKey();
      final requestURL =
          Uri.parse('$apiURL/auth/signup?auth_provider=$authProvider');

      final response = await client.post(
        requestURL,
        headers: {
          "access-key": apiKey.toString(),
        },
        body: {
          "id": uuid,
          "username": email.toString().split('@')[0],
          "email": email,
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
        return message;
      }
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<UserModel?> getUserProfile({required String userID}) async {
    try {
      final String? apiURL = await _secretsManager.getApiUrl();
      final requestURL =
          Uri.parse('$apiURL/users/uuid/$userID?with_books=true');
      final request = await client.get(
        requestURL,
        headers: <String, String>{
          'user-identifier-key': await _firestoreService.getAccessToken()
        },
      );
      final response = jsonDecode(request.body);
      _cacheService.setCurrentUser(
          userName: response['user_information']['username'],
          isVerified: response['user_information']['verified']);
      if (request.statusCode == 200) {
        return UserModel.fromJson(response);
      }
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<List<BookModel>?> getBooks() async {
    try {
      final String? apiURL = await _secretsManager.getApiUrl();
      final requestURL = Uri.parse('$apiURL/books/');
      final request = await client.get(
        requestURL,
        headers: <String, String>{
          'user-identifier-key': await _firestoreService.getAccessToken()
        },
      );
      final Iterable response = jsonDecode(request.body);
      if (request.statusCode == 200) {
        final books = List<BookModel>.from(
          response.map(
            (notification) {
              return BookModel.fromJson(notification);
            },
          ),
        );

        return books;
      }
    } catch (error, stackTrace) {
      client.close();
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<List<BookModel>?> getSavedBooks() async {
    try {
      final String? apiURL = await _secretsManager.getApiUrl();
      final requestURL = Uri.parse('$apiURL/users/saved');
      final request = await client.get(
        requestURL,
        headers: <String, String>{
          'user-identifier-key': await _firestoreService.getAccessToken()
        },
      );

      if (request.statusCode == 200) {
        final Iterable response = jsonDecode(request.body);
        final books = List<BookModel>.from(
          response.map(
            (notification) {
              return BookModel.fromJson(notification);
            },
          ),
        );

        return books;
      }
      return [
        BookModel(
          bookId: 'Nil Book ID',
          bookInformation: BookInformation(
            isbn: '',
            name: '',
            author: '',
            publisher: '',
          ),
          additionalInformation: book.AdditionalInformation(
            description: '',
            condition: '',
            categories: [],
            imagesCollectionId: '',
            images: [],
          ),
          pricing: Pricing(
            originalPrice: '',
            sellingPrice: '',
            currency: '',
          ),
          createdOn: book.CreatedOn(
            date: '',
            time: '',
          ),
          slugs: book.Slugs(
            name: '',
          ),
          uploader: Uploader(
            userId: '',
            username: '',
            verified: false,
            profilePictureUrl: '',
            firstName: '',
            lastName: '',
          ),
          location: '',
        )
      ];
    } catch (error, stackTrace) {
      client.close();
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<dynamic> getBookByID({required String bookID}) async {
    try {
      final String? apiURL = await _secretsManager.getApiUrl();
      final requestURL = Uri.parse('$apiURL/books/$bookID');
      final response = await client.get(
        requestURL,
        headers: <String, String>{
          'user-identifier-key': await _firestoreService.getAccessToken()
        },
      );
      return jsonDecode(response.body);
    } catch (error, stackTrace) {
      client.close();
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> deleteBook({required String bookID}) async {
    try {
      final String? apiURL = await _secretsManager.getApiUrl();
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
      }
      return false;
    } catch (error, stackTrace) {
      client.close();
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> postBookData({
    required String isbn,
    required String bookName,
    required String bookAuthor,
    required String bookPublisher,
    required String bookDescription,
    required String bookOriginalPrice,
    required String bookSellingPrice,
    required String bookCondition,
    required String bookImage1,
    required String bookImage2,
    required String bookImage3,
    required String bookImage4,
    required String bookCurrency,
    required String bookImagesCollectionId,
    required String bookLocation,
  }) async {
    try {
      final String? apiURL = await _secretsManager.getApiUrl();
      final requestURL = Uri.parse('$apiURL/books/publish');
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
            "categories": ['All'],
            "original_price": bookOriginalPrice,
            "selling_price": bookSellingPrice,
            "currency": bookCurrency,
            "condition": bookCondition,
            "images_collection_id": bookImagesCollectionId,
            "images": [
              bookImage1,
              bookImage2,
              bookImage3,
              bookImage4,
            ],
            "location": bookLocation
          },
        ),
      );
      final statusCode = jsonDecode(response.body)['result']['status_code'];
      if (statusCode == 201) {
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      client.close();
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<List<NotificationModel>?> getUserNotifications() async {
    try {
      final String? apiURL = await _secretsManager.getApiUrl();
      final requestURL = Uri.parse('$apiURL/notifications');
      final request = await http.get(
        requestURL,
        headers: {
          'user-identifier-key': await _firestoreService.getAccessToken(),
          'Content-type': 'application/json',
        },
      );
      if (request.statusCode == 200 &&
          jsonDecode(request.body).toString().contains('No Notifications.')) {
        return [
          NotificationModel(
            notificationId: 'null',
            metadata: Metadata(
              bookId: 'null',
              receiverId: 'null',
              senderId: 'null',
            ),
            notification: Notification(
              body: 'null',
              seen: false,
              title: 'null',
              type: 'null',
            ),
            createdOn: notification.CreatedOn(
              date: 'null',
              time: 'null',
            ),
          )
        ];
      }
      final Iterable response = jsonDecode(request.body) as Iterable;
      if (request.statusCode == 200) {
        final notifications = List<NotificationModel>.from(
          response.map(
            (notification) {
              return NotificationModel.fromJson(notification);
            },
          ),
        );

        return notifications;
      }
    } catch (error, stackTrace) {
      client.close();
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> sendEnquiryNotification({
    required String userID,
    required String receiverID,
    required String bookId,
    required String userName,
  }) async {
    try {
      final String? apiURL = await _secretsManager.getApiUrl();
      final String? apiKey = await _secretsManager.getApiKey();
      final requestURL = Uri.parse(
          '$apiURL/notifications/send?type=book_enquiry_notification');
      final request = await http.post(
        requestURL,
        headers: {
          'access-key': apiKey.toString(),
          'user-identifier-key': await _firestoreService.getAccessToken(),
          'receiver-user-id': receiverID,
          'sender-user-id': userID,
          'sender-username': userName,
          'Content-type': 'application/json',
        },
        body: jsonEncode(
          {
            "book_id": bookId,
            "room_icon": "lops"
          },
        ),
      );
      final response = jsonDecode(request.body);
      if (response['result']['status_code'] == 200) {
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      client.close();
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> updateUserProfile({
    required String userID,
    required String userName,
    required bool? isVerified,
    required String firstName,
    required String lastName,
    required String bio,
    required String profilePicture,
  }) async {
    try {
      final String? apiURL = await _secretsManager.getApiUrl();
      final requestURL = Uri.parse('$apiURL/users/uuid/$userID');
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
      if (receivedData['result']['status_code'] == 200) {
        await FirebaseAuth.instance.currentUser!
            .updateDisplayName('$firstName $lastName');
        await FirebaseAuth.instance.currentUser!.updatePhotoURL(profilePicture);
        _cacheService.setCurrentUser(
            userName: userName, isVerified: isVerified);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      client.close();
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> createRoom({required RoomModel room}) async {
    try {
      final String? apiURL = await _secretsManager.getApiUrl();
      final requestURL = Uri.parse('$apiURL/rooms/create/');
      final response = await client.post(
        requestURL,
        headers: <String, String>{
          'user-identifier-key': await _firestoreService.getAccessToken(),
          'Content-type': 'application/json',
        },
        body: jsonEncode(
          {
            "book_id": room.bookId,
            "notification_id": room.notificationId,
            "title": room.title,
            "room_icon": room.roomIcon,
            "users": room.users,
          },
        ),
      );
      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      client.close();
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
