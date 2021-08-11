import 'package:bookology/services/firestore.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class ChatsService {
  final firestoreService = new FirestoreService(FirebaseFirestore.instance);

  Future<dynamic> createChatRoom({
    required String? bookName,
    required String? bookCoverImage,
    required String? ownerUserID,
    required String? userID,
  }) async {
    final room = await FirebaseChatCore.instance.createGroupRoom(
      name: bookName as String,
      imageUrl: bookCoverImage,
      users: [
        await firestoreService.getFirestoreUser(userID: ownerUserID as String),
        await firestoreService.getFirestoreUser(userID: userID as String),
      ],
    );

    return room;
  }
}
