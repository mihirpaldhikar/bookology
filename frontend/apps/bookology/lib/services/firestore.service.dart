import 'package:bookology/services/notification.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          .collection('Secrets')
          .doc(_firebaseAuth.currentUser?.uid)
          .get();

      final userKey = data.data()?['authorizeToken'];
      if (cacheStorage.read('userIdentifierKey') == null) {
        cacheStorage.write('userIdentifierKey', userKey);
      }

      return cacheStorage.read('userIdentifierKey');
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

  Future<dynamic> uploadFCMToken() async {
    try {
      SharedPreferences userPrefs = await SharedPreferences.getInstance();

      final data = await _firestore
          .collection('Secrets')
          .doc(_firebaseAuth.currentUser?.uid)
          .set({
        'fcmToken': await _notificationService.getMessagingToken(),
      }, SetOptions(merge: true));

      final fcmToken = _notificationService.getMessagingToken();
      if (userPrefs.getString('userAccessKey') == null) {
        userPrefs.setString('userAccessKey', fcmToken.toString());
      }

      return true;
    } catch (error) {
      print(error);
      return error;
    }
  }
}
