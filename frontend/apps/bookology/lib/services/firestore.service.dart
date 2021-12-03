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

import 'dart:developer';

import 'package:bookology/models/app.model.dart';
import 'package:bookology/models/request.model.dart';
import 'package:bookology/models/saved_book.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class FirestoreService {
  final cacheStorage = GetStorage();
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirestoreService(this._firestore);

  Future<String> getAccessToken() async {
    try {
      final data = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid)
          .get();

      final userKey = await data.data()?['secrets']['authorizeToken'];
      if (cacheStorage.read('userIdentifierKey') == null) {
        cacheStorage.write('userIdentifierKey', userKey);
      }
      return cacheStorage.read('userIdentifierKey');
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<types.User> getFirestoreUser({required String userID}) async {
    try {
      final doc = await _firestore.collection('users').doc(userID).get();
      final data = doc.data();
      data!['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
      data['id'] = doc.id;
      data['lastSeen'] = data['lastSeen']?.millisecondsSinceEpoch;
      data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;
      return types.User.fromJson(data);
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> clearDiscussionsChat({required String roomID}) async {
    try {
      final messages =
          _firestore.collection('rooms').doc(roomID).collection('messages');

      var snapshots = await messages.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> unsendMessage(
      {required String messageType,
      required String messageID,
      required String mediaURL,
      required String roomID}) async {
    try {
      if (messageType == 'MessageType.file') {
        await _firestore
            .collection('rooms')
            .doc(roomID)
            .collection('messages')
            .doc(messageID)
            .delete();
        await FirebaseStorage.instance.refFromURL(mediaURL).delete();
        return false;
      }
      if (messageType == 'MessageType.image') {
        await _firestore
            .collection('rooms')
            .doc(roomID)
            .collection('messages')
            .doc(messageID)
            .delete();
        await FirebaseStorage.instance.refFromURL(mediaURL).delete();
        return false;
      }
      if (messageType == 'MessageType.text') {
        await _firestore
            .collection('rooms')
            .doc(roomID)
            .collection('messages')
            .doc(messageID)
            .delete();

        return false;
      }
      return true;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  void sendMessage(
      dynamic partialMessage, String roomId, String collectionID) async {
    if (_firebaseAuth.currentUser == null) return;

    types.Message? message;

    if (partialMessage is types.PartialFile) {
      message = types.FileMessage.fromPartial(
        author: types.User(id: _firebaseAuth.currentUser!.uid),
        id: '',
        partialFile: partialMessage,
        roomId: roomId,
        status: types.Status.seen,
      );
    } else if (partialMessage is types.PartialImage) {
      message = types.ImageMessage.fromPartial(
        author: types.User(id: _firebaseAuth.currentUser!.uid),
        id: '',
        partialImage: partialMessage,
        roomId: roomId,
        status: types.Status.seen,
      );
    } else if (partialMessage is types.PartialText) {
      message = types.TextMessage.fromPartial(
        author: types.User(id: _firebaseAuth.currentUser!.uid),
        id: '',
        partialText: partialMessage,
        roomId: roomId,
        status: types.Status.seen,
      );
    }

    if (message != null) {
      final messageMap = message.toJson();
      messageMap.removeWhere((key, value) => key == 'author' || key == 'id');
      messageMap['authorId'] = _firebaseAuth.currentUser!.uid;
      messageMap['createdAt'] = FieldValue.serverTimestamp();
      messageMap['updatedAt'] = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('rooms/$roomId/messages')
          .add(messageMap);
    }
  }

  Future<void> deleteDiscussionRoom({required String discussionRoomID}) async {
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(discussionRoomID)
          .delete();
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> createRequest({
    required String bookID,
    required String userID,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('requests')
          .doc(bookID)
          .set(
        {'accepted': false, 'room_id': 'null'},
      );
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<RequestModel> getRequest({
    required String bookID,
    required String userID,
  }) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('requests')
          .doc(bookID)
          .get();

      if (data.data()?['accepted'] == null) {
        return RequestModel(accepted: false, roomId: 'null');
      }
      return RequestModel.fromJson(data.data()!);
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> isRequestExist({required String bookId}) async {
    final request = await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('requests')
        .doc(bookId)
        .get();

    return request.exists;
  }

  Future<types.Room> getRoomData({required String roomId}) async {
    try {
      final roomData =
          await _firestore.collection('rooms').doc(roomId).snapshots().first;
      return processRoomDocument(
        roomData,
        _firebaseAuth.currentUser!,
        'users',
      );
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> updateTheRoomUpdatedAt({required String roomId}) async {
    await _firestore.collection('rooms').doc(roomId).update({
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<AppModel> getServerSideAppDetails() async {
    final appDetails =
        await _firestore.collection('configs').doc('app_details').get();
    return AppModel.fromJson(appDetails.data()!);
  }

  Future<bool> saveBook({required String bookId}) async {
    try {
      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('saved')
          .doc(bookId)
          .set(
        {
          'bookId': bookId,
        },
      );

      return true;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> removedSavedBook({required String bookId}) async {
    await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('saved')
        .doc(bookId)
        .delete();
  }

  Future<List<SavedBookModel>> getSavedBook() async {
    final data = await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('saved')
        .get();
    final savedBooks = data.docs;
    final savedBookList = List<SavedBookModel>.from(
      savedBooks.map(
        (notification) {
          return SavedBookModel.fromJson(notification);
        },
      ),
    );

    log(savedBookList.length.toString());
    return savedBookList;
  }
}
