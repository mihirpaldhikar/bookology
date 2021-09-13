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
  final AuthHandler authHandler = new AuthHandler();
  final CacheService cacheService = new CacheService();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return _isLoading
        ? Scaffold(
            body: Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 20,
                  bottom: 10,
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 60,
                    ),
                    child: _logo(context),
                  ),
                  SizedBox(
                    height: 170,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              right: 8,
                              left: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                  ValuesConstant.SECONDARY_BORDER_RADIUS),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                SvgPicture.asset('assets/svg/google_logo.svg'),
                                SizedBox(
                                  width: 50,
                                ),
                                Text(
                                  StringConstants.HINT_CONTINUE_WITH_GOOGLE,
                                  style: Theme.of(context).textTheme.button,
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            cacheService.setIntroScreenView(seen: false);
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

                                  authHandler.firebaseError(
                                    value: value,
                                    context: context,
                                  );
                                }
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        OutLinedButton(
                          text: StringConstants.LOGIN,
                          icon: Icons.mail_outline_rounded,
                          showIcon: true,
                          showText: true,
                          iconColor: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).primaryColor,
                          outlineColor: Theme.of(context).primaryColor,
                          alignContent: MainAxisAlignment.start,
                          spaceBetween: 115,
                          onPressed: () {
                            cacheService.setIntroScreenView(seen: false);
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () {
                            cacheService.setIntroScreenView(seen: false);
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: RichText(
                            text: TextSpan(
                              text: StringConstants.HINT_CREATE_NEW_ACCOUNT,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: ' ${StringConstants.SIGN_UP}',
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
  return Container(
    child: Column(
      children: [
        Image(
          image: AssetImage('assets/icons/splash.icon.png'),
          width: 200,
          height: 200,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          StringConstants.APP_SLOGAN,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    ),
  );
}
