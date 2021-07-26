import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging;

  NotificationService(this._firebaseMessaging);

  Future<dynamic> getMessagingToken() async {
    try {
      final messagingToken = _firebaseMessaging.getToken();
      return messagingToken;
    } catch (error) {
      print(error);
      return error;
    }
  }
}
