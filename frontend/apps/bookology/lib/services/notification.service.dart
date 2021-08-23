import 'package:bookology/managers/app.manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  Future<void> notificationManager() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.data['notification_title'],
          message.data['notification_body'],
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidNotificationChannel.id,
              androidNotificationChannel.name,
              androidNotificationChannel.description,
            ),
          ),
        );
      },
    );

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    if (initialMessage != null) {
      _handleNotification(initialMessage);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.onMessageOpenedApp.listen(_handleNotification);
    await FirebaseMessaging.onMessage.listen(_handleNotification);
  }
}

void _handleNotification(RemoteMessage message) async {
  if (message.data['notification_type'] == 'book_enquiry_notification') {
    print('BACKGROUND MSG ');
    // navigatorKey.currentState!.pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => ScreenManager(currentIndex: 3)),
    //     (route) => false);
    showDialog(
        context: navigatorKey.currentState!.context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('LOL'),
            ));
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.data['notification_title'],
    message.data['notification_body'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        androidNotificationChannel.id,
        androidNotificationChannel.name,
        androidNotificationChannel.description,
      ),
    ),
  );
}
