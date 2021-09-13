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

import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeManager {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'YoutubeSans',
    primaryColor: ColorsConstant.LIGHT_THEME_CONTENT_COLOR,
    backgroundColor: ColorsConstant.BACKGROUND_COLOR,
    cardTheme: CardTheme(
      color: ColorsConstant.CARD_COLOR,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(ValuesConstant.BORDER_RADIUS),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
      headline1: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'YoutubeSans',
      ),
      headline3: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontFamily: 'YoutubeSans',
      ),
      headline4: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontFamily: 'YoutubeSans',
      ),
      headline5: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontFamily: 'YoutubeSans',
      ),
      headline6: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontFamily: 'YoutubeSans',
      ),
      subtitle1: TextStyle(
        color: Colors.grey.shade800,
        fontWeight: FontWeight.w300,
        fontFamily: 'YoutubeSans',
      ),
      subtitle2: TextStyle(
        color: Colors.grey.shade800,
        fontWeight: FontWeight.normal,
        fontFamily: 'YoutubeSans',
      ),
      bodyText1: TextStyle(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.normal,
        fontFamily: 'YoutubeSans',
      ),
      bodyText2: TextStyle(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.normal,
        fontFamily: 'YoutubeSans',
      ),
      button: TextStyle(
        color: ColorsConstant.LIGHT_THEME_CONTENT_COLOR,
        fontWeight: FontWeight.w600,
        fontFamily: 'YoutubeSans',
        fontSize: 15,
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: ColorsConstant.SECONDARY_COLOR,
      brightness: Brightness.light,
      disabledColor: Colors.grey,
      labelStyle: GoogleFonts.poppins(),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: ColorsConstant.ACCENT_COLOR,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      elevation: 0,
      showCheckmark: false,
      pressElevation: 2.0,
      padding: EdgeInsets.all(4),
      selectedColor: ColorsConstant.ACCENT_COLOR,
      secondarySelectedColor: ColorsConstant.SECONDARY_COLOR,
      deleteIconColor: Colors.redAccent,
      secondaryLabelStyle: TextStyle(),
    ),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: TextStyle(fontFamily: 'YoutubeSans'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(
            ValuesConstant.BORDER_RADIUS,
          ),
          topLeft: Radius.circular(
            ValuesConstant.BORDER_RADIUS,
          ),
          bottomLeft: Radius.circular(
            ValuesConstant.BORDER_RADIUS,
          ),
          bottomRight: Radius.circular(
            ValuesConstant.BORDER_RADIUS,
          ),
        ),
      ),
    ),
    scaffoldBackgroundColor: ColorsConstant.BACKGROUND_COLOR,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsConstant.APP_BAR_COLOR,
      elevation: 0,
      toolbarTextStyle: TextStyle(
        color: Colors.black,
        fontFamily: 'YoutubeSans',
        fontSize: 30,
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 25,
        fontFamily: 'YoutubeSans',
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      modalBackgroundColor: ColorsConstant.BACKGROUND_COLOR,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(
            ValuesConstant.BORDER_RADIUS,
          ),
          topLeft: Radius.circular(
            ValuesConstant.BORDER_RADIUS,
          ),
        ),
      ),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(ValuesConstant.BORDER_RADIUS),
        ),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: ColorsConstant.PRIMARY_SWATCH,
    ).copyWith(
      secondary: ColorsConstant.ACCENT_COLOR,
    ),
  );
}
