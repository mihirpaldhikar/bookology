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
import 'package:blobs/blobs.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/enums/connectivity.enum.dart';
import 'package:bookology/managers/bottom_sheet.manager.dart';
import 'package:bookology/models/user.model.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/services/connectivity.service.dart';
import 'package:bookology/services/share.service.dart';
import 'package:bookology/ui/components/profile_shimmer.component.dart';
import 'package:bookology/ui/screens/book_view.screen.dart';
import 'package:bookology/ui/screens/create.screen.dart';
import 'package:bookology/ui/screens/edit_profile.screen.dart';
import 'package:bookology/ui/screens/offline.screen.dart';
import 'package:bookology/ui/widgets/book_card.widget.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:bookology/ui/widgets/collapsable_fab.widget.dart';
import 'package:bookology/ui/widgets/marquee.widget.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late Future<UserModel> _userData;
  bool _isCurrentUser = false;
  final _apiService = ApiService();
  final _authService = AuthService(FirebaseAuth.instance);
  final _cacheService = CacheService();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final PageController _pageController = PageController();
  late AnimationController _hideFabAnimation;
  final ScrollController _fabController = ScrollController();

  @override
  void initState() {
    super.initState();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _userData = _fetchUserData();
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _hideFabAnimation.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              // _hideFabAnimation.forward();
              setState(() {});
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              // _hideFabAnimation.reverse();
              setState(() {});
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
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
        return NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: Scaffold(
            floatingActionButton: CollapsableFab(
              width: 160,
              scrollController: _fabController,
              duration: const Duration(milliseconds: 200),
              color: Theme.of(context).colorScheme.primaryVariant,
              icon: Icon(
                Icons.add,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              text: Text(
                'New Book',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const CreateScreen(),
                  ),
                );
              },
            ),
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
                  message: 'More Options',
                  child: SizedBox(
                    width: 60,
                    child: IconButton(
                      onPressed: () {
                        BottomSheetManager(context)
                            .showMoreProfileMenuBottomSheet(
                          themeMode: widget.themeMode,
                        );
                      },
                      icon: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .background,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          Icons.menu_outlined,
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .primary,
                        ),
                      ),
                    ),
                  ),
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
        // padding: const EdgeInsets.only(top: 20, left: 17, right: 17),
        controller: _fabController,
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
        //padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
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
              child: Center(
                child: Text(
                  'No Books',
                  style: TextStyle(
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  _profileSection(AsyncSnapshot<UserModel> userData) {
    return Stack(
      children: [
        Positioned(
          top: -5,
          bottom: -9,
          left: -20,
          child: Opacity(
            opacity: 0.1,
            child: Blob.fromID(
              styles: BlobStyles(
                color: Theme.of(context).colorScheme.primary,
              ),
              id: const ['9-6-292'],
              size: 100,
            ),
          ),
        ),
        Positioned(
          top: -25,
          right: -55,
          child: Opacity(
            opacity: 0.1,
            child: Blob.fromID(
              styles: BlobStyles(
                color: Theme.of(context).colorScheme.primary,
              ),
              id: const ['9-6-292'],
              size: 150,
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -130,
          child: Opacity(
            opacity: 0.1,
            child: Blob.fromID(
              styles: BlobStyles(
                color: Theme.of(context).colorScheme.primary,
              ),
              id: const ['6-6-331607'],
              size: 500,
            ),
          ),
        ),
        Positioned(
          bottom: -90,
          right: -300,
          child: Opacity(
            opacity: 0.1,
            child: Blob.fromID(
              styles: BlobStyles(
                color: Theme.of(context).colorScheme.primary,
              ),
              id: const ['8-6-984'],
              size: 500,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
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
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    userData.data!.userInformation.bio.toString(),
                    style: TextStyle(
                      color: Theme.of(context).inputDecorationTheme.fillColor,
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
                Card(
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(ValuesConstant.borderRadius),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Column(
                        children: [
                          Text(
                            userData.data!.books.length.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            'Books',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(ValuesConstant.borderRadius),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Column(
                        children: [
                          Text(
                            userData.data!.books.length.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            'Points',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                        textColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).cardTheme.color,
                        outlineWidth: 0.5,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                userID: _authService.currentUser()!.uid,
                                profilePicture: _authService
                                    .currentUser()!
                                    .photoURL
                                    .toString(),
                                userName:
                                    userData.data!.userInformation.username,
                                isVerified:
                                    userData.data!.userInformation.verified,
                                bio: userData.data!.userInformation.bio,
                                firstName:
                                    userData.data!.userInformation.firstName,
                                lastName:
                                    userData.data!.userInformation.lastName,
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
                        backgroundColor: Theme.of(context).cardTheme.color,
                        outlineWidth: 0.5,
                        textColor: Theme.of(context).colorScheme.primary,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _booksSection(AsyncSnapshot<UserModel> userData, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 17, right: 17),
      child: Slidable(
        actionPane: const SlidableBehindActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: Colors.transparent,
            iconWidget: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonTheme.colorScheme!.background,
                borderRadius:
                    BorderRadius.circular(ValuesConstant.secondaryBorderRadius),
              ),
              child: Icon(
                Icons.share,
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
              ),
            ),
            onTap: () {
              ShareService().shareBook(
                book: userData.data!.books[index - 1],
              );
            },
          ),
        ],
        child: BookCard(
          showMenu: false,
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
        ),
      ),
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
