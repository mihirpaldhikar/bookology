/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the
 *  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is furnished
 *  to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 *  or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/platforms/android.platform.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/services/update.service.dart';
import 'package:bookology/themes/bookology.theme.dart';
import 'package:bookology/ui/components/fade_indexed_stack.component.dart';
import 'package:bookology/ui/screens/discussions.screen.dart';
import 'package:bookology/ui/screens/home.screen.dart';
import 'package:bookology/ui/screens/profile.screen.dart';
import 'package:bookology/ui/screens/search.screen.dart';
import 'package:bookology/ui/screens/verify_email.screen.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ViewManager extends StatefulWidget {
  final int screenIndex;
  final bool isUserProfileUpdated;

  const ViewManager({
    Key? key,
    required this.screenIndex,
    this.isUserProfileUpdated = false,
  }) : super(key: key);

  @override
  _ViewManagerState createState() => _ViewManagerState();
}

class _ViewManagerState extends State<ViewManager> {
  int screenIndex = 0;
  final cacheService = PreferencesManager();

  @override
  void initState() {
    UpdateService(context).checkForAppUpdate();
    screenIndex = widget.screenIndex;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await AndroidPlatform().notifyTextTheme(
        textColor: Colors.grey.shade600);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarColor: Theme.of(context).colorScheme.background,
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
      ),
    );
    final auth = Provider.of<AuthService>(context);
    return auth.currentUser()!.emailVerified != true
        ? const VerifyEmailScreen()
        : Scaffold(
            bottomNavigationBar: NavigationBar(
              animationDuration: const Duration(
                milliseconds: 400,
              ),
              selectedIndex: screenIndex,
              onDestinationSelected: (index) => setState(() {
                screenIndex = index;
              }),
              destinations: [
                NavigationDestination(
                  icon: Icon(
                    Icons.home_outlined,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  selectedIcon: const Icon(
                    Icons.home,
                  ),
                  label: StringConstants.navigationHome,
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.search_outlined,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  selectedIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).buttonTheme.colorScheme!.primary,
                  ),
                  label: StringConstants.navigationSearch,
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.question_answer_outlined,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  selectedIcon: const Icon(
                    Icons.question_answer,
                  ),
                  label: StringConstants.navigationDiscussions,
                ),
                NavigationDestination(
                  icon: CircularImage(
                    image: auth.currentUser()!.photoURL.toString(),
                    radius: 30,
                  ),
                  label: StringConstants.navigationProfile,
                ),
              ],
            ),
            body: SafeArea(
              child: FadeIndexedStack(
                duration: const Duration(milliseconds: 300),
                index: screenIndex,
                children: [
                  ChangeNotifierProvider(
                    create: (context) => BookologyThemeProvider(),
                    builder: (context, _) {
                      return const HomeScreen();
                    },
                  ),
                  const SearchScreen(),
                  const DiscussionsScreen(),
                  const ProfileScreen(),
                ],
              ),
            ),
          );
  }
}
