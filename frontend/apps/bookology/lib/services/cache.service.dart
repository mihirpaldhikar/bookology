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

import 'package:get_storage/get_storage.dart';

class CacheService {
  final _cacheStorage = GetStorage();

  void setCurrentUser({required String userName, bool? isVerified}) {
    _cacheStorage.write('userName', userName);
    _cacheStorage.write('isVerified', isVerified);
  }

  void setNewNotificationNumber({required int count}) {
    _cacheStorage.write('newNotificationNumber', count);
  }

  void setOldNotificationNumber({required int count}) {
    _cacheStorage.write('oldNotificationNumber', count);
  }

  int getNewNotificationNumber() {
    return _cacheStorage.read('newNotificationNumber');
  }

  int getOldNotificationNumber() {
    return _cacheStorage.read('oldNotificationNumber');
  }

  String getCurrentUserNameCache() {
    return _cacheStorage.read('userName');
  }

  void setIntroScreenView({required bool seen}) {
    _cacheStorage.write('seenIntroScreen', seen);
  }

  bool isIntroScreenSeen() {
    return _cacheStorage.read('seenIntroScreen');
  }

  bool getCurrentIsVerifiedCache() {
    return _cacheStorage.read('isVerified');
  }

  Future<void> clearCacheStorage() async {
    await _cacheStorage.erase();
  }
}
