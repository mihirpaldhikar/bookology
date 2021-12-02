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

class ColorsConstant {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff0056D3),
    onPrimary: Color(0xffFFFFFF),
    primaryContainer: Color(0xffD9E2FF),
    onPrimaryContainer: Color(0xff001848),
    secondary: Color(0xff585E71),
    onSecondary: Color(0xffFFFFFF),
    secondaryContainer: Color(0xffDCE2F9),
    onSecondaryContainer: Color(0xff151B2C),
    tertiary: Color(0xff735572),
    onTertiary: Color(0xffFFFFFF),
    tertiaryContainer: Color(0xffFDD7F9),
    onTertiaryContainer: Color(0xff2A122C),
    error: Color(0xffBA1B1B),
    errorContainer: Color(0xffFFDAD4),
    onError: Color(0xffFFFFFF),
    onErrorContainer: Color(0xff410001),
    background: Color(0xffFDFBFF),
    onBackground: Color(0xff1B1B1E),
    surface: Color(0xffffffff),
    onSurface: Color(0xff1B1B1E),
    surfaceVariant: Color(0xffE2E2EC),
    onSurfaceVariant: Color(0xff44464E),
    outline: Color(0xff757780),
    onInverseSurface: Color(0xffF2F0F5),
    inverseSurface: Color(0xff303033),
    inversePrimary: Color(0xffB0C6FF),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffB0C6FF),
    onPrimary: Color(0xff002B73),
    primaryContainer: Color(0xff11207b),
    onPrimaryContainer: Color(0xffD9E2FF),
    secondary: Color(0xffC0C6DD),
    onSecondary: Color(0xff2A3041),
    secondaryContainer: Color(0xff404658),
    onSecondaryContainer: Color(0xffDCE2F9),
    tertiary: Color(0xffE0BBDD),
    onTertiary: Color(0xff412742),
    tertiaryContainer: Color(0xff593D59),
    onTertiaryContainer: Color(0xffFDD7F9),
    error: Color(0xffFFB4A9),
    errorContainer: Color(0xff930006),
    onError: Color(0xff680003),
    onErrorContainer: Color(0xffFFDAD4),
    background: Color(0xff1B1B1E),
    onBackground: Color(0xffE4E2E6),
    surface: Color(0xff202023),
    onSurface: Color(0xffE4E2E6),
    surfaceVariant: Color(0xff44464E),
    onSurfaceVariant: Color(0xffC5C6D0),
    outline: Color(0xff8F909A),
    onInverseSurface: Color(0xff1B1B1E),
    inverseSurface: Color(0xffE4E2E6),
    inversePrimary: Color(0xff0056D3),
  );
}
