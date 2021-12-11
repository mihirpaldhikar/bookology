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
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/managers/permission.manager.dart';
import 'package:bookology/managers/view.manager.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/screens/edit_profile.screen.dart';
import 'package:bookology/ui/widgets/app_logo.widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({
    Key? key,
  }) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _introKey = GlobalKey<IntroductionScreenState>();
  final AuthService _authService = AuthService(FirebaseAuth.instance);
  final PreferencesManager _cacheService = PreferencesManager();

  @override
  Widget build(BuildContext context) {
    final _pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
      ),
      bodyTextStyle: const TextStyle(
        fontSize: 19.0,
      ),
      descriptionPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Theme.of(context).scaffoldBackgroundColor,
      imagePadding: EdgeInsets.zero,
    );
    final List<PageViewModel> introPages = [
      PageViewModel(
        title: 'Welcome to Bookology!',
        bodyWidget: const Text(
          'Find the books you want nearby.',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        decoration: _pageDecoration,
        image: Container(
          padding: const EdgeInsets.all(120),
          child: Center(
            child: SizedBox(
              width: 500,
              height: 500,
              child: AppLogo(
                context: context,
              ),
            ),
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
          scrollPhysics: const BouncingScrollPhysics(),
          key: _introKey,
          globalBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              color: Theme.of(context).colorScheme.primary,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 0,
              ),
              borderRadius: BorderRadius.circular(
                ValuesConstant.buttonBorderRadius,
              ),
            ),
            child: Text(
              'Next',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
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
              color: Theme.of(context).colorScheme.primary,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 0,
              ),
              borderRadius: BorderRadius.circular(
                ValuesConstant.buttonBorderRadius,
              ),
            ),
            child: Text(
              'Next',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          pages: introPages,
          dotsDecorator: DotsDecorator(
            color: Colors.grey.shade400,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  void _onIntroEnd(context) async {
    final currentUserData = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .get();

    final isNewUser = await currentUserData.data()!['isNewUser'] ?? true;
    if (isNewUser) {
      _cacheService.setIntroScreenView(
        seen: true,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const ViewManager(screenIndex: 0),
        ),
      );
    } else {
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
}
