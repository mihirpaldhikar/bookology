/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is furnished
 * to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 * or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteService {
  final RemoteConfig remoteConfig = RemoteConfig.instance;

  Future<void> initialize() async {
    await remoteConfig.fetchAndActivate();
    remoteConfig.setDefaults(<String, dynamic>{
      'appSlogan': 'Smartly Share Book',
      'primaryColorLight': 0xff448AFF,
      'primaryColorDark': 0xff9dcaff,
      'primaryContainerColorLight': 0xff001848,
      'primaryContainerColorDark': 0xff253141,
      'showFallingSnow': true
    });
  }

  dynamic getStringData({required String key}) {
    return remoteConfig.getString(key);
  }

  dynamic getBoolData({required String key}) {
    return remoteConfig.getBool(key);
  }
}
