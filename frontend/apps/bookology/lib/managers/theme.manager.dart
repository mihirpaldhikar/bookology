// /*
//  * Copyright 2021 Mihir Paldhikar
//  *
//  * Permission is hereby granted, free of charge, to any person obtaining
//  * a copy of this software and associated documentation files (the "Software"),
//  *  to deal in the Software without restriction, including without limitation the
//  *  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  *  copies of the Software, and to permit persons to whom the Software is furnished
//  *  to do so, subject to the following conditions:
//  *
//  * The above copyright notice and this permission notice shall be included in all copies
//  *  or substantial portions of the Software.
//  *
//  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//  * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  * OTHER DEALINGS IN THE SOFTWARE.
//  */
//
// import 'package:bookology/constants/colors.constant.dart';
// import 'package:bookology/constants/values.constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class ThemeManager {
//   static final ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: ColorsConstant.lightThemeContentColor,
//     backgroundColor: const Color(0xffFDFCFF),
//     cardTheme: CardTheme(
//       elevation: 0,
//       color: Colors.white,
//       //shadowColor: Colors.red,
//       shape: RoundedRectangleBorder(
//         side: const BorderSide(
//           color: Colors.grey,
//           width: 0.5,
//         ),
//         borderRadius: BorderRadius.circular(ValuesConstant.borderRadius),
//       ),
//     ),
//     visualDensity: VisualDensity.adaptivePlatformDensity,
//     textTheme: GoogleFonts.poppinsTextTheme(),
//     iconTheme: const IconThemeData(
//       color: Colors.black,
//     ),
//     chipTheme: ChipThemeData(
//       backgroundColor: ColorsConstant.lightSecondaryColor,
//       brightness: Brightness.light,
//       disabledColor: Colors.grey,
//       labelStyle: GoogleFonts.poppins(),
//       shape: RoundedRectangleBorder(
//         side: const BorderSide(
//           color: ColorsConstant.lightAccentColor,
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(100),
//       ),
//       elevation: 0,
//       showCheckmark: false,
//       pressElevation: 2.0,
//       padding: const EdgeInsets.all(4),
//       selectedColor: ColorsConstant.lightAccentColor,
//       secondarySelectedColor: ColorsConstant.lightSecondaryColor,
//       deleteIconColor: Colors.redAccent,
//       secondaryLabelStyle: const TextStyle(),
//     ),
//     snackBarTheme: SnackBarThemeData(
//       contentTextStyle: GoogleFonts.poppins(
//         color: Colors.white,
//       ),
//       actionTextColor: Colors.white,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(
//           ValuesConstant.borderRadius,
//         ),
//       ),
//     ),
//     scaffoldBackgroundColor: const Color(0xffFDFCFF),
//     appBarTheme: AppBarTheme(
//       systemOverlayStyle: const SystemUiOverlayStyle(
//         statusBarIconBrightness: Brightness.dark,
//         statusBarColor: Color(0xffffffff),
//         systemNavigationBarColor: Color(0xffffffff),
//       ),
//       backgroundColor: const Color(0xffFDFCFF),
//       elevation: 0,
//       toolbarTextStyle: GoogleFonts.poppins(
//         color: Colors.black,
//         fontWeight: FontWeight.bold,
//       ),
//       iconTheme: const IconThemeData(
//         color: Colors.black,
//       ),
//       titleTextStyle: GoogleFonts.poppins(
//         color: Colors.black,
//         fontWeight: FontWeight.bold,
//         fontSize: 20,
//       ),
//       actionsIconTheme: const IconThemeData(
//         color: Colors.black,
//       ),
//     ),
//     inputDecorationTheme: const InputDecorationTheme(
//       fillColor: Colors.black,
//     ),
//     popupMenuTheme: PopupMenuThemeData(
//       color: const Color(0xffF1F5FB),
//       enableFeedback: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(
//           ValuesConstant.borderRadius,
//         ),
//       ),
//     ),
//     bottomSheetTheme: const BottomSheetThemeData(
//       modalBackgroundColor: Color(0xffFDFCFF),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(
//             ValuesConstant.borderRadius,
//           ),
//           topLeft: Radius.circular(
//             ValuesConstant.borderRadius,
//           ),
//         ),
//       ),
//     ),
//     navigationBarTheme: NavigationBarThemeData(
//       backgroundColor: const Color(0xffFDFCFF),
//       indicatorColor: const Color(0x2d00629e),
//       labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//       labelTextStyle: MaterialStateProperty.all(
//         const TextStyle(
//           color: Colors.black,
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       height: 80,
//     ),
//     dialogTheme: const DialogTheme(
//       backgroundColor: Color(0xffF1F5FB),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(ValuesConstant.borderRadius),
//         ),
//       ),
//     ),
//     buttonTheme: const ButtonThemeData(
//       textTheme: ButtonTextTheme.primary,
//       colorScheme: ColorScheme.light(
//         background: Color(0x2d00629e),
//         primary: Colors.black,
//       ),
//     ),
//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       backgroundColor: Color(0xff00629E),
//     ),
//     colorScheme: const ColorScheme.light(
//       primary: Color(0xff00629E),
//       onPrimary: Color(0xffFFFFFF),
//       background: Color(0xffFDFCFF),
//       onBackground: Color(0xff1A1C1E),
//       surface: Color(0xffFDFCFF),
//       onSurface: Color(0xff1A1C1E),
//       secondary: Color(0xff526070),
//       onSecondary: Color(0xffFFFFFF),
//       error: Color(0xffBA1B1B),
//       onError: Color(0xffFFFFFF),
//       primaryVariant: Color(0xffCEE5FF),
//       brightness: Brightness.light,
//       secondaryVariant: Color(0xffD5E4F7),
//     ),
//   );
//
//   static final ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: ColorsConstant.lightThemeContentColor,
//     backgroundColor: const Color(0xff1A1C1E),
//     cardTheme: CardTheme(
//       elevation: 0,
//       color: Colors.black,
//       //shadowColor: Colors.red,
//       shape: RoundedRectangleBorder(
//         side: BorderSide(
//           color: Colors.grey.shade700,
//           width: 0.5,
//         ),
//         borderRadius: BorderRadius.circular(ValuesConstant.borderRadius),
//       ),
//     ),
//     visualDensity: VisualDensity.adaptivePlatformDensity,
//     textTheme: GoogleFonts.poppinsTextTheme(),
//     iconTheme: const IconThemeData(
//       color: Colors.white,
//     ),
//     chipTheme: ChipThemeData(
//       backgroundColor: ColorsConstant.lightSecondaryColor,
//       brightness: Brightness.dark,
//       disabledColor: Colors.grey,
//       labelStyle: GoogleFonts.poppins(),
//       shape: RoundedRectangleBorder(
//         side: const BorderSide(
//           color: ColorsConstant.lightAccentColor,
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(100),
//       ),
//       elevation: 0,
//       showCheckmark: false,
//       pressElevation: 2.0,
//       padding: const EdgeInsets.all(4),
//       selectedColor: ColorsConstant.lightAccentColor,
//       secondarySelectedColor: ColorsConstant.lightSecondaryColor,
//       deleteIconColor: Colors.redAccent,
//       secondaryLabelStyle: const TextStyle(),
//     ),
//     snackBarTheme: SnackBarThemeData(
//       contentTextStyle: GoogleFonts.poppins(
//         color: Colors.black,
//       ),
//       actionTextColor: Colors.black,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(
//           ValuesConstant.borderRadius,
//         ),
//       ),
//     ),
//     scaffoldBackgroundColor: const Color(0xff1A1C1E),
//     appBarTheme: AppBarTheme(
//       systemOverlayStyle: const SystemUiOverlayStyle(
//         statusBarIconBrightness: Brightness.light,
//         statusBarColor: Color(0xff1A1C1E),
//         systemNavigationBarColor: Color(0xff1A1C1E),
//       ),
//       backgroundColor: const Color(0xff1A1C1E),
//       elevation: 0,
//       toolbarTextStyle: GoogleFonts.poppins(
//         color: Colors.white,
//         fontWeight: FontWeight.bold,
//       ),
//       iconTheme: const IconThemeData(
//         color: Colors.white,
//       ),
//       titleTextStyle: GoogleFonts.poppins(
//         color: Colors.white,
//         fontWeight: FontWeight.bold,
//         fontSize: 20,
//       ),
//       actionsIconTheme: const IconThemeData(
//         color: Colors.white,
//       ),
//     ),
//     inputDecorationTheme: const InputDecorationTheme(
//       fillColor: Colors.white,
//     ),
//     popupMenuTheme: PopupMenuThemeData(
//       color: const Color(0xff27292b),
//       enableFeedback: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(
//           ValuesConstant.borderRadius,
//         ),
//       ),
//     ),
//     switchTheme: SwitchThemeData(
//       thumbColor: MaterialStateProperty.all(const Color(0xff96CBFF)),
//     ),
//     toggleButtonsTheme: const ToggleButtonsThemeData(
//       fillColor: Color(0xff96CBFF),
//     ),
//     checkboxTheme: CheckboxThemeData(
//         checkColor: MaterialStateProperty.all(Colors.black),
//         fillColor: MaterialStateProperty.all(const Color(0xff96CBFF))),
//     radioTheme: RadioThemeData(
//         fillColor: MaterialStateProperty.all(const Color(0xff96CBFF))),
//     bottomSheetTheme: const BottomSheetThemeData(
//       modalBackgroundColor: Color(0xff1A1C1E),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(
//             ValuesConstant.borderRadius,
//           ),
//           topLeft: Radius.circular(
//             ValuesConstant.borderRadius,
//           ),
//         ),
//       ),
//     ),
//     navigationBarTheme: NavigationBarThemeData(
//       backgroundColor: const Color(0xff1A1C1E),
//       indicatorColor: const Color(0xff243240),
//       labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//       labelTextStyle: MaterialStateProperty.all(
//         const TextStyle(
//           color: Colors.white,
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       height: 80,
//     ),
//     dialogTheme: const DialogTheme(
//       backgroundColor: Color(0xff27292b),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(ValuesConstant.borderRadius),
//         ),
//       ),
//     ),
//     buttonTheme: const ButtonThemeData(
//       textTheme: ButtonTextTheme.primary,
//       colorScheme: ColorScheme.dark(
//         background: Color(0xff243240),
//         primary: Colors.white,
//       ),
//     ),
//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       backgroundColor: Color(0xff96CBFF),
//     ),
//     colorScheme: const ColorScheme.light(
//       primary: Color(0xff96CBFF),
//       onPrimary: Color(0xff003355),
//       background: Color(0xff1A1C1E),
//       onBackground: Color(0xffE2E2E6),
//       surface: Color(0xff1A1C1E),
//       onSurface: Color(0xffE2E2E6),
//       secondary: Color(0xffB9C8DA),
//       onSecondary: Color(0xff243240),
//       error: Color(0xffFFB4A9),
//       onError: Color(0xff680003),
//       primaryVariant: Color(0xff004A79),
//       brightness: Brightness.dark,
//       secondaryVariant: Color(0xff3A4857),
//     ),
//   );
// }
