/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *  the Software, and to permit persons to whom the Software is furnished to do so,
 *  subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 *  ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 *  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 *  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/screens/home.screen.dart';
import 'package:bookology/ui/screens/profile.screen.dart';
import 'package:bookology/ui/screens/room.screen.dart';
import 'package:bookology/ui/screens/search.screen.dart';
import 'package:bookology/ui/screens/verify_email.screen.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
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
    const HomeScreen(),
    const SearchScreen(),
    const RoomsPage(),
    const ProfileScreen(),
  ];
  final cacheService = CacheService();

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
        ? const VerifyEmailScreen()
        : Scaffold(
            bottomNavigationBar: BottomNavyBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              showElevation: false,
              selectedIndex: screenIndex,
              onItemSelected: (value) {
                setState(() {
                  screenIndex = value;
                });
              },
              items: [
                BottomNavyBarItem(
                  icon: const Icon(
                    Icons.home_outlined,
                    color: Colors.black,
                  ),
                  title: const Text(
                    StringConstants.navigationHome,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  activeColor: Theme.of(context).colorScheme.secondary,
                  inactiveColor: Colors.grey,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: const Icon(
                    Icons.search_outlined,
                    color: Colors.black,
                  ),
                  title: const Text(
                    StringConstants.navigationSearch,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  activeColor: Theme.of(context).colorScheme.secondary,
                  inactiveColor: Colors.grey,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: const Icon(
                    Icons.question_answer_outlined,
                    color: Colors.black,
                  ),
                  title: const Text(
                    StringConstants.navigationDiscussions,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  activeColor: Theme.of(context).colorScheme.secondary,
                  inactiveColor: Colors.grey,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: CircularImage(
                    image: auth.currentUser()!.photoURL.toString(),
                    radius: 30,
                  ),
                  title: const Text(
                    StringConstants.navigationProfile,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  activeColor: Theme.of(context).colorScheme.secondary,
                  inactiveColor: Colors.grey,
                  textAlign: TextAlign.center,
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
