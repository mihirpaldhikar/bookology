import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/ui/screens/verify_email.screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final firestore = Provider.of<FirestoreService>(context);
    return auth.isEmailVerified() == true
        ? VerifyEmailScreen()
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Text(FirebaseAuth.instance.currentUser!.email.toString()),
                  Container(
                    child: InkWell(
                      onTap: () {
                        auth.signOut();
                        Navigator.pushReplacementNamed(context, '/auth');
                      },
                      child: Text('Logout'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Click!'),
                  ),
                ],
              ),
            ),
          );
  }
}
