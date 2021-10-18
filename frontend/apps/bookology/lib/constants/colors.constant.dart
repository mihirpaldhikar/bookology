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
  static const MaterialColor primarySwatch = MaterialColor(
    0xff2E79F3,
    {
      50: Color(0xFF4285F4),
      100: Color(0xFF2E79F3),
      200: Color(0xFF196CF2),
      300: Color(0xFF0D61E7),
      400: Color(0xFF0C58D2),
      500: Color(0xFF0B4FBD),
      600: Color(0xFF0A46A8),
      700: Color(0xFF093E93),
      800: Color(0xFF07357E),
      900: Color(0xFF062C69),
    },
  );

  static const Color lightAccentColor = Color(0xff2E79F3);
  static const Color darkAccentColor = Color(0xff275bb1);

  static const Color lightSecondaryColor = Color(0xFFF2F6FE);
  static const Color darkSecondaryColor = Color(0xFF2D2D31);

  static const Color dangerBorderColor = Colors.redAccent;

  static const Color dangerBackgroundColor = Color(0xFFFFCDD2);

  static const Color lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color darkBackgroundColor = Color(0xFF000000);

  static const Color darkColor = Color(0xFF07357E);

  static const Color lightCardColor = Colors.white;
  static const Color darkCardColor = Colors.black;

  static const Color appBarButtonsBackground = Color(0xFF4285F4);

  static const Color buttonTextColor = lightAccentColor;

  static const Color lightAppBarColor = Color(0xFFF2F6FE);
  static const Color darkAppBarColor = darkSecondaryColor;

  static const Color lightStatusBarColor = lightSecondaryColor;
  static const Color darkStatusBarColor = darkSecondaryColor;

  static const Color lightThemeContentColor = Colors.black;
  static const Color darkThemeContentColor = Colors.white;
  static const Color lightThemeButtonColor = Color(0xFFBBDEFB);
  static const Color darkThemeButtonColor = Color(0xff0c465e);
  static const Color lightThemeBottomNavigationBarBackgroundColor =
      lightSecondaryColor;
  static const Color darkThemeBottomNavigationBarBackgroundColor =
      darkSecondaryColor;
}
