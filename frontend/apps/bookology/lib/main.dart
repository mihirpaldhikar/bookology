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

import 'package:bookology/managers/app.manager.dart';
import 'package:bookology/services/remote.service.dart';
import 'package:bookology/services/startup.service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'app.config.env');
  await StartUpService().startService();
  await Firebase.initializeApp();
  await RemoteConfig.instance.ensureInitialized();
  await RemoteConfig.instance.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ),
  );
  await RemoteService().initialize();
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();
  await FirebaseAppCheck.instance.activate();
  await GetStorage.init();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://31374a6b13514ef28c9ecd9717e11a34@o796692.ingest.sentry.io/5972010';
    },
    appRunner: () => runApp(
      AppManager(
        dynamicLinkData: initialLink,
      ),
    ),
  );
}
