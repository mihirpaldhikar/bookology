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
    textTheme: GoogleFonts.poppinsTextTheme(),
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
      contentTextStyle: GoogleFonts.poppins(),
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
      toolbarTextStyle: GoogleFonts.poppins(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      modalBackgroundColor: ColorsConstant.SECONDARY_COLOR,
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
      backgroundColor: ColorsConstant.SECONDARY_COLOR,
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
      background: ColorsConstant.SECONDARY_COLOR,
    ),
  );
}
