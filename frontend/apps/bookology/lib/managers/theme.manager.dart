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

import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeManager {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorsConstant.lightThemeContentColor,
    backgroundColor: ColorsConstant.lightBackgroundColor,
    cardTheme: CardTheme(
      color: ColorsConstant.lightCardColor,
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
      backgroundColor: ColorsConstant.lightSecondaryColor,
      brightness: Brightness.light,
      disabledColor: Colors.grey,
      labelStyle: GoogleFonts.poppins(),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: ColorsConstant.lightAccentColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      elevation: 0,
      showCheckmark: false,
      pressElevation: 2.0,
      padding: const EdgeInsets.all(4),
      selectedColor: ColorsConstant.lightAccentColor,
      secondarySelectedColor: ColorsConstant.lightSecondaryColor,
      deleteIconColor: Colors.redAccent,
      secondaryLabelStyle: const TextStyle(),
    ),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: GoogleFonts.poppins(
        color: Colors.white,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ValuesConstant.borderRadius,
        ),
      ),
    ),
    scaffoldBackgroundColor: ColorsConstant.lightBackgroundColor,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: ColorsConstant.lightSecondaryColor,
        systemNavigationBarColor:
            ColorsConstant.lightThemeBottomNavigationBarBackgroundColor,
      ),
      backgroundColor: ColorsConstant.lightAppBarColor,
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
    popupMenuTheme: PopupMenuThemeData(
      color: ColorsConstant.lightSecondaryColor,
      enableFeedback: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ValuesConstant.borderRadius,
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      modalBackgroundColor: ColorsConstant.lightSecondaryColor,
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
      unselectedItemColor: Colors.red,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: ColorsConstant.lightSecondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(ValuesConstant.borderRadius),
        ),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme.light(
        background: ColorsConstant.lightThemeButtonColor,
        primary: Colors.black,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: ColorsConstant.primarySwatch,
      brightness: Brightness.light,
    ).copyWith(
      secondary: ColorsConstant.lightAccentColor,
      background: ColorsConstant.lightSecondaryColor,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorsConstant.darkThemeContentColor,
    backgroundColor: ColorsConstant.lightBackgroundColor,
    cardTheme: CardTheme(
      color: ColorsConstant.darkCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(ValuesConstant.borderRadius),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: GoogleFonts.poppinsTextTheme(),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: ColorsConstant.lightSecondaryColor,
      brightness: Brightness.light,
      disabledColor: Colors.white,
      labelStyle: GoogleFonts.poppins(),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: ColorsConstant.lightAccentColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      elevation: 0,
      showCheckmark: false,
      pressElevation: 2.0,
      padding: const EdgeInsets.all(4),
      selectedColor: ColorsConstant.lightAccentColor,
      secondarySelectedColor: ColorsConstant.lightSecondaryColor,
      deleteIconColor: Colors.redAccent,
      secondaryLabelStyle: const TextStyle(),
    ),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: GoogleFonts.poppins(
        color: Colors.black,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ValuesConstant.borderRadius,
        ),
      ),
    ),
    scaffoldBackgroundColor: ColorsConstant.darkBackgroundColor,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: ColorsConstant.darkSecondaryColor,
        systemNavigationBarColor:
            ColorsConstant.darkThemeBottomNavigationBarBackgroundColor,
      ),
      backgroundColor: ColorsConstant.darkAppBarColor,
      elevation: 0,
      toolbarTextStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: ColorsConstant.darkSecondaryColor,
      enableFeedback: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ValuesConstant.borderRadius,
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      modalBackgroundColor: ColorsConstant.darkSecondaryColor,
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
          ColorsConstant.darkThemeBottomNavigationBarBackgroundColor,
      selectedItemColor: Color(0xff03a8fc),
      unselectedItemColor: ColorsConstant.darkThemeButtonColor,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: ColorsConstant.darkSecondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(ValuesConstant.borderRadius),
        ),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme.dark(
        background: ColorsConstant.darkThemeButtonColor,
        primary: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: ColorsConstant.primarySwatch,
      brightness: Brightness.dark,
    ).copyWith(
      secondary: ColorsConstant.darkAccentColor,
      background: ColorsConstant.darkSecondaryColor,
    ),
  );
}
