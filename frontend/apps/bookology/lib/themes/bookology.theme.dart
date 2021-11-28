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

import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookologyThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = PreferencesManager().getCurrentTheme();

  bool isDarkTheme({required BuildContext context}) =>
      Theme.of(context).brightness == Brightness.dark;

  void setTheme({required ThemeMode theme}) {
    themeMode = theme;
    PreferencesManager().setCurrentThemeMode(themeMode: theme);
    notifyListeners();
  }
}

class BookologyTheme {
  static ThemeData getThemeData({required ColorScheme colorScheme}) {
    return ThemeData(
      brightness: colorScheme.brightness,
      fontFamily: 'Poppins',
      visualDensity: VisualDensity.adaptivePlatformDensity,
      iconTheme: IconThemeData(
        color: colorScheme.brightness == Brightness.light
            ? Colors.black
            : Colors.white,
      ),
      splashColor: colorScheme.brightness == Brightness.light
          ? Colors.grey.shade100
          : Colors.black54,
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(
          color: colorScheme.brightness == Brightness.light
              ? Colors.white
              : Colors.black,
        ),
        actionTextColor: colorScheme.brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ValuesConstant.borderRadius,
          ),
        ),
      ),
      scaffoldBackgroundColor: ThemeData.from(
        colorScheme: colorScheme,
      ).colorScheme.background,
      backgroundColor: ThemeData.from(
        colorScheme: colorScheme,
      ).colorScheme.background,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ThemeData.from(
          colorScheme: colorScheme,
        ).colorScheme.primary,
        foregroundColor: ThemeData.from(
          colorScheme: colorScheme,
        ).colorScheme.onPrimary,
        enableFeedback: true,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: ThemeData.from(
          colorScheme: colorScheme,
        ).colorScheme.onInverseSurface,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: ThemeData.from(
              colorScheme: colorScheme,
            ).colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(
            ValuesConstant.borderRadius,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ThemeData.from(
          colorScheme: colorScheme,
        ).colorScheme.surface,
        height: 70,
        indicatorColor: ThemeData.from(
          colorScheme: colorScheme,
        ).colorScheme.primaryContainer,
        iconTheme: MaterialStateProperty.all(
          IconThemeData(
            color: colorScheme.brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colorScheme.brightness == Brightness.light
            ? Colors.black
            : Colors.white,
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: colorScheme.brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
        elevation: 0,
        backgroundColor: ThemeData.from(
          colorScheme: colorScheme,
        ).colorScheme.background,
        actionsIconTheme: IconThemeData(
          color: colorScheme.brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
        titleTextStyle: GoogleFonts.poppins(
          color: colorScheme.brightness == Brightness.light
              ? Colors.black
              : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: ThemeData.from(
          colorScheme: colorScheme,
        ).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(ValuesConstant.borderRadius),
          ),
        ),
        titleTextStyle: TextStyle(
          color: colorScheme.brightness == Brightness.light
              ? Colors.black
              : Colors.white,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: colorScheme.brightness == Brightness.light
              ? Colors.black
              : Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(ValuesConstant.borderRadius),
          ),
        ),
        textTheme: ButtonTextTheme.normal,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(
              ValuesConstant.borderRadius,
            ),
            topLeft: Radius.circular(
              ValuesConstant.borderRadius,
            ),
          ),
        ),
        backgroundColor: ThemeData.from(
          colorScheme: colorScheme,
        ).colorScheme.surface,
        modalBackgroundColor: ThemeData.from(
          colorScheme: colorScheme,
        ).colorScheme.surface,
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ValuesConstant.borderRadius),
        ),
        color: ThemeData.from(
          colorScheme: colorScheme,
        ).colorScheme.onSurface,
        textStyle: TextStyle(
          color: colorScheme.brightness == Brightness.light
              ? Colors.black
              : Colors.white,
          fontWeight: FontWeight.normal,
        ),
        enableFeedback: true,
      ),
      colorScheme: colorScheme,
    );
  }

}
