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

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/managers/screen.manager.dart';
import 'package:bookology/managers/theme.manager.dart';
import 'package:bookology/managers/view.manager.dart';
import 'package:bookology/services/app.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/services/notification.service.dart';
import 'package:bookology/ui/screens/auth.screen.dart';
import 'package:bookology/ui/screens/create.screen.dart';
import 'package:bookology/ui/screens/login.screen.dart';
import 'package:bookology/ui/screens/signup.screen.dart';
import 'package:bookology/ui/screens/verify_email.screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

const AndroidNotificationChannel androidNotificationChannel =
    AndroidNotificationChannel(
  'high_importance_channel',
  'Book Enquiry Notification',
  importance: Importance.max,
);

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class AppManager extends StatefulWidget {
  final AdaptiveThemeMode saveThemeMode;

  const AppManager({
    Key? key,
    required this.saveThemeMode,
  }) : super(key: key);

  @override
  _AppManagerState createState() => _AppManagerState();
}

class _AppManagerState extends State<AppManager> {
  @override
  void initState() {
    super.initState();
    NotificationService(FirebaseMessaging.instance).notificationManager();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        Provider(
          create: (_) => FirestoreService(FirebaseFirestore.instance),
        ),
        Provider(
          create: (_) => NotificationService(FirebaseMessaging.instance),
        ),
        Provider(
          create: (_) => AppService(),
        ),
        StreamProvider(
          create: (context) =>
              this.context.read<AuthService>().onAuthStateChanges,
          initialData: null,
        ),
      ],
      child: App(
        savedThemeMode: widget.saveThemeMode,
      ),
    );
  }
}

class App extends StatefulWidget {
  final AdaptiveThemeMode savedThemeMode;

  const App({
    Key? key,
    required this.savedThemeMode,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    if (widget.savedThemeMode == AdaptiveThemeMode.light ||
        widget.savedThemeMode == AdaptiveThemeMode.dark) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarIconBrightness:
              widget.savedThemeMode == AdaptiveThemeMode.dark
                  ? Brightness.light
                  : Brightness.dark,
          statusBarColor: widget.savedThemeMode == AdaptiveThemeMode.dark
              ? ColorsConstant.darkSecondaryColor
              : ColorsConstant.lightStatusBarColor,
          systemNavigationBarColor:
              widget.savedThemeMode == AdaptiveThemeMode.dark
                  ? ColorsConstant.darkThemeBottomNavigationBarBackgroundColor
                  : ColorsConstant.lightThemeBottomNavigationBarBackgroundColor,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
          statusBarColor: isDarkMode
              ? ColorsConstant.darkSecondaryColor
              : ColorsConstant.lightStatusBarColor,
          systemNavigationBarColor: isDarkMode
              ? ColorsConstant.darkThemeBottomNavigationBarBackgroundColor
              : ColorsConstant.lightThemeBottomNavigationBarBackgroundColor,
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return RestartWidget(
      child: AdaptiveTheme(
        light: ThemeManager.lightTheme,
        dark: ThemeManager.darkTheme,
        initial: widget.savedThemeMode,
        builder: (theme, darkTheme) => MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Bookology',
          darkTheme: darkTheme,
          theme: theme,
          themeMode: widget.savedThemeMode == AdaptiveThemeMode.system
              ? ThemeMode.system
              : widget.savedThemeMode == AdaptiveThemeMode.light
                  ? ThemeMode.light
                  : ThemeMode.dark,
          routes: {
            '/home': (context) => ScreenManager(
                  themeMode: widget.savedThemeMode,
                ),
            '/profile': (context) => const ViewManager(
                  screenIndex: 3,
                ),
            '/create': (context) => const CreateScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/auth': (context) => const AuthScreen(),
            '/verify': (context) => const VerifyEmailScreen(),
          },
          home: auth.isUserSignedIn()
              ? ScreenManager(
                  themeMode: widget.savedThemeMode,
                )
              : const AuthScreen(),
        ),
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
