import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatUiManager extends ChatTheme {
  ChatUiManager()
      : super(
            primaryColor: Color(0xffEEEEEE),
            secondaryColor: Color(0xFF546E7A),
            backgroundColor: Colors.white,
            messageBorderRadius: 35,
            receivedMessageBodyTextStyle: GoogleFonts.poppins(
              color: Colors.white,
            ),
            sentMessageBodyTextStyle: GoogleFonts.poppins(
              color: Colors.black,
            ),
            sendButtonIcon: Icon(
              Icons.send_outlined,
              size: 28,
            ),
            deliveredIcon: Icon(
              Icons.done_outlined,
              size: 15,
            ),
            seenIcon: Icon(
              Icons.done_all_outlined,
              size: 17,
              color: Colors.green,
            ),
            inputBackgroundColor: Colors.white,
            documentIcon: Icon(
              Icons.description_outlined,
            ),
            inputBorderRadius: BorderRadius.circular(100),
            dateDividerTextStyle: GoogleFonts.poppins(),
            attachmentButtonIcon: Icon(
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
              color: Color(0xFF757575),
            ),
            sentMessageLinkDescriptionTextStyle: GoogleFonts.poppins(),
            sentMessageLinkTitleTextStyle: GoogleFonts.poppins(),
            errorColor: Colors.red,
            errorIcon: Icon(
              Icons.error_outlined,
            ),
            receivedMessageDocumentIconColor: Colors.white,
            userAvatarNameColors: [
              Color(0xffff6767),
              Color(0xff66e0da),
              Color(0xfff5a2d9),
              Color(0xfff0c722),
              Color(0xff6a85e5),
              Color(0xfffd9a6f),
              Color(0xff92db6e),
              Color(0xff73b8e5),
              Color(0xfffd7590),
              Color(0xffc78ae5),
            ]);
}
