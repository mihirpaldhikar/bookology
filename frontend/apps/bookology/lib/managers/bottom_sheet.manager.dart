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

import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/managers/bottom_sheet_view.manager.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/managers/toast.manager.dart';
import 'package:bookology/services/app.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/themes/bookology.theme.dart';
import 'package:bookology/ui/screens/about.screen.dart';
import 'package:bookology/ui/screens/saved.screen.dart';
import 'package:bookology/ui/screens/search.screen.dart';
import 'package:bookology/ui/screens/settings.screen.dart';
import 'package:bookology/ui/widgets/image_container.widget.dart';
import 'package:bookology/ui/widgets/rounded_button.widget.dart';
import 'package:bookology/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_feedback/flutter_app_feedback.dart';
import 'package:provider/provider.dart';

class BottomSheetManager {
  final BuildContext context;
  final authService = AuthService(FirebaseAuth.instance);

  BottomSheetManager(this.context);

  void showThemeBottomSheet() {
    BottomSheetViewManager(context).createBottomSheet(
      title: 'Choose Theme',
      contents: [
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            ThemeMode _theme = PreferencesManager().getCurrentTheme();
            final _themeProvider =
                Provider.of<BookologyThemeProvider>(context, listen: true);
            return Column(
              children: [
                RadioListTile(
                  title: const Text('Always in light theme'),
                  value: ThemeMode.light,
                  groupValue: _theme,
                  onChanged: (ThemeMode? value) {
                    setState(() {
                      _theme = value!;
                      _themeProvider.setTheme(theme: _theme);
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('Always in dark theme'),
                  value: ThemeMode.dark,
                  groupValue: _theme,
                  onChanged: (ThemeMode? value) {
                    setState(() {
                      _theme = value!;
                      _themeProvider.setTheme(theme: _theme);
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('Same as device theme'),
                  value: ThemeMode.system,
                  groupValue: _theme,
                  onChanged: (ThemeMode? value) {
                    setState(() {
                      _theme = value!;
                      _themeProvider.setTheme(theme: _theme);
                    });
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void showMoreProfileMenuBottomSheet() {
    BottomSheetViewManager(context).createBottomSheet(
      contents: [
        const SizedBox(
          height: 20,
        ),
        RoundedButton(
          text: 'Saved Books',
          icon: const Icon(Icons.bookmark_border),
          alignContent: MainAxisAlignment.start,
          backgroundColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const SavedScreen(),
              ),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        RoundedButton(
          text: 'Settings',
          icon: const Icon(Icons.settings_outlined),
          alignContent: MainAxisAlignment.start,
          backgroundColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const SettingsScreen(),
              ),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        RoundedButton(
          text: 'About',
          icon: const Icon(Icons.info_outlined),
          alignContent: MainAxisAlignment.start,
          backgroundColor: Colors.transparent,
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
          height: 10,
        ),
        RoundedButton(
          onPressed: () {
            Navigator.pop(context);
            DialogsManager(context).showLogoutDialog(onLogoutClicked: () {
              authService.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/auth',
                (_) => false,
              );
            });
          },
          text: StringConstants.wordLogout,
          icon: const Icon(Icons.logout_outlined),
          alignContent: MainAxisAlignment.start,
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                final _appService = await AppService().getAppInfo();
                Navigator.pop(context);
                await launchURL(
                    url: 'mailto:imihirpaldhikar@gmail.com?'
                        'subject=Bookology%20Support&'
                        'body=App%20Version:%20${_appService.appVersion}\n'
                        'Build%20Number:%20${_appService.appBuildNumber}\n\nI%20want%20help%20for ');
              },
              child: Text(
                StringConstants.wordSupport,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 13,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                DialogsManager(context)
                    .showProgressDialog(content: 'Generating Report...');
                final screenshot =
                    await FeedbackScreenshot(context).captureScreen(
                  screen: MediaQuery(
                    data: const MediaQueryData(),
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme: Theme.of(context),
                      home: const SearchScreen(),
                    ),
                  ),
                );
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => FeedbackScreen(
                      reportType: 'User initiated report',
                      isEmailEditable: false,
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      fromEmail: FirebaseAuth.instance.currentUser!.email,
                      screenShotPath: screenshot,
                      feedbackFooterText:
                          'In order to improve the app, along with your feedback, Some System Logs will be sent to Developer.',
                      onFeedbackSubmissionStarted: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        DialogsManager(context)
                            .showProgressDialog(content: 'Submitting');
                      },
                      onFeedbackSubmitted: (bool result) {
                        if (result) {
                          Navigator.pop(context);
                          FocusManager.instance.primaryFocus?.unfocus();
                          ToastManager(context)
                              .showToast(message: 'Feedback submitted');
                          Navigator.of(context).pop();
                          FocusManager.instance.primaryFocus?.unfocus();
                        } else {
                          Navigator.pop(context);
                          FocusManager.instance.primaryFocus?.unfocus();
                          ToastManager(context)
                              .showToast(message: 'Failed to submit feedback');
                          Navigator.of(context).pop();
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      },
                    ),
                  ),
                );
              },
              child: Text(
                StringConstants.wordSendFeedback,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void showUpdateAvailableBottomSheet(
      {required String changeLog,
      required VoidCallback onUpdateClicked,
      required VoidCallback onCancelClicked}) {
    BottomSheetViewManager(context).createBottomSheet(
      title: 'Update Available',
      contents: [
        Text(
          'A new version of the app is available please update to enjoy latest features! ',
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).inputDecorationTheme.fillColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            'What\'s New?',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).inputDecorationTheme.fillColor,
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
              Text(
                changeLog,
                style: TextStyle(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                ),
              ),
            ],
          ),
        ),
        RoundedButton(
          text: 'Update',
          textColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
          align: Alignment.center,
          alignContent: MainAxisAlignment.center,
          onPressed: onUpdateClicked,
        ),
        const SizedBox(
          height: 20,
        ),
        RoundedButton(
          text: 'Remind me later',
          align: Alignment.center,
          alignContent: MainAxisAlignment.center,
          backgroundColor: Colors.transparent,
          outlineWidth: ValuesConstant.outlineWidth,
          textColor: Theme.of(context).colorScheme.primary,
          onPressed: onCancelClicked,
        ),
      ],
    );
  }

  void imagePickerBottomSheet({
    required VoidCallback onCameraPressed,
    required VoidCallback onGalleryPressed,
  }) {
    BottomSheetViewManager(context).createBottomSheet(
      title: 'Pick Image From',
      contents: [
        RoundedButton(
          onPressed: onCameraPressed,
          text: 'Camera',
          icon: const Icon(Icons.photo_camera_outlined),
          backgroundColor: Colors.transparent,
          alignContent: MainAxisAlignment.start,
        ),
        const SizedBox(
          height: 10,
        ),
        RoundedButton(
          onPressed: onGalleryPressed,
          text: 'Gallery',
          icon: const Icon(Icons.collections_outlined),
          backgroundColor: Colors.transparent,
          alignContent: MainAxisAlignment.start,
        ),
      ],
    );
  }

  void filePickerBottomSheet({
    required VoidCallback onImagePressed,
    required VoidCallback onFilePressed,
  }) {
    BottomSheetViewManager(context).createBottomSheet(
      title: 'Pick Attachment From',
      contents: [
        RoundedButton(
          onPressed: onImagePressed,
          text: StringConstants.wordImage,
          icon: const Icon(Icons.image_outlined),
          alignContent: MainAxisAlignment.start,
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(
          height: 10,
        ),
        RoundedButton(
          onPressed: onFilePressed,
          text: StringConstants.wordFile,
          icon: const Icon(Icons.note_add_outlined),
          alignContent: MainAxisAlignment.start,
          backgroundColor: Colors.transparent,
        ),
      ],
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
      title: 'Confirm Book Details',
      alignment: CrossAxisAlignment.start,
      contents: [
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            text: '${StringConstants.wordIsbn}:  ',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            children: [
              TextSpan(
                text: isbn,
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            children: [
              TextSpan(
                text: bookName,
                style: const TextStyle(
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            children: [
              TextSpan(
                text: bookAuthor,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            children: [
              TextSpan(
                text: bookPublisher,
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).colorScheme.onBackground,
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 17,
            ),
            children: [
              TextSpan(
                text: bookDescription.trim(),
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).colorScheme.onBackground,
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                children: [
                  TextSpan(
                    text: bookOriginalPrice,
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.onBackground,
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
                children: [
                  TextSpan(
                    text: bookSellingPrice,
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.onBackground,
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
            Text(
              'Book Images:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Theme.of(context).colorScheme.onBackground,
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
        RoundedButton(
          text: StringConstants.wordUpload,
          onPressed: onUploadClicked,
          icon: Icon(
            Icons.cloud_upload_outlined,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          textColor: Theme.of(context).colorScheme.onPrimary,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
