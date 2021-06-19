import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/ui/screens/auth.screen.dart';
import 'package:bookology/ui/screens/home.screen.dart';
import 'package:bookology/ui/screens/login.screen.dart';
import 'package:bookology/ui/screens/profile.screen.dart';
import 'package:bookology/ui/screens/publish.screen.dart';
import 'package:bookology/ui/screens/signup.screen.dart';
import 'package:bookology/ui/screens/verify_email.screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppManager extends StatefulWidget {
  const AppManager({Key? key}) : super(key: key);

  @override
  _AppManagerState createState() => _AppManagerState();
}

class _AppManagerState extends State<AppManager> {
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
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return MaterialApp(
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
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      routes: {
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/publish': (context) => PublishScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/auth': (context) => AuthScreen(),
        '/verify': (context) => VerifyEmailScreen(),
      },
      home: auth.isUserSignedIn() ? HomeScreen() : AuthScreen(),
    );
  }
}
