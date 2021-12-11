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

import 'package:bookology/services/app.service.dart';
import 'package:bookology/ui/screens/dynamic_book.screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {
  final _appService = AppService();

  Future<Uri> generateDynamicLink({required String bookId}) async {
    final _appInfo = await _appService.getAppInfo();
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // The Dynamic Link URI domain. You can view created URIs on your Firebase console
      uriPrefix: kDebugMode
          ? 'https://bookologydev.page.link'
          : 'https://bookology.page.link',
      // The deep Link passed to your application which you can use to affect change
      link: Uri.parse('https://bookology.tech/book/$bookId'),
      // Android application details needed for opening correct app on device/Play Store
      androidParameters: AndroidParameters(
        packageName: _appInfo.androidPackageName,
        minimumVersion: 1,
      ),
      // iOS application details needed for opening correct app on device/App Store
      iosParameters: IOSParameters(
        bundleId: _appInfo.iosBundleId,
        minimumVersion: '2',
      ),
    );

    final _dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return _dynamicLink.shortUrl;
  }

  Future<void> handleLink(
      {required BuildContext context,
      required PendingDynamicLinkData? link}) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      if (dynamicLinkData.link.path.contains('/book/')) {
        final bookId = dynamicLinkData.link.path.split('/book/')[1];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DynamicBookScreen(
              bookId: bookId,
            ),
          ),
        );
      }
    }).onError((error) {
      // Handle errors
      throw error;
    });
  }
}
