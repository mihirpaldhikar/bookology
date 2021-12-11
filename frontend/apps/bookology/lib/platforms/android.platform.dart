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
import 'package:flutter/services.dart';

class AndroidPlatform {
  static const platform = MethodChannel('samples.flutter.dev/battery');

  Future<dynamic> notifyTextTheme({required Color textColor}) async {
    try {
      await platform.invokeMethod(
        'setTextColor',
        {
          "color": textColor.value,
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> showToast(
      {required String message, required int duration}) async {
    try {
      await platform.invokeMethod(
        'showToast',
        {
          "message": message,
          "duration": duration,
        },
      );
    } catch (error) {
      rethrow;
    }
  }
}
