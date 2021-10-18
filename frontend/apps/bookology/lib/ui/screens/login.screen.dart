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

import 'package:bookology/handlers/auth_error.handler.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:bookology/utils/validator.utli.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final AuthHandler _authHandler = AuthHandler();
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.only(
                    right: 30,
                    left: 30,
                  ),
                  scrollDirection: Axis.vertical,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontStyle:
                              Theme.of(context).textTheme.headline4!.fontStyle,
                          fontWeight:
                              Theme.of(context).textTheme.headline4!.fontWeight,
                          fontSize:
                              Theme.of(context).textTheme.headline4!.fontSize,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Email",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(),
                          ),
                          prefixIcon: const Icon(Icons.mail_outline_rounded)
                          //fillColor: Colors.green
                          ),
                      controller: _emailController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Email cannot be empty.";
                        } else {
                          if (!Validator().validateEmail(val)) {
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
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Password",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outlined,
                          )
                          //fillColor: Colors.green
                          ),
                      controller: _passwordController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Password cannot be empty.";
                        } else {
                          if (!Validator().validatePassword(val)) {
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          DialogsManager(context).showResetPasswordDialog();
                        },
                        child: const Text(
                          'Forgot Password?',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    OutLinedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            setState(() {
                              _isLoading = true;
                            });
                            await _auth
                                .signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text)
                                .then(
                              (value) {
                                if (value != true) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  _authHandler.firebaseError(
                                      value: value, context: context);
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  });
                                }
                              },
                            );
                          } catch (e) {
                            rethrow;
                          }
                        }
                      },
                      text: 'Login',
                      textColor: Theme.of(context).primaryColor,
                    ),
                  ],
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
}
