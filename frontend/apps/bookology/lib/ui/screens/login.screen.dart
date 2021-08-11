import 'package:bookology/handlers/auth_error.handler.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
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
                        child: OutLinedButton(
                          child: Icon(
                            Icons.close,
                            textDirection: TextDirection.ltr,
                          ),
                          outlineColor: Colors.grey,
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/auth',
                              (_) => false,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Text(
                          'Welcome Back!',
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
                                    .signInWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text)
                                    .then(
                                  (value) {
                                    if (value != true) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      authHandler.firebaseError(
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
                                print(e);
                              }
                            }
                          },
                          outlineColor: Colors.black,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Login'),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
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
