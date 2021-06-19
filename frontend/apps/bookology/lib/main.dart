import 'package:bookology/managers/app.manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final bool _useFirebaseEmulators = false;

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (_useFirebaseEmulators) {
    await FirebaseAuth.instance.useEmulator('http://192.168.100.4:9099');
  }

  await dotenv.load(fileName: 'app.config.env');
  runApp(AppManager());
}
