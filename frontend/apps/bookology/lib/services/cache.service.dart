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

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PreferencesManager {
  final _preferences = GetStorage();

  void setCurrentUser({required String userName, bool? isVerified}) {
    _preferences.write('userName', userName);
    _preferences.write('isVerified', isVerified);
  }

  void setNewNotificationNumber({required int count}) {
    _preferences.write('newNotificationNumber', count);
  }

  void setOldNotificationNumber({required int count}) {
    _preferences.write('oldNotificationNumber', count);
  }

  int getNewNotificationNumber() {
    return _preferences.read('newNotificationNumber');
  }

  int getOldNotificationNumber() {
    return _preferences.read('oldNotificationNumber');
  }

  String getCurrentUserNameCache() {
    return _preferences.read('userName');
  }

  void setIntroScreenView({required bool seen}) {
    _preferences.write('seenIntroScreen', seen);
  }

  bool isIntroScreenSeen() {
    return _preferences.read('seenIntroScreen') ?? false;
  }

  bool getCurrentIsVerifiedCache() {
    return _preferences.read('isVerified') ?? false;
  }

  void setIsBiometricEnabled({required bool isEnabled}) {
    _preferences.write('biometrics_enabled', isEnabled);
  }

  bool isBiometricsEnabled() {
    return _preferences.read('biometrics_enabled') ?? false;
  }

  void setCurrentThemeMode({required ThemeMode themeMode}) {
    final _theme = themeMode == ThemeMode.dark
        ? 'dark'
        : themeMode == ThemeMode.system
            ? 'system'
            : 'light';
    _preferences.write('currentTheme', _theme);
  }

  ThemeMode getCurrentTheme() {
    final _theme = _preferences.read('currentTheme') == 'dark'
        ? ThemeMode.dark
        : _preferences.read('currentTheme') == 'system'
            ? ThemeMode.system
            : ThemeMode.light;
    return _theme;
  }

  Future<void> clearCacheStorage() async {
    await _preferences.erase();
  }
}
