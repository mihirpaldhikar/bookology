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

import 'dart:async';

import 'package:badges/badges.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/enums/connectivity.enum.dart';
import 'package:bookology/managers/native_ads.manager.dart';
import 'package:bookology/models/ads.model.dart';
import 'package:bookology/models/book.model.dart';
import 'package:bookology/models/saved_book.model.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/connectivity.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/services/share.service.dart';
import 'package:bookology/ui/components/collapsable_app_bar.component.dart';
import 'package:bookology/ui/components/home_shimmer.component.dart';
import 'package:bookology/ui/screens/book_view.screen.dart';
import 'package:bookology/ui/screens/create.screen.dart';
import 'package:bookology/ui/screens/notifications.screen.dart';
import 'package:bookology/ui/screens/offline.screen.dart';
import 'package:bookology/ui/widgets/book_card.widget.dart';
import 'package:bookology/ui/widgets/error.widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
    initialLoadStatus: LoadStatus.idle,
  );
  final _apiService = ApiService();
  final AuthService _authService = AuthService(FirebaseAuth.instance);
  final FirestoreService _firestoreService =
      FirestoreService(FirebaseFirestore.instance);
  late Future<List<Object>?> _feed;
  List<Object> _homeFeed = [];
  int _selectedIndex = 0;

  List<SavedBookModel> _savedBookList = [];

  @override
  void initState() {
    super.initState();
    _firestoreService.getSavedBook().then((value) {
      setState(() {
        _savedBookList = value;
      });
    });
    _feed = getFeed(sortBy: "All");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ConnectivityStatus>(
        initialData: ConnectivityStatus.cellular,
        stream: ConnectivityService().connectionStatusController.stream,
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityStatus> snapshot) {
          if (snapshot.data == ConnectivityStatus.offline) {
            return offlineScreen(context: context);
          }
          return FutureBuilder<List<Object>?>(
            future: _feed,
            builder:
                (BuildContext context, AsyncSnapshot<List<Object>?> homeFeed) {
              if (homeFeed.connectionState == ConnectionState.waiting ||
                  homeFeed.connectionState == ConnectionState.active) {
                return homeShimmer(context, _selectedIndex);
              }

              if (homeFeed.connectionState == ConnectionState.done) {
                if (homeFeed.hasError) {
                  return const Error(
                    message: 'An Error Occurred!',
                  );
                }
                if (homeFeed.hasData) {
                  return CollapsableAppBar(
                    actions: [
                      Tooltip(
                        message: 'Edit Profile',
                        child: SizedBox(
                          width: 60,
                          child: IconButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreateScreen(),
                                ),
                              );
                            },
                            icon: Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Tooltip(
                        message: 'More Options',
                        child: SizedBox(
                          width: 60,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationScreen(),
                                ),
                              );
                            },
                            icon: Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Badge(
                                showBadge: false,
                                toAnimate: false,
                                badgeColor: Colors.red,
                                elevation: 0,
                                badgeContent: const Text(
                                  '9+',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10,
                                  ),
                                ),
                                child: Icon(
                                  Icons.notifications_outlined,
                                  size: 25,
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    automaticallyImplyLeading: false,
                    title: 'Bookology',
                    body: SmartRefresher(
                      cacheExtent: 9999999999999999999999999.0,
                      semanticChildCount: 999999999999999999,
                      controller: _refreshController,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      enablePullDown: true,
                      header: const ClassicHeader(),
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemCount: homeFeed.data!.length + 1,
                          itemBuilder: (context, index) {
                            if (homeFeed.data!.isEmpty) {
                              return Column(
                                children: [
                                  bookCategories(),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                  ),
                                  Center(
                                    child: Text(
                                      _selectedIndex != 0
                                          ? 'No Book with the\n\'${StringConstants.listBookCategories[_selectedIndex]}\' Category'
                                          : 'No Books',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              );
                            }

                            if (index == 0) {
                              return bookCategories();
                            }
                            if (homeFeed.data![index - 1] is AdsModel) {
                              return const NativeInlineAd();
                            } else {
                              return bookList(
                                book: homeFeed.data![index - 1] as BookModel,
                              );
                            }
                          }),
                    ),
                  );
                }
              }

              return const SizedBox(
                width: 0,
                height: 0,
              );
            },
          );
        },
      ),
    );
  }

  Widget bookCategories() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        itemCount: StringConstants.listBookCategories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 15,
              top: 23,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(ValuesConstant.borderRadius),
              onTap: () async {
                if (_selectedIndex != index) {
                  _onSelected(index);
                  _homeFeed.clear();
                  setState(() {
                    _feed = getFeed(
                      sortBy:
                          StringConstants.listBookCategories[_selectedIndex],
                    );
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                  bottom: 5,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: index == _selectedIndex
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius:
                      BorderRadius.circular(ValuesConstant.borderRadius),
                  border: Border.all(
                    color: index == _selectedIndex
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Text(
                  StringConstants.listBookCategories[index],
                  style: TextStyle(
                    color: index == _selectedIndex
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget bookList({required BookModel book}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
        top: 15,
      ),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.transparent,
              foregroundColor:
                  book.uploader.userId != _authService.currentUser()!.uid
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).brightness == Brightness.light
                          ? Colors.grey
                          : Colors.grey.shade900,
              icon: Icons.report_gmailerrorred,
              onPressed: (context) {
                if (book.uploader.userId != _authService.currentUser()!.uid) {
                  ShareService().shareBook(
                    book: book,
                  );
                }
              },
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.transparent,
              foregroundColor:
                  Theme.of(context).buttonTheme.colorScheme!.primary,
              icon: Icons.share,
              onPressed: (context) {
                ShareService().shareBook(
                  book: book,
                );
              },
            ),
            SlidableAction(
              backgroundColor: Colors.transparent,
              foregroundColor:
                  book.uploader.userId != _authService.currentUser()!.uid
                      ? Theme.of(context).buttonTheme.colorScheme!.primary
                      : Theme.of(context).brightness == Brightness.light
                          ? Colors.grey
                          : Colors.grey.shade900,
              icon: _savedBookList
                      .where((element) => element.bookId == book.bookId)
                      .isNotEmpty
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              onPressed: (context) async {
                // if (book.uploader.userId != _authService.currentUser()!.uid) {
                if (_savedBookList
                    .where((element) => element.bookId == book.bookId)
                    .isEmpty) {
                  setState(() {
                    _savedBookList
                        .add(SavedBookModel.fromJson({'bookId': book.bookId}));
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Added to Saved',
                      ),
                      duration: Duration(
                        seconds: 2,
                      ),
                    ),
                  );
                  await _firestoreService.saveBook(bookId: book.bookId);
                } else {
                  setState(() {
                    _savedBookList.removeWhere(
                        (element) => element.bookId == book.bookId);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Removed from Saved',
                      ),
                      duration: Duration(
                        seconds: 2,
                      ),
                    ),
                  );
                  await _firestoreService.removedSavedBook(bookId: book.bookId);
                }
                //}
              },
            ),
          ],
        ),
        child: BookCard(
          showMenu: false,
          id: book.bookId,
          book: book,
          onClicked: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => BookViewer(
                  id: book.bookId,
                  book: book,
                  isSaveBook: _savedBookList
                      .where((element) => element.bookId == book.bookId)
                      .isNotEmpty,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<Object>?> getFeed({required String sortBy}) async {
    final allBooks = await _apiService.getBooks();
    final sortedBook = [];
    allBooks?.forEach((element) {
      if (element.additionalInformation.categories.contains(sortBy)) {
        sortedBook.add(element);
      }
    });
    _homeFeed = List.from(sortedBook);
    MobileAds.instance.initialize().then((value) {
      for (int i = _homeFeed.length - 1; i >= 1; i -= 3) {
        setState(() {
          _homeFeed.insert(i, AdsModel(UniqueKey()));
        });
      }
    });

    return _homeFeed;
  }

  void _onRefresh() async {
    _homeFeed.clear();
    _savedBookList.clear();
    setState(() {
      _feed =
          getFeed(sortBy: StringConstants.listBookCategories[_selectedIndex]);
    });

    await _firestoreService.getSavedBook().then((value) {
      _savedBookList = value;
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }
}
