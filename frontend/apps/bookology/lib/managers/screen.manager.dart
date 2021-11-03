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

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:after_layout/after_layout.dart';
import 'package:bookology/managers/toast.manager.dart';
import 'package:bookology/managers/view.manager.dart';
import 'package:bookology/services/biomertics.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/screens/intro.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenManager extends StatefulWidget {
  final AdaptiveThemeMode themeMode;

  const ScreenManager({
    Key? key,
    required this.themeMode,
  }) : super(key: key);

  @override
  _ScreenManagerState createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager>
    with AfterLayoutMixin<ScreenManager> {
  Future checkFirstSeen() async {
    final CacheService cacheService = CacheService();
    bool _seen = (cacheService.isIntroScreenSeen());

    if (_seen) {
      if (CacheService().isBiometricsEnabled()) {
        await BiometricsService(context).authenticateWithBiometrics(
            bioAuthReason: 'Please authenticate in order to continue.',
            useOnlyBiometrics: true,
            onBioAuthStarted: () {},
            onBioAuthCompleted: (isVerified) {
              if (isVerified) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ViewManager(screenIndex: 0),
                  ),
                );
              } else {
                ToastManager(context)
                    .showErrorToast(message: 'Biometrics verification failed.');
              }
            },
            onBioAuthError: (PlatformException error) {
              ToastManager(context)
                  .showErrorToast(message: 'An error occurred.');
            });
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ViewManager(screenIndex: 0),
          ),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const IntroScreen(),
        ),
      );
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
