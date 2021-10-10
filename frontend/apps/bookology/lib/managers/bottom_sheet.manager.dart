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
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/managers/bottom_sheet_view.manager.dart';
import 'package:bookology/models/book.model.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/share.service.dart';
import 'package:bookology/ui/screens/about.screen.dart';
import 'package:bookology/ui/widgets/image_container.widget.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomSheetManager {
  final BuildContext context;
  final AuthService authService = AuthService(FirebaseAuth.instance);

  BottomSheetManager(this.context);

  void showBookSelectionBottomSheet({required BookModel book}) {
    BottomSheetViewManager(context).createBottomSheet(
      contents: [
        OutLinedButton(
          text: 'Share this book',
          icon: Icons.share_outlined,
          iconColor: Colors.black,
          textColor: Colors.black,
          alignContent: MainAxisAlignment.start,
          onPressed: () {
            Navigator.pop(context);
            ShareService().shareBook(
              book: book,
            );
          },
        ),
        Visibility(
          visible:
              authService.currentUser()!.uid == book.uploaderId ? false : true,
          child: const SizedBox(
            height: 20,
          ),
        ),
        Visibility(
          visible:
              authService.currentUser()!.uid == book.uploaderId ? false : true,
          child: OutLinedButton(
            text: 'Report this book',
            alignContent: MainAxisAlignment.start,
            icon: Icons.report_outlined,
            iconColor: Colors.redAccent,
            textColor: Colors.redAccent,
            backgroundColor: ColorsConstant.dangerBackgroundColor,
            onPressed: () {},
          ),
        ),
      ],
      height: 200,
    );
  }

  void showMoreProfileMenuBottomSheet() {
    BottomSheetViewManager(context).createBottomSheet(
      contents: [
        const SizedBox(
          height: 20,
        ),
        OutLinedButton(
          text: 'About',
          icon: Icons.info_outlined,
          iconColor: Colors.black,
          textColor: Colors.black,
          alignContent: MainAxisAlignment.start,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const AboutScreen(),
              ),
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
        OutLinedButton(
          onPressed: () {
            authService.signOut();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/auth',
              (_) => false,
            );
          },
          text: StringConstants.wordLogout,
          icon: Icons.logout_outlined,
          iconColor: Theme.of(context).primaryColor,
          backgroundColor: ColorsConstant.dangerBackgroundColor,
          alignContent: MainAxisAlignment.start,
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Text(
              StringConstants.wordSupport,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
            Text(
              StringConstants.wordContactUs,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        )
      ],
      height: 250,
    );
  }

  void showUpdateAvailableBottomSheet(
      {required String changeLog,
      required VoidCallback onUpdateClicked,
      required VoidCallback onCancelClicked}) {
    BottomSheetViewManager(context).createBottomSheet(
      title: 'Update Available',
      contents: [
        const Text(
          'A new version of the app is available please update to enjoy latest features! ',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        const Align(
          alignment: Alignment.center,
          child: Text(
            'What\'s New?',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 170,
          width: double.infinity,
          child: ListView(
            children: [
              Text(changeLog),
            ],
          ),
        ),
        OutLinedButton(
          text: 'Update',
          align: Alignment.center,
          alignContent: MainAxisAlignment.center,
          onPressed: onUpdateClicked,
        ),
        const SizedBox(
          height: 20,
        ),
        OutLinedButton(
          text: 'Remind me later',
          align: Alignment.center,
          alignContent: MainAxisAlignment.center,
          backgroundColor: Colors.grey.shade200,
          onPressed: onCancelClicked,
        ),
      ],
      height: 550,
    );
  }

  void imagePickerBottomSheet({
    required VoidCallback onCameraPressed,
    required VoidCallback onGalleryPressed,
  }) {
    BottomSheetViewManager(context).createBottomSheet(
      title: 'Pick Image From',
      contents: [
        OutLinedButton(
          onPressed: onCameraPressed,
          text: 'Camera',
          icon: Icons.photo_camera_outlined,
          iconColor: Colors.black,
          alignContent: MainAxisAlignment.start,
        ),
        const SizedBox(
          height: 20,
        ),
        OutLinedButton(
          onPressed: onGalleryPressed,
          text: 'Gallery',
          icon: Icons.collections_outlined,
          iconColor: Colors.black,
          alignContent: MainAxisAlignment.start,
        ),
      ],
      height: 250,
    );
  }

  void filePickerBottomSheet({
    required VoidCallback onImagePressed,
    required VoidCallback onFilePressed,
  }) {
    BottomSheetViewManager(context).createBottomSheet(
      title: 'Pick Attachment From',
      contents: [
        OutLinedButton(
          onPressed: onImagePressed,
          text: StringConstants.wordImage,
          icon: Icons.image_outlined,
          iconColor: Colors.black,
          alignContent: MainAxisAlignment.start,
        ),
        const SizedBox(
          height: 20,
        ),
        OutLinedButton(
          onPressed: onFilePressed,
          text: StringConstants.wordFile,
          icon: Icons.note_add_outlined,
          iconColor: Colors.black,
          alignContent: MainAxisAlignment.start,
        ),
      ],
      height: 250,
    );
  }

  void showUploadBookConfirmationBottomSheet({
    required String isbn,
    required String bookName,
    required String bookAuthor,
    required String bookPublisher,
    required String bookDescription,
    required String bookOriginalPrice,
    required String bookSellingPrice,
    required String bookCondition,
    required String bookImage1,
    required String bookImage2,
    required String bookImage3,
    required String bookImage4,
    required VoidCallback onUploadClicked,
  }) {
    BottomSheetViewManager(context).createBottomSheet(
      height: 810,
      title: 'Confirm Book Details',
      alignment: CrossAxisAlignment.start,
      contents: [
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            text: '${StringConstants.wordIsbn}:  ',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            children: [
              TextSpan(
                text: isbn,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        RichText(
          text: TextSpan(
            text: '${StringConstants.wordBookName}:  ',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            children: [
              TextSpan(
                text: bookName,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        RichText(
          text: TextSpan(
            text: '${StringConstants.wordAuthor}:  ',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            children: [
              TextSpan(
                text: bookAuthor,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        RichText(
          text: TextSpan(
            text: '${StringConstants.wordPublisher}:  ',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            children: [
              TextSpan(
                text: bookPublisher,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        RichText(
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          text: TextSpan(
            text: '${StringConstants.wordDescription}:  ',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            children: [
              TextSpan(
                text: bookDescription.trim(),
                style: GoogleFonts.poppins(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            RichText(
              text: TextSpan(
                text: '${StringConstants.wordOriginalPrice}:  ',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
                children: [
                  TextSpan(
                    text: bookOriginalPrice,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            RichText(
              text: TextSpan(
                text: '${StringConstants.wordSellingPrice}:  ',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
                children: [
                  TextSpan(
                    text: bookSellingPrice,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Book Images:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GridView.count(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              mainAxisSpacing: 40,
              children: [
                Center(
                  child: ImageHolder(
                    onPressed: () {},
                    onCancelled: () {},
                    imageURL: bookImage1,
                    showCloseButton: false,
                  ),
                ),
                Center(
                  child: ImageHolder(
                    onPressed: () {},
                    onCancelled: () {},
                    imageURL: bookImage2,
                    showCloseButton: false,
                  ),
                ),
                Center(
                  child: ImageHolder(
                    onPressed: () {},
                    onCancelled: () {},
                    imageURL: bookImage3,
                    showCloseButton: false,
                  ),
                ),
                Center(
                  child: ImageHolder(
                    onPressed: () {},
                    onCancelled: () {},
                    imageURL: bookImage4,
                    showCloseButton: false,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        OutLinedButton(
          text: StringConstants.wordUpload,
          onPressed: onUploadClicked,
          icon: Icons.cloud_upload_outlined,
          iconColor: Theme.of(context).primaryColor,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
