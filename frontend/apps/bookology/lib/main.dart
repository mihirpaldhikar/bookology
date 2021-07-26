import 'package:bookology/managers/app.manager.dart';
import 'package:bookology/services/ads.service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final adsM = MobileAds.instance.initialize();
  await Firebase.initializeApp();
  await GetStorage.init();
  await dotenv.load(fileName: 'app.config.env');
  runApp(
    Provider.value(
      value: AdsService(adsM),
      builder: (context, child) => AppManager(),
    ),
  );
}
