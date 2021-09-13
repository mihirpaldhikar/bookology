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

import 'package:bookology/models/app.model.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info/package_info.dart';

class AppService {
  final FirestoreService firestoreService =
      new FirestoreService(FirebaseFirestore.instance);
  Future<AppModel> getAppInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return AppModel(
      appName: packageInfo.appName,
      appVersion: packageInfo.version,
      appBuildNumber: packageInfo.buildNumber,
      changelogs: '',
      androidPackageName: 'com.imihirpaldhikar.bookology',
      iosBundleId: 'com.imihirpaldhikar.bookology',
      isPublishedOnGooglePlayStore: false,
      isPublishedOnAppleAppStore: false,
      googlePlayStoreUrl: '',
      directUpdateUrl: '',
      appleAppStoreUrl: '',
    );
  }

  Future<AppModel> getRemoteAppInfo() async {
    final remoteAppInfo = await firestoreService.getServerSideAppDetails();
    return remoteAppInfo;
  }
}
