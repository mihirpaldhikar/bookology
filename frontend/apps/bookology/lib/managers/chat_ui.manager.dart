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
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class LightChatUi extends ChatTheme {
  LightChatUi()
      : super(
            primaryColor: const Color(0xffEEEEEE),
            secondaryColor: const Color(0xff2E79F3),
            backgroundColor: Colors.white,
            messageBorderRadius: 35,
            receivedMessageBodyTextStyle: GoogleFonts.poppins(
              color: Colors.white,
            ),
            sentMessageBodyTextStyle: GoogleFonts.poppins(
              color: Colors.black,
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
            inputBackgroundColor:
                ColorsConstant.lightThemeBottomNavigationBarBackgroundColor,
            documentIcon: const Icon(
              Icons.description_outlined,
            ),
            inputPadding: const EdgeInsets.all(0),
            inputTextDecoration: const InputDecoration(),
            inputBorderRadius: BorderRadius.circular(100),
            dateDividerTextStyle: GoogleFonts.poppins(
              color: Colors.black,
            ),
            attachmentButtonIcon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            inputTextColor: Colors.black,
            inputTextStyle: GoogleFonts.poppins(),
            sentMessageDocumentIconColor: Colors.white,
            emptyChatPlaceholderTextStyle: GoogleFonts.poppins(),
            userNameTextStyle: GoogleFonts.poppins(),
            receivedMessageCaptionTextStyle: GoogleFonts.poppins(
              color: Colors.grey.shade300,
            ),
            userAvatarTextStyle: GoogleFonts.poppins(),
            receivedMessageLinkDescriptionTextStyle:
                GoogleFonts.poppins(color: Colors.white),
            receivedMessageLinkTitleTextStyle: GoogleFonts.poppins(
              color: Colors.white,
            ),
            sentMessageCaptionTextStyle: GoogleFonts.poppins(
              color: const Color(0xFF757575),
            ),
            messageInsetsHorizontal: 15.0,
            messageInsetsVertical: 15.0,
            sentMessageLinkDescriptionTextStyle: GoogleFonts.poppins(),
            sentMessageLinkTitleTextStyle: GoogleFonts.poppins(),
            errorColor: Colors.red,
            errorIcon: const Icon(
              Icons.error_outlined,
            ),
            userAvatarImageBackgroundColor: ColorsConstant.lightAccentColor,
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
            ]);
}

class DarkChatUi extends ChatTheme {
  DarkChatUi()
      : super(
            primaryColor: const Color(0xffEEEEEE),
            secondaryColor: const Color(0xff2E79F3),
            backgroundColor: Colors.black,
            messageBorderRadius: 35,
            receivedMessageBodyTextStyle: GoogleFonts.poppins(
              color: Colors.white,
            ),
            sentMessageBodyTextStyle: GoogleFonts.poppins(
              color: Colors.black,
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
            inputBackgroundColor:
                ColorsConstant.darkThemeBottomNavigationBarBackgroundColor,
            documentIcon: const Icon(
              Icons.description_outlined,
            ),
            inputPadding: const EdgeInsets.all(0),
            inputTextDecoration: const InputDecoration(),
            inputBorderRadius: BorderRadius.circular(100),
            dateDividerTextStyle: GoogleFonts.poppins(
              color: Colors.white,
            ),
            attachmentButtonIcon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            inputTextColor: Colors.white,
            inputTextStyle: GoogleFonts.poppins(),
            sentMessageDocumentIconColor: Colors.white,
            emptyChatPlaceholderTextStyle: GoogleFonts.poppins(),
            userNameTextStyle: GoogleFonts.poppins(),
            receivedMessageCaptionTextStyle: GoogleFonts.poppins(
              color: Colors.grey.shade300,
            ),
            userAvatarTextStyle: GoogleFonts.poppins(),
            receivedMessageLinkDescriptionTextStyle:
                GoogleFonts.poppins(color: Colors.white),
            receivedMessageLinkTitleTextStyle: GoogleFonts.poppins(
              color: Colors.white,
            ),
            sentMessageCaptionTextStyle: GoogleFonts.poppins(
              color: const Color(0xFF757575),
            ),
            messageInsetsHorizontal: 15.0,
            messageInsetsVertical: 15.0,
            sentMessageLinkDescriptionTextStyle: GoogleFonts.poppins(),
            sentMessageLinkTitleTextStyle: GoogleFonts.poppins(),
            errorColor: Colors.red,
            errorIcon: const Icon(
              Icons.error_outlined,
            ),
            userAvatarImageBackgroundColor: ColorsConstant.lightAccentColor,
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
            ]);
}
