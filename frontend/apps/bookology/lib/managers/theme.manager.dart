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
    primaryColor: ColorsConstant.lightThemeContentColor,
    backgroundColor: ColorsConstant.backgroundColor,
    cardTheme: CardTheme(
      color: ColorsConstant.cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(ValuesConstant.borderRadius),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: GoogleFonts.poppinsTextTheme(),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: ColorsConstant.secondaryColor,
      brightness: Brightness.light,
      disabledColor: Colors.grey,
      labelStyle: GoogleFonts.poppins(),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: ColorsConstant.accentColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      elevation: 0,
      showCheckmark: false,
      pressElevation: 2.0,
      padding: const EdgeInsets.all(4),
      selectedColor: ColorsConstant.accentColor,
      secondarySelectedColor: ColorsConstant.secondaryColor,
      deleteIconColor: Colors.redAccent,
      secondaryLabelStyle: const TextStyle(),
    ),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: GoogleFonts.poppins(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(
            ValuesConstant.borderRadius,
          ),
          topLeft: Radius.circular(
            ValuesConstant.borderRadius,
          ),
          bottomLeft: Radius.circular(
            ValuesConstant.borderRadius,
          ),
          bottomRight: Radius.circular(
            ValuesConstant.borderRadius,
          ),
        ),
      ),
    ),
    scaffoldBackgroundColor: ColorsConstant.backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsConstant.appBarColor,
      elevation: 0,
      toolbarTextStyle: GoogleFonts.poppins(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      actionsIconTheme: const IconThemeData(
        color: Colors.black,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      modalBackgroundColor: ColorsConstant.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(
            ValuesConstant.borderRadius,
          ),
          topLeft: Radius.circular(
            ValuesConstant.borderRadius,
          ),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor:
          ColorsConstant.lightThemeBottomNavigationBarBackgroundColor,
      selectedItemColor: Color(0xff039BE5),
      unselectedItemColor: ColorsConstant.lightThemeButtonColor,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: ColorsConstant.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(ValuesConstant.borderRadius),
        ),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: ColorsConstant.primarySwatch,
    ).copyWith(
      secondary: ColorsConstant.accentColor,
      background: ColorsConstant.secondaryColor,
    ),
  );
}
