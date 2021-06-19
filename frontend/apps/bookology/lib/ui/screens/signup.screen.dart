import 'package:bookology/handlers/auth_error.handler.dart';
import 'package:bookology/services/auth.service.dart';
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
              child: Container(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 60,
                    ),
                    children: [
                      Center(
                        child: Text(
                          'Create New Account',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
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
                              return "Password must be at least 8 characters\nand "
                                  "must contain "
                                  "lower & capital \n"
                                  "alphabets, numbers and special symbols.";
                            }
                            return null;
                          }
                        },
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            try {
                              await auth
                                  .signUpWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      firstName: ' ',
                                      lastName: ' ',
                                      profilePictureURL:
                                          'https://randomuser.me/api/portraits/men/11.jpg')
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
                        child: Container(
                          width: 100,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 10,
                                ),
                                child: Text(
                                  'Continue',
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_outlined,
                              )
                            ],
                          ),
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
