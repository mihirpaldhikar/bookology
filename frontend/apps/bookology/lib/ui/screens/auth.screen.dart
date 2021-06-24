import 'package:bookology/handlers/auth_error.handler.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/ui/widgets/line_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              child: Container(
                padding: EdgeInsets.all(12),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'Bookology',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Find the books nearby.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 200,
                      ),
                      LineButton(
                        text: 'Continue With Google',
                        icon: FontAwesomeIcons.google,
                        outlineColor: Colors.black,
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await auth.signInWithGoogle().then((value) async {
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
                                  value: value, context: context);
                            }
                          });
                        },
                        spaceInBetween: 30,
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 30,
                        ),
                      ),
                      LineButton(
                        text: 'Login',
                        icon: Icons.mail_outline_rounded,
                        outlineColor: Colors.black,
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        spaceInBetween: 100,
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account?",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: ' Sign Up',
                                style: GoogleFonts.poppins(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
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
}