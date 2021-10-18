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

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookology/enums/connectivity.enum.dart';
import 'package:bookology/managers/bottom_sheet.manager.dart';
import 'package:bookology/models/user.model.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/services/connectivity.service.dart';
import 'package:bookology/ui/components/profile_shimmer.component.dart';
import 'package:bookology/ui/screens/book_view.screen.dart';
import 'package:bookology/ui/screens/create.screen.dart';
import 'package:bookology/ui/screens/edit_profile.screen.dart';
import 'package:bookology/ui/screens/offline.screen.dart';
import 'package:bookology/ui/widgets/book_card.widget.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:bookology/ui/widgets/marquee.widget.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileScreen extends StatefulWidget {
  final AdaptiveThemeMode themeMode;

  const ProfileScreen({
    Key? key,
    required this.themeMode,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel> _userData;
  bool _isCurrentUser = false;
  final _apiService = ApiService();
  final _authService = AuthService(FirebaseAuth.instance);
  final _cacheService = CacheService();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityStatus>(
      initialData: ConnectivityStatus.cellular,
      stream: ConnectivityService().connectionStatusController.stream,
      builder:
          (BuildContext context, AsyncSnapshot<ConnectivityStatus> snapshot) {
        if (snapshot.data == ConnectivityStatus.offline) {
          return offlineScreen(context: context);
        }
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Marquee(
                direction: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    AutoSizeText(
                      _cacheService.getCurrentUserNameCache(),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).appBarTheme.titleTextStyle,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Visibility(
                      visible: _cacheService.getCurrentIsVerifiedCache(),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Tooltip(
                message: 'New Book',
                child: SizedBox(
                  width: 60,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateScreen(),
                        ),
                      );
                    },
                    icon: Container(
                      width: 30,
                      height: 30,
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .background,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.menu_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  BottomSheetManager(context).showMoreProfileMenuBottomSheet(
                    themeMode: widget.themeMode,
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: FutureBuilder<UserModel>(
              future: _userData,
              builder:
                  (BuildContext context, AsyncSnapshot<UserModel> userData) {
                if (userData.connectionState == ConnectionState.done) {
                  if (userData.hasData) {
                    if (userData.data!.books.isEmpty) {
                      return _profileWithoutBooks(userData);
                    }

                    return _profileWithBooks(userData);
                  }
                }
                return profileShimmer(
                  context: context,
                );
              },
            ),
          ),
        );
      },
    );
  }

  _profileWithBooks(AsyncSnapshot<UserModel> userData) {
    return SmartRefresher(
      controller: _refreshController,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      enablePullDown: true,
      header: const ClassicHeader(),
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: userData.data!.books.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _profileSection(userData);
          } else {
            return _booksSection(userData, index);
          }
        },
      ),
    );
  }

  _profileWithoutBooks(AsyncSnapshot<UserModel> userData) {
    return SmartRefresher(
      controller: _refreshController,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      enablePullDown: true,
      header: const ClassicHeader(),
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _profileSection(userData);
          } else {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: const Center(
                child: Text(
                  'No Books',
                ),
              ),
            );
          }
        },
      ),
    );
  }

  _profileSection(AsyncSnapshot<UserModel> userData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 20,
        ),
        CircularImage(
          image: userData.data!.userInformation.profilePicture.toString(),
          radius: 100,
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${userData.data!.userInformation.firstName.toString()} ${userData.data!.userInformation.lastName.toString()}',
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                userData.data!.userInformation.bio.toString(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonTheme.colorScheme!.background,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    userData.data!.books.length.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    'Books',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonTheme.colorScheme!.background,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    userData.data!.books.length.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'Points',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        Visibility(
          visible: _isCurrentUser,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: OutLinedButton(
                    text: 'Edit Profile',
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            userID: _authService.currentUser()!.uid,
                            profilePicture:
                                _authService.currentUser()!.photoURL.toString(),
                            userName: userData.data!.userInformation.username,
                            isVerified: userData.data!.userInformation.verified,
                            bio: userData.data!.userInformation.bio,
                            firstName: userData.data!.userInformation.firstName,
                            lastName: userData.data!.userInformation.lastName,
                            isInitialUpdate: false,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: OutLinedButton(
                    text: 'Account Settings',
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 2,
          height: 30,
        ),
      ],
    );
  }

  _booksSection(AsyncSnapshot<UserModel> userData, int index) {
    return BookCard(
      showMenu: true,
      buttonText: 'Edit',
      id: '${userData.data!.books[index - 1].bookId.toString()}@${index.toString()}',
      book: userData.data!.books[index - 1],
      onClicked: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => BookViewer(
              themeMode: widget.themeMode,
              id: '${userData.data!.books[index - 1].bookId.toString()}@${index.toString()}',
              book: userData.data!.books[index - 1],
            ),
          ),
        );
      },
    );
  }

  Future<UserModel> _fetchUserData() async {
    final data = await _apiService.getUserProfile(
        userID: _authService.currentUser()!.uid);

    if (_cacheService.getCurrentUserNameCache() ==
        data!.userInformation.username) {
      setState(
        () {
          _isCurrentUser = true;
        },
      );
    } else {
      setState(
        () {
          _isCurrentUser = false;
        },
      );
    }
    return data;
  }

  void _onRefresh() async {
    setState(
      () {
        _userData = _fetchUserData();
      },
    );
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }
}
