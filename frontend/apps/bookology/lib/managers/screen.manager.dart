import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/screens/auth.screen.dart';
import 'package:bookology/ui/screens/home.screen.dart';
import 'package:bookology/ui/screens/profile.screen.dart';
import 'package:bookology/ui/screens/room.screen.dart';
import 'package:bookology/ui/screens/verify_email.screen.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenManager extends StatefulWidget {
  final int currentIndex;
  final bool isUserProfileUpdated;

  const ScreenManager({
    Key? key,
    required this.currentIndex,
    this.isUserProfileUpdated = false,
  }) : super(key: key);

  @override
  _ScreenManagerState createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  int screenIndex = 0;
  List<Widget> screenList = [
    HomeScreen(),
    RoomsPage(),
    AuthScreen(),
    ProfileScreen(),
  ];
  final cacheService = new CacheService();

  @override
  void initState() {
    screenIndex = widget.currentIndex;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return auth.isEmailVerified() != true
        ? VerifyEmailScreen()
        : Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: screenIndex,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              onTap: (value) {
                setState(() {
                  screenIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                  activeIcon: Icon(
                    Icons.home,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.question_answer_outlined),
                  label: ''
                      'Discussions',
                  activeIcon: Icon(
                    Icons.question_answer,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_outlined),
                  label: ''
                      'Notifications',
                  activeIcon: Icon(
                    Icons.notifications,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: CircularImage(
                    image: auth.currentUser()!.photoURL.toString(),
                    radius: 25,
                  ),
                  label: ''
                      'Profile',
                ),
              ],
            ),
            body: SafeArea(
              child: IndexedStack(
                index: screenIndex,
                children: screenList,
              ),
            ),
          );
  }
}
