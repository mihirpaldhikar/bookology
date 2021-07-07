import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/ui/components/search_bar.component.dart';
import 'package:bookology/ui/screens/create.screen.dart';
import 'package:bookology/ui/screens/verify_email.screen.dart';
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
    return auth.isEmailVerified() != true
        ? VerifyEmailScreen()
        : Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(120),
              child: SafeArea(
                child: SearchBar(),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              tooltip: 'Create a new Book Post.',
              backgroundColor: Colors.white,
              shape: StadiumBorder(
                side: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => CreateScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              label: Text(
                'Post',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 15,
                ),
                child: Column(
                  children: [],
                ),
              ),
            ),
          );
  }
}
