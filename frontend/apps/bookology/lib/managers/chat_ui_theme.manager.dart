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
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatUiThemeManager extends ChatTheme {
  ChatUiThemeManager({required BuildContext context})
      : super(
          primaryColor: Theme.of(context).colorScheme.primary,
          secondaryColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).colorScheme.background,
          messageBorderRadius: 35,
          receivedMessageBodyTextStyle: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          sentMessageBodyTextStyle: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          sendButtonIcon: const Icon(
            Icons.send_outlined,
            size: 28,
          ),
          deliveredIcon: const Icon(
            Icons.done_outlined,
            size: 15,
          ),
          seenIcon: const Icon(
            Icons.done_all_outlined,
            size: 17,
            color: Colors.green,
          ),
          sendingIcon: const Icon(
            Icons.send_outlined,
            size: 28,
          ),
          inputBackgroundColor: Theme.of(context).colorScheme.surface,
          documentIcon: const Icon(
            Icons.description_outlined,
          ),
          inputPadding: const EdgeInsets.all(0),
          inputTextDecoration: const InputDecoration(),
          inputBorderRadius: BorderRadius.circular(ValuesConstant.borderRadius),
          dateDividerTextStyle: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          attachmentButtonIcon: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          inputTextColor: Theme.of(context).colorScheme.onSurface,
          inputTextStyle: GoogleFonts.poppins(),
          sentMessageDocumentIconColor: Theme.of(context).colorScheme.primary,
          emptyChatPlaceholderTextStyle: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          userNameTextStyle: GoogleFonts.poppins(),
          receivedMessageCaptionTextStyle: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          userAvatarTextStyle: GoogleFonts.poppins(),
          receivedMessageLinkDescriptionTextStyle: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          receivedMessageLinkTitleTextStyle: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          sentMessageCaptionTextStyle: GoogleFonts.poppins(
            color: const Color(0xFF757575),
          ),
          messageInsetsHorizontal: 15.0,
          messageInsetsVertical: 15.0,
          sentMessageLinkDescriptionTextStyle: GoogleFonts.poppins(
              color: Theme.of(context).colorScheme.onPrimary),
          sentMessageLinkTitleTextStyle: GoogleFonts.poppins(
              color: Theme.of(context).colorScheme.onPrimary),
          errorColor: Colors.red,
          errorIcon: const Icon(
            Icons.error_outlined,
          ),
          inputTextCursorColor: Theme.of(context).colorScheme.primary,
          dateDividerMargin: const EdgeInsets.only(
            top: 5,
            bottom: 20,
          ),
          receivedEmojiMessageTextStyle: const TextStyle(),
          sentEmojiMessageTextStyle: const TextStyle(),
          statusIconPadding: const EdgeInsets.all(8),
          userAvatarImageBackgroundColor:
              Theme.of(context).colorScheme.tertiary,
          receivedMessageDocumentIconColor: Colors.white,
          userAvatarNameColors: [
            const Color(0xffff6767),
            const Color(0xff66e0da),
            const Color(0xfff5a2d9),
            const Color(0xfff0c722),
            const Color(0xff6a85e5),
            const Color(0xfffd9a6f),
            const Color(0xff92db6e),
            const Color(0xff73b8e5),
            const Color(0xfffd7590),
            const Color(0xffc78ae5),
          ],
        );
}
