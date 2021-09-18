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
import 'package:bookology/models/book.model.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/share.service.dart';
import 'package:bookology/ui/components/bottom_sheet_view.component.dart';
import 'package:bookology/ui/screens/about.screen.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomSheetManager {
  final BuildContext context;
  final AuthService authService = AuthService(FirebaseAuth.instance);

  BottomSheetManager(this.context);

  void showBookSelectionBottomSheet({required BookModel book}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => BottomSheetView(
        contents: [
          OutLinedButton(
            text: 'Share this book',
            icon: Icons.share_outlined,
            iconColor: Colors.black,
            textColor: Colors.black,
            outlineColor: Colors.black,
            showText: true,
            showIcon: true,
            alignContent: MainAxisAlignment.start,
            onPressed: () {
              Navigator.pop(context);
              ShareService().shareBook(
                book: book,
              );
            },
          ),
          Visibility(
            visible: authService.currentUser()!.uid == book.uploaderId
                ? false
                : true,
            child: const SizedBox(
              height: 20,
            ),
          ),
          Visibility(
            visible: authService.currentUser()!.uid == book.uploaderId
                ? false
                : true,
            child: OutLinedButton(
              text: 'Report this book',
              showIcon: true,
              showText: true,
              alignContent: MainAxisAlignment.start,
              icon: Icons.report_outlined,
              iconColor: Colors.redAccent,
              textColor: Colors.redAccent,
              outlineColor: ColorsConstant.dangerBorderColor,
              backgroundColor: ColorsConstant.dangerBackgroundColor,
              onPressed: () {},
            ),
          ),
        ],
        height: 200,
      ),
    );
  }

  void showMoreMenuBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => BottomSheetView(
        contents: [
          OutLinedButton(
              text: 'About',
              icon: Icons.info_outlined,
              iconColor: Colors.black,
              textColor: Colors.black,
              outlineColor: Colors.black,
              showText: true,
              showIcon: true,
              alignContent: MainAxisAlignment.start,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  this.context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const AboutScreen(),
                  ),
                );
              }),
          // SizedBox(
          //   height: 20,
          // ),
          // OutLinedButton(
          //   text: 'Report this book',
          //   showIcon: true,
          //   showText: true,
          //   alignContent: MainAxisAlignment.start,
          //   icon: Icons.report_outlined,
          //   iconColor: Colors.redAccent,
          //   textColor: Colors.redAccent,
          //   outlineColor: ColorsConstant.DANGER_BORDER_COLOR,
          //   backgroundColor: ColorsConstant.DANGER_BACKGROUND_COLOR,
          //   onPressed: () {},
          // ),
        ],
        height: 200,
      ),
    );
  }

  void showUpdateAvailableBottomSheet(
      {required String changeLog,
      required VoidCallback onUpdateClicked,
      required VoidCallback onCancelClicked}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => BottomSheetView(
        title: 'Update Available',
        contents: [
          const Text(
            'A new version of the app is available please update to enjoy latest features! ',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'What\'s New?',
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 150,
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
            icon: Icons.share_outlined,
            iconColor: Colors.black,
            textColor: Colors.black,
            outlineColor: Colors.black,
            showText: true,
            showIcon: false,
            alignContent: MainAxisAlignment.center,
            onPressed: onUpdateClicked,
          ),
          const SizedBox(
            height: 20,
          ),
          OutLinedButton(
            text: 'Remind me later',
            showIcon: false,
            showText: true,
            align: Alignment.center,
            alignContent: MainAxisAlignment.center,
            icon: Icons.report_outlined,
            iconColor: Colors.redAccent,
            textColor: Colors.black,
            outlineColor: Colors.black,
            backgroundColor: Colors.grey.shade50,
            onPressed: onCancelClicked,
          ),
        ],
        height: 500,
      ),
    );
  }
}
