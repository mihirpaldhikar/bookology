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
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/managers/permission.manager.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/ui/screens/edit_profile.screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _introKey = GlobalKey<IntroductionScreenState>();
  final AuthService _authService = AuthService(FirebaseAuth.instance);
  final _pageDecoration = const PageDecoration(
    titleTextStyle: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      color: ColorsConstant.lightThemeContentColor,
    ),
    bodyTextStyle: TextStyle(
      fontSize: 19.0,
      color: ColorsConstant.lightThemeContentColor,
    ),
    descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    pageColor: Colors.white,
    imagePadding: EdgeInsets.zero,
  );

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<PageViewModel> introPages = [
      PageViewModel(
        titleWidget: Text(
          "Welcome to Bookology!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        bodyWidget: const Text(
          'Find the books you want nearby.',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        decoration: _pageDecoration,
        image: const Center(
          child: Image(
            image: AssetImage('assets/icons/splash.icon.png'),
            width: 250,
            height: 250,
          ),
        ),
      ),
      PageViewModel(
        title: "Help Others",
        bodyWidget: const Text(
          'Upload the books you don\'t want anymore and give it to some one in need.',
          textAlign: TextAlign.center,
        ),
        decoration: _pageDecoration,
        image: Center(
          child: SvgPicture.asset(
            'assets/svg/help.svg',
            width: 250,
            height: 250,
          ),
        ),
      ),
      PageViewModel(
        title: "Location based Recommendations",
        bodyWidget: const Text(
          'Bookology uses your approximate location to show you books listed near you.',
          textAlign: TextAlign.center,
        ),
        decoration: _pageDecoration,
        image: Center(
          child: SvgPicture.asset(
            'assets/svg/location.svg',
            width: 250,
            height: 250,
          ),
        ),
      ),
      PageViewModel(
        title: "Complete your Profile",
        bodyWidget: const Text(
          'By completing profile, your are ready to start uploading the books! and other users trusts on your uploaded books. ',
          textAlign: TextAlign.center,
        ),
        decoration: _pageDecoration,
        image: Center(
          child: SvgPicture.asset(
            'assets/svg/profile.svg',
            width: 250,
            height: 250,
          ),
        ),
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          key: _introKey,
          globalBackgroundColor: ColorsConstant.backgroundColor,
          showDoneButton: true,
          showNextButton: true,
          showSkipButton: false,
          onDone: () => _onIntroEnd(context),
          onChange: (pageIndex) {
            if (pageIndex == 3) {
              DialogsManager(context).showLocationPermissionDialog(() {
                PermissionManager()
                    .requestPermission(Permission.locationWhenInUse);
                Navigator.pop(context);
              });
            }
          },
          done: Container(
            width: 250,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 8,
              left: 8,
            ),
            decoration: BoxDecoration(
              color: ColorsConstant.secondaryColor,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
              borderRadius:
                  BorderRadius.circular(ValuesConstant.secondaryBorderRadius),
            ),
            child: Text(
              'Complete Profile',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          next: Container(
            width: 200,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 8,
              left: 8,
            ),
            decoration: BoxDecoration(
              color: ColorsConstant.secondaryColor,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
              borderRadius:
                  BorderRadius.circular(ValuesConstant.secondaryBorderRadius),
            ),
            child: Text(
              'Next',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          pages: introPages,
          dotsDecorator: DotsDecorator(
            color: Colors.grey.shade400,
            activeColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }

  void _onIntroEnd(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          userID: _authService.currentUser()!.uid,
          profilePicture: _authService.currentUser()!.photoURL.toString(),
          userName: _authService.currentUser()!.email!.split('@')[0],
          bio: '',
          firstName: '',
          lastName: '',
          isInitialUpdate: true,
        ),
      ),
    );
  }
}
