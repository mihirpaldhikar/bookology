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

import 'package:flutter/material.dart';

class ColorsConstant {
  static const MaterialColor PRIMARY_SWATCH = MaterialColor(
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

  static const Color ACCENT_COLOR = Color(0xff2E79F3);

  static const Color SECONDARY_COLOR = Color(0xFFF2F6FE);

  static const Color DANGER_BORDER_COLOR = Colors.redAccent;

  static const Color DANGER_BACKGROUND_COLOR = Color(0xffFFEBEE);

  static const Color BACKGROUND_COLOR = Color(0xFFFFFFFF);

  static const Color DARK_COLOR = Color(0xFF07357E);

  static const Color CARD_COLOR = Color(0xFFffffff);

  static const Color APP_BAR_BUTTONS_BACKGROUND = Color(0xFF4285F4);

  static const Color BUTTON_TEXT_COLOR = ACCENT_COLOR;

  static const Color APP_BAR_COLOR = Color(0xFFF2F6FE);

  static const Color STATUS_BAR_COLOR = Color(0xFFF2F6FE);

  static const Color LIGHT_THEME_CONTENT_COLOR = Colors.black;
}
