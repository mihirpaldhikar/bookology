import 'package:badges/badges.dart';
import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/screens/home.screen.dart';
import 'package:bookology/ui/screens/notifications.screen.dart';
import 'package:bookology/ui/screens/profile.screen.dart';
import 'package:bookology/ui/screens/room.screen.dart';
import 'package:bookology/ui/screens/verify_email.screen.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewManager extends StatefulWidget {
  final int currentIndex;
  final bool isUserProfileUpdated;

  const ViewManager({
    Key? key,
    required this.currentIndex,
    this.isUserProfileUpdated = false,
  }) : super(key: key);

  @override
  _ViewManagerState createState() => _ViewManagerState();
}

class _ViewManagerState extends State<ViewManager> {
  int screenIndex = 0;
  List<Widget> screenList = [
    HomeScreen(),
    RoomsPage(),
    NotificationScreen(),
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
            backgroundColor: ColorsConstant.BACKGROUND_COLOR,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: ColorsConstant.BACKGROUND_COLOR,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: screenIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (value) {
                setState(() {
                  screenIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                  ),
                  label: 'Home',
                  activeIcon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.question_answer_outlined,
                  ),
                  label: ''
                      'Discussions',
                  activeIcon: Icon(
                    Icons.question_answer,
                    size: 30,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                    badgeColor: Colors.red,
                    badgeContent: Text(
                      '9',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                    ),
                  ),
                  label: 'Notifications',
                  activeIcon: Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                ),
                BottomNavigationBarItem(
                    icon: CircularImage(
                      image: auth.currentUser()!.photoURL.toString(),
                      radius: 30,
                    ),
                    label: ''
                        'Profile',
                    activeIcon: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).accentColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: CircularImage(
                        image: auth.currentUser()!.photoURL.toString(),
                        radius: 27,
                      ),
                    )),
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
