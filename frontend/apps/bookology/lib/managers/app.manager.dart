import 'package:bookology/managers/screen.manager.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/services/notification.service.dart';
import 'package:bookology/ui/screens/auth.screen.dart';
import 'package:bookology/ui/screens/create.screen.dart';
import 'package:bookology/ui/screens/edit_profile.screen.dart';
import 'package:bookology/ui/screens/login.screen.dart';
import 'package:bookology/ui/screens/signup.screen.dart';
import 'package:bookology/ui/screens/verify_email.screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      flutterLocalNotificationsPlugin.show(
          message.hashCode,
          'notification.title',
          'notification.body',
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidNotificationChannel.id,
              androidNotificationChannel.name,
              androidNotificationChannel.description,
              //icon: android.smallIcon,
            ),
          ));
      //}
    });

    //FirebaseMessaging.onMessageOpenedApp;
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    await Firebase.initializeApp();

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
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    final auth = Provider.of<AuthService>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: MaterialApp(
        title: 'Bookology',
        theme: ThemeData(
            primarySwatch: MaterialColor(0xff651FFF, {
              50: Color(0xFFEDE7F6),
              100: Color(0xFFD1C4E9),
              200: Color(0xFFB39DDB),
              300: Color(0xFF9575CD),
              400: Color(0xFF7E57C2),
              500: Color(0xFF673AB7),
              600: Color(0xFF5E35B1),
              700: Color(0xFF512DA8),
              800: Color(0xFF4527A0),
              900: Color(0xFF311B92),
            }),
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.transparent,
            ),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
              actionsIconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(15),
              )),
            )),
        routes: {
          '/home': (context) => ScreenManager(
                currentIndex: 0,
              ),
          '/profile': (context) => ScreenManager(
                currentIndex: 3,
              ),
          '/create': (context) => CreateScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/auth': (context) => AuthScreen(),
          '/verify': (context) => VerifyEmailScreen(),
        },
        home: auth.isUserSignedIn()
            ? auth.currentUser()!.displayName!.length == 1
                ? EditProfileScreen(
                    userID: auth.currentUser()!.uid,
                    profilePicture: auth.currentUser()!.photoURL.toString(),
                    userName:
                        auth.currentUser()!.email.toString().split('@')[0],
                    firstName: '',
                    lastName: '',
                    bio: '',
                    isInitialUpdate: true,
                  )
                : ScreenManager(
                    currentIndex: 0,
                    isUserProfileUpdated: false,
                  )
            : AuthScreen(),
      ),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    'Book Enquiry Request',
    '@imihirpaldhikar is requesting to enquire about a book',
    NotificationDetails(
      android: AndroidNotificationDetails(
        androidNotificationChannel.id,
        androidNotificationChannel.name,
        androidNotificationChannel.description,
      ),
    ),
  );
}
