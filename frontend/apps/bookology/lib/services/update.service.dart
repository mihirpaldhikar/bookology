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

import 'dart:io';

import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/managers/bottom_sheet.manager.dart';
import 'package:bookology/services/app.service.dart';
import 'package:bookology/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_snackbar/material_snackbar.dart';
import 'package:material_snackbar/snackbar_messenger.dart';

class UpdateService {
  final BuildContext context;
  UpdateService(this.context);

  Future<void> checkForAppUpdate() async {
    final appInfo = await AppService().getAppInfo();
    final remoteAppInfo = await AppService().getRemoteAppInfo();

    final int localAppVersion =
        int.parse(appInfo.appVersion.trim().replaceAll('.', ''));
    final int remoteAppVersion =
        int.parse(remoteAppInfo.appVersion.trim().replaceAll('.', ''));
    if (localAppVersion <= remoteAppVersion &&
        localAppVersion != remoteAppVersion) {
      MaterialSnackBarMessenger.of(context).showSnackBar(
        snackbar: MaterialSnackbar(
          duration: const Duration(seconds: 5),
          content: const Text(StringConstants.appUpdateAvailable),
          actionBuilder: (context, close) => TextButton(
            child: const Text(StringConstants.update),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              BottomSheetManager(context).showUpdateAvailableBottomSheet(
                changeLog: remoteAppInfo.changelogs.replaceAll('\\n', '\n'),
                onCancelClicked: () {
                  Navigator.of(context).pop();
                },
                onUpdateClicked: () async {
                  if (Platform.isAndroid) {
                    if (remoteAppInfo.isPublishedOnGooglePlayStore) {
                      launchURL(url: remoteAppInfo.googlePlayStoreUrl);
                    }
                  }

                  if (Platform.isIOS) {
                    if (remoteAppInfo.isPublishedOnAppleAppStore) {
                      launchURL(url: remoteAppInfo.appleAppStoreUrl);
                    }
                  }
                },
              );
            },
          ),
        ),
      );
    }
  }
}
