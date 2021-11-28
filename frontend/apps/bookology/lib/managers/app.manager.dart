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

import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/managers/screen.manager.dart';
import 'package:bookology/managers/view.manager.dart';
import 'package:bookology/services/app.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/services/notification.service.dart';
import 'package:bookology/themes/bookology.theme.dart';
import 'package:bookology/ui/screens/auth.screen.dart';
import 'package:bookology/ui/screens/create.screen.dart';
import 'package:bookology/ui/screens/login.screen.dart';
import 'package:bookology/ui/screens/signup.screen.dart';
import 'package:bookology/ui/screens/verify_email.screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

class AppManager extends StatefulWidget {
  const AppManager({
    Key? key,
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
      child: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthService>(context);
    return ChangeNotifierProvider(
      create: (context) => BookologyThemeProvider(),
      builder: (context, _) {
        final themeMode =
            Provider.of<BookologyThemeProvider>(context).themeMode;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: auth.isUserSignedIn() ? const ScreenManager() : const AuthScreen(),
          theme: BookologyTheme.getThemeData(
            colorScheme: ColorsConstant.lightColorScheme,
          ),
          darkTheme: BookologyTheme.getThemeData(
            colorScheme: ColorsConstant.darkColorScheme,
          ),
          themeMode: themeMode,
          routes: {
            '/home': (context) => const ScreenManager(),
            '/profile': (context) => const ViewManager(
                  screenIndex: 3,
                ),
            '/create': (context) => const CreateScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/auth': (context) => const AuthScreen(),
            '/verify': (context) => const VerifyEmailScreen(),
          },
        );
      },
    );
  }
}

