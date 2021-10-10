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
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/handlers/auth_error.handler.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final AuthHandler _authHandler = AuthHandler();
  final CacheService _cacheService = CacheService();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: ListView(
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
                      top: 60,
                    ),
                    child: _logo(context),
                  ),
                  const SizedBox(
                    height: 170,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              right: 8,
                              left: 8,
                            ),
                            decoration: BoxDecoration(
                              color: ColorsConstant.lightThemeButtonColor,
                              borderRadius: BorderRadius.circular(
                                ValuesConstant.secondaryBorderRadius,
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                SvgPicture.asset('assets/svg/google_logo.svg'),
                                const SizedBox(
                                  width: 50,
                                ),
                                Text(
                                  StringConstants.hintContinueWithGoogle,
                                  style: Theme.of(context).textTheme.button,
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
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
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        OutLinedButton(
                          text: StringConstants.wordLogin,
                          icon: Icons.mail_outline_rounded,
                          iconColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).primaryColor,
                          alignContent: MainAxisAlignment.start,
                          spaceBetween: 115,
                          onPressed: () {
                            _cacheService.setIntroScreenView(seen: false);
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () {
                            _cacheService.setIntroScreenView(seen: false);
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: RichText(
                            text: TextSpan(
                              text: StringConstants.hintCreateNewAccount,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: ' ${StringConstants.wordSignUp}',
                                  style: GoogleFonts.poppins(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

Widget _logo(BuildContext context) {
  return Column(
    children: [
      const Image(
        image: AssetImage('assets/icons/splash.icon.png'),
        width: 200,
        height: 200,
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        StringConstants.appSlogan,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    ],
  );
}
