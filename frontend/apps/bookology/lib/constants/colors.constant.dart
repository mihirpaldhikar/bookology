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

import 'package:bookology/services/remote.service.dart';
import 'package:flutter/material.dart';

class ColorsConstant {
  static final lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(
      int.parse(
        RemoteService().getStringData(key: 'primaryColorLight'),
      ),
    ),
    onPrimary: const Color(0xffFFFFFF),
    primaryContainer: Color(
      int.parse(
        RemoteService().getStringData(key: 'primaryContainerColorLight'),
      ),
    ),
    onPrimaryContainer: const Color(0xff001848),
    secondary: const Color(0xff585E71),
    onSecondary: const Color(0xffFFFFFF),
    secondaryContainer: const Color(0xffDCE2F9),
    onSecondaryContainer: const Color(0xff151B2C),
    tertiary: const Color(0xff735572),
    onTertiary: const Color(0xffFFFFFF),
    tertiaryContainer: const Color(0xffFDD7F9),
    onTertiaryContainer: const Color(0xff2A122C),
    error: const Color(0xffBA1B1B),
    errorContainer: const Color(0xffFFDAD4),
    onError: const Color(0xffFFFFFF),
    onErrorContainer: const Color(0xff410001),
    background: const Color(0xffFDFBFF),
    onBackground: const Color(0xff1B1B1E),
    surface: const Color(0xffffffff),
    onSurface: const Color(0xff1B1B1E),
    surfaceVariant: const Color(0xffE2E2EC),
    onSurfaceVariant: const Color(0xff44464E),
    outline: const Color(0xff757780),
    onInverseSurface: const Color(0xffF2F0F5),
    inverseSurface: const Color(0xff303033),
    inversePrimary: const Color(0xffB0C6FF),
  );

  static final darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(
      int.parse(
        RemoteService().getStringData(key: 'primaryColorDark'),
      ),
    ),
    onPrimary: const Color(0xff000000),
    primaryContainer: Color(
      int.parse(
        RemoteService().getStringData(key: 'primaryContainerColorDark'),
      ),
    ),
    onPrimaryContainer: const Color(0xffD9E2FF),
    secondary: const Color(0xffC0C6DD),
    onSecondary: const Color(0xff2A3041),
    secondaryContainer: const Color(0xff404658),
    onSecondaryContainer: const Color(0xffDCE2F9),
    tertiary: const Color(0xffE0BBDD),
    onTertiary: const Color(0xff412742),
    tertiaryContainer: const Color(0xff593D59),
    onTertiaryContainer: const Color(0xffFDD7F9),
    error: const Color(0xffFFB4A9),
    errorContainer: const Color(0xff930006),
    onError: const Color(0xff680003),
    onErrorContainer: const Color(0xffFFDAD4),
    background: const Color(0xff1B1B1E),
    onBackground: const Color(0xffE4E2E6),
    surface: const Color(0xff202023),
    onSurface: const Color(0xffE4E2E6),
    surfaceVariant: const Color(0xff44464E),
    onSurfaceVariant: const Color(0xffC5C6D0),
    outline: const Color(0xff8F909A),
    onInverseSurface: const Color(0xff1B1B1E),
    inverseSurface: const Color(0xffE4E2E6),
    inversePrimary: const Color(0xff0056D3),
  );
}
