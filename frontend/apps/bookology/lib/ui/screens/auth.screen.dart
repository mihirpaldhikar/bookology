import 'package:bookology/handlers/auth_error.handler.dart';
import 'package:bookology/services/auth.service.dart';
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
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 100,
                    ),
                    child: _logo(context),
                  ),
                  SizedBox(
                    height: 220,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        OutLinedButton(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              SvgPicture.asset('assets/svg/google_logo.svg'),
                              SizedBox(
                                width: 50,
                              ),
                              Text('Continue With Google'),
                            ],
                          ),
                          outlineColor: Colors.black,
                          onPressed: () async {
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
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.mail_outline_rounded),
                              SizedBox(
                                width: 100,
                              ),
                              Text('Login'),
                            ],
                          ),
                          outlineColor: Colors.black,
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(5),
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
        Text(
          'Bookology',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Theme.of(context).accentColor),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Find books nearby',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
      ],
    ),
  );
}
