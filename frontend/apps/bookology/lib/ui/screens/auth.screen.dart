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

import 'package:blobs/blobs.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/handlers/auth_error.handler.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/widgets/app_logo.widget.dart';
import 'package:bookology/ui/widgets/rounded_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final AuthHandler _authHandler = AuthHandler();
  final PreferencesManager _cacheService = PreferencesManager();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarColor: Theme.of(context).colorScheme.background,
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
      ),
    );
    final auth = Provider.of<AuthService>(context);
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: -90,
                    right: -200,
                    child: Opacity(
                      opacity: 0.05,
                      child: Blob.fromID(
                        styles: BlobStyles(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        id: const ['6-6-1481'],
                        size: 500,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -10,
                    left: -30,
                    child: Opacity(
                      opacity: 0.05,
                      child: Blob.fromID(
                        styles: BlobStyles(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        id: const ['6-6-47'],
                        size: 100,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -10,
                    left: -120,
                    child: Opacity(
                      opacity: 0.05,
                      child: Blob.fromID(
                        styles: BlobStyles(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        id: const ['6-6-47'],
                        size: 350,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -170,
                    right: -120,
                    child: Opacity(
                      opacity: 0.05,
                      child: Blob.fromID(
                        styles: BlobStyles(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        id: const ['6-6-49'],
                        size: 350,
                      ),
                    ),
                  ),
                  ListView(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 20,
                      bottom: 10,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 50,
                        ),
                        child: AppLogo(
                          context: context,
                          isSloganVisible: true,
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Column(
                          children: [
                            RoundedButton(
                              onPressed: () async {
                                _cacheService.setIntroScreenView(seen: false);
                                setState(() {
                                  _isLoading = true;
                                });
                                await auth.signInWithGoogle().then(
                                  (value) async {
                                    if (value == true) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      await Navigator.pushReplacementNamed(
                                          context, '/home');
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      _authHandler.firebaseError(
                                        value: value,
                                        context: context,
                                      );
                                    }
                                  },
                                );
                              },
                              spaceBetween: 30,
                              outlineWidth: ValuesConstant.outlineWidth,
                              icon: SvgPicture.asset(
                                  'assets/svg/google_logo.svg'),
                              text: StringConstants.hintContinueWithGoogle,
                              textColor: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            RoundedButton(
                              text: StringConstants.wordLogin,
                              textColor: Theme.of(context).colorScheme.primary,
                              outlineWidth: ValuesConstant.outlineWidth,
                              icon: Icon(
                                Icons.mail_outline_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              spaceBetween: 40,
                              onPressed: () {
                                _cacheService.setIntroScreenView(seen: false);
                                Navigator.pushNamed(context, '/login');
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              StringConstants.or,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              StringConstants.hintCreateNewAccount,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            RoundedButton(
                              onPressed: () {
                                _cacheService.setIntroScreenView(seen: false);
                                Navigator.pushNamed(context, '/signup');
                              },
                              text: StringConstants.wordSignUp,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              textColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                            const SizedBox(
                              height: 70,
                            ),
                            Text(
                              StringConstants.appCopyright,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
