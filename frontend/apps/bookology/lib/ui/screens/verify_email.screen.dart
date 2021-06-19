import 'package:bookology/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
        body: SafeArea(
            child: Container(
      child: Column(
        children: [
          OutlinedButton(
            onPressed: () async {
              if (await auth.isEmailVerified() == true) {
                await Navigator.pushReplacementNamed(context, '/home');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Email not verified.'),
                  ),
                );
              }
            },
            child: Text('Verified'),
          ),
        ],
      ),
    )));
  }
}
