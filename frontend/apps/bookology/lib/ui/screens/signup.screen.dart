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

import 'package:bookology/handlers/auth_error.handler.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final _formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final AuthHandler authHandler = new AuthHandler();
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
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    right: 30,
                    left: 30,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          left: 0,
                        ),
                        child: SizedBox(
                          width: 50,
                          child: OutLinedButton(
                            text: 'Close',
                            icon: Icons.close,
                            showIcon: true,
                            showText: false,
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/auth',
                                (_) => false,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            fontStyle: Theme.of(context)
                                .textTheme
                                .headline4!
                                .fontStyle,
                            fontWeight: Theme.of(context)
                                .textTheme
                                .headline4!
                                .fontWeight,
                            fontSize:
                                Theme.of(context).textTheme.headline4!.fontSize,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                      ),
                      TextFormField(
                        decoration: new InputDecoration(
                            labelText: "Email",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15),
                              borderSide: new BorderSide(),
                            ),
                            prefixIcon: Icon(Icons.mail_outline_rounded)
                            //fillColor: Colors.green
                            ),
                        controller: emailController,
                        validator: (val) {
                          if (val?.length == 0) {
                            return "Email cannot be empty.";
                          } else {
                            if (!isEmail(val!)) {
                              return "Email is not valid.";
                            } else {
                              return null;
                            }
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        decoration: new InputDecoration(
                            labelText: "Password",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15),
                              borderSide: new BorderSide(),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outlined,
                            )
                            //fillColor: Colors.green
                            ),
                        controller: passwordController,
                        validator: (val) {
                          if (val?.length == 0) {
                            return "Password cannot be empty.";
                          } else {
                            if (!validatePassword(val!)) {
                              return "Enter a valid password.";
                            }
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 50,
                          left: 50,
                        ),
                        child: OutLinedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                setState(() {
                                  _isLoading = true;
                                });
                                await auth
                                    .signUpWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        firstName: '',
                                        lastName: '',
                                        profilePictureURL:
                                            'https://firebasestorage.googleapis.com/v0/b/bookology-dev.appspot.com/o/SystemFiles%2Fdefault_profile_pictire.png?alt=media&token=1c37b178-a644-453b-ad8a-8023c2792567')
                                    .then(
                                  (value) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (value != true) {
                                      authHandler.firebaseError(
                                          value: value, context: context);
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      if (value == true) {
                                        Navigator.pushReplacementNamed(
                                            context, '/verify');
                                      }
                                    }
                                  },
                                );
                              } catch (e) {
                                print(e);
                              }
                            }
                          },
                          inverted: true,
                          showText: true,
                          showIcon: true,
                          text: 'Sign Up',
                          icon: Icons.arrow_forward,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  String? emailValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter email.';
    }
    return null;
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  bool validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern.toString());

    return regex.hasMatch(value);
  }
}
