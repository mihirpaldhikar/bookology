/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *  the Software, and to permit persons to whom the Software is furnished to do so,
 *  subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 *  ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 *  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 *  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import 'package:bookology/managers/app.manager.dart';
import 'package:bookology/ui/screens/notifications.screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel bookRequestNotificationChannel =
    AndroidNotificationChannel(
  'book_enquiry_request',
  'Book Enquiry Notifications',
  importance: Importance.high,
);
const AndroidNotificationChannel firebaseNotificationChannel =
    AndroidNotificationChannel(
  'firebase_messaging_notification_channel',
  'System Notifications',
  importance: Importance.defaultImportance,
);

class NotificationService {
  final FirebaseMessaging _firebaseMessaging;

  NotificationService(this._firebaseMessaging);

  Future<dynamic> getMessagingToken() async {
    try {
      final messagingToken = _firebaseMessaging.getToken();
      return messagingToken;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> notificationManager() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/ic_notification');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(bookRequestNotificationChannel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(firebaseNotificationChannel);

    _handleNotification(initialMessage!);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotification);
  }
}

void _handleNotification(RemoteMessage message) async {
  if (message.data['notification_type'] == 'book_enquiry_notification') {
    Navigator.push(
      navigatorKey.currentState!.context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NotificationScreen(),
      ),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (!message.data.containsKey('isFromFirebaseConsole')) {
    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          bookRequestNotificationChannel.id,
          bookRequestNotificationChannel.name,
          importance: Importance.high,
        ),
      ),
    );
  }
}
