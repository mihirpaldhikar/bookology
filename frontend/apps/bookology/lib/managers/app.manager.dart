import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/managers/screen.manager.dart';
import 'package:bookology/managers/view.manager.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

const AndroidNotificationChannel androidNotificationChannel =
    AndroidNotificationChannel(
  'high_importance_channel',
  'Book Enquiry Notification',
  'This notification is shown when a user request to enquire about the book from the uploader.',
  importance: Importance.max,
);

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class AppManager extends StatefulWidget {
  const AppManager({Key? key}) : super(key: key);

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
        StreamProvider(
          create: (context) =>
              this.context.read<AuthService>().onAuthStateChanges,
          initialData: null,
        ),
      ],
      child: App(),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

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
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Bookology',
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: ColorsConstant.PRIMARY_SWATCH,
          accentColor: ColorsConstant.ACCENT_COLOR,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          scaffoldBackgroundColor: ColorsConstant.BACKGROUND_COLOR,
          appBarTheme: AppBarTheme(
            backgroundColor: ColorsConstant.APP_BAR_COLOR,
            elevation: 0,
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            actionsIconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          bottomSheetTheme: BottomSheetThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  ValuesConstant.BORDER_RADIUS,
                ),
                topLeft: Radius.circular(
                  ValuesConstant.BORDER_RADIUS,
                ),
              ),
            ),
          ),
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(ValuesConstant.BORDER_RADIUS),
            )),
          )),
      routes: {
        '/home': (context) => ScreenManager(),
        '/profile': (context) => ViewManager(
              currentIndex: 3,
            ),
        '/create': (context) => CreateScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/auth': (context) => AuthScreen(),
        '/verify': (context) => VerifyEmailScreen(),
      },
      home: auth.isUserSignedIn() ? ScreenManager() : AuthScreen(),
    );
  }
}
