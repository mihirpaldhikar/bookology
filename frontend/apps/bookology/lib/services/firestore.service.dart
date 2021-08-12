import 'package:bookology/services/notification.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get_storage/get_storage.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final NotificationService _notificationService =
      NotificationService(FirebaseMessaging.instance);

  FirestoreService(this._firestore);

  Future<String> getAccessToken() async {
    try {
      final cacheStorage = GetStorage();
      final data = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid)
          .get();

      final userKey = data.data()?['secrets']['authorizeToken'];
      if (cacheStorage.read('userIdentifierKey') == null) {
        cacheStorage.write('userIdentifierKey', userKey);
      }
      return cacheStorage.read('userIdentifierKey');
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

  Future<dynamic> createFirestoreUser({
    required String uuid,
    required String firstName,
    required String lastName,
    required String profileImageURL,
  }) async {
    try {
      final data = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid)
          .set(
        {
          'firstName': firstName,
          'imageUrl': profileImageURL,
          'lastName': lastName,
          'lastSeen': null,
          'role': types.Role.user,
          'metadata': {
            'fcmToken': await _notificationService.getMessagingToken(),
          },
        },
        SetOptions(
          merge: true,
        ),
      );
      return data;
    } catch (error) {
      print(error);
      return error;
    }
  }

  Future<types.User> getFirestoreUser({required String userID}) async {
    try {
      final doc = await _firestore.collection('users').doc(userID).get();
      return processUserDocument(doc);
    } catch (error) {
      print(error);
      return types.User(id: '');
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
    } catch (error) {
      print(error);
      return false;
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
        metadata: {
          'collectionID': collectionID,
        },
        status: types.Status.seen,
      );
    } else if (partialMessage is types.PartialImage) {
      message = types.ImageMessage.fromPartial(
        author: types.User(id: _firebaseAuth.currentUser!.uid),
        id: '',
        partialImage: partialMessage,
        roomId: roomId,
        status: types.Status.seen,
        metadata: {
          'collectionID': collectionID,
        },
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
    } catch (error) {
      print(error);
    }
  }
}
