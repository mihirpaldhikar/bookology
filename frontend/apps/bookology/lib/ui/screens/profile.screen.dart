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
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel> userData;
  String userName = '';
  String profileImage = '';
  bool isCurrentUser = false;
  int booksListed = 0;
  final apiService = ApiService();
  final authService = AuthService(FirebaseAuth.instance);
  final cacheService = CacheService();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    userData = _fetchUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityStatus>(
      initialData: ConnectivityStatus.cellular,
      stream: ConnectivityService().connectionStatusController.stream,
      builder:
          (BuildContext context, AsyncSnapshot<ConnectivityStatus> snapshot) {
        if (snapshot.data == ConnectivityStatus.offline) {
          return offlineScreen();
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
                      cacheService.getCurrentUserNameCache(),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).appBarTheme.titleTextStyle,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Visibility(
                      visible: cacheService.getCurrentIsVerifiedCache(),
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
                            .bottomNavigationBarTheme
                            .unselectedItemColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.menu_outlined),
                onPressed: () {
                  BottomSheetManager(context).showMoreProfileMenuBottomSheet();
                },
              ),
            ],
          ),
          body: SafeArea(
            child: FutureBuilder<UserModel>(
              future: userData,
              builder:
                  (BuildContext context, AsyncSnapshot<UserModel> userData) {
                if (userData.connectionState == ConnectionState.done) {
                  if (userData.hasData) {
                    return SmartRefresher(
                      controller: _refreshController,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      enablePullDown: true,
                      header: const ClassicHeader(),
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: ListView.builder(
                        padding:
                            const EdgeInsets.only(top: 20, left: 10, right: 10),
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        itemCount: userData.data!.books.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                CircularImage(
                                  image: userData
                                      .data!.userInformation.profilePicture
                                      .toString(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${userData.data!.userInformation.firstName.toString()} ${userData.data!.userInformation.lastName.toString()}',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        userData.data!.userInformation.bio
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                        color: Theme.of(context)
                                            .bottomNavigationBarTheme
                                            .unselectedItemColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            userData.data!.books.length
                                                .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 30,
                                            ),
                                          ),
                                          Text(
                                            'Books',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
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
                                        color: Theme.of(context)
                                            .bottomNavigationBarTheme
                                            .unselectedItemColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            userData.data!.books.length
                                                .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          Text(
                                            'Points',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
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
                                  visible: isCurrentUser,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: OutLinedButton(
                                            text: 'Edit Profile',
                                            textColor:
                                                Theme.of(context).primaryColor,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfileScreen(
                                                    userID: authService
                                                        .currentUser()!
                                                        .uid,
                                                    profilePicture: authService
                                                        .currentUser()!
                                                        .photoURL
                                                        .toString(),
                                                    userName: userData
                                                        .data!
                                                        .userInformation
                                                        .username,
                                                    isVerified: userData
                                                        .data!
                                                        .userInformation
                                                        .verified,
                                                    bio: userData.data!
                                                        .userInformation.bio,
                                                    firstName: userData
                                                        .data!
                                                        .userInformation
                                                        .firstName,
                                                    lastName: userData
                                                        .data!
                                                        .userInformation
                                                        .lastName,
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
                                            backgroundColor:
                                                Colors.grey.shade100,
                                            textColor: Colors.black,
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
                          } else {
                            return BookCard(
                              showMenu: true,
                              buttonText: 'Edit',
                              id: '${userData.data!.books[index - 1].bookId.toString()}@${index.toString()}',
                              book: userData.data!.books[index - 1],
                              onClicked: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BookViewer(
                                      id: '${userData.data!.books[index - 1].bookId.toString()}@${index.toString()}',
                                      book: userData.data!.books[index - 1],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    );
                  }
                }
                return profileShimmer();
              },
            ),
          ),
        );
      },
    );
  }

  Future<UserModel> _fetchUserData() async {
    final data =
        await apiService.getUserProfile(userID: authService.currentUser()!.uid);

    if (cacheService.getCurrentUserNameCache() ==
        data!.userInformation.username) {
      setState(
        () {
          isCurrentUser = true;
        },
      );
    } else {
      setState(
        () {
          isCurrentUser = false;
        },
      );
    }
    return data;
  }

  void _onRefresh() async {
    setState(
      () {
        userData = _fetchUserData();
      },
    );
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }
}
