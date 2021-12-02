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

import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/enums/connectivity.enum.dart';
import 'package:bookology/managers/native_ads.manager.dart';
import 'package:bookology/models/book.model.dart';
import 'package:bookology/models/saved_book.model.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/connectivity.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/services/location.service.dart';
import 'package:bookology/services/share.service.dart';
import 'package:bookology/ui/components/home_bar.component.dart';
import 'package:bookology/ui/components/home_shimmer.component.dart';
import 'package:bookology/ui/screens/book_view.screen.dart';
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
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final _apiService = ApiService();
  final AuthService _authService = AuthService(FirebaseAuth.instance);
  final FirestoreService _firestoreService =
      FirestoreService(FirebaseFirestore.instance);
  late Future<List<Object>?> _feed;
  late BannerAd _ad;
  List<Object> _homeFeed = [];
  String _currentLocation = '';
  bool isDarkMode = false;
  List<SavedBookModel> _savedBookList = [];

  @override
  void initState() {
    super.initState();
    _feed = getFeed();
  }

  @override
  void dispose() {
    super.dispose();
    _ad.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await _firestoreService.getSavedBook().then((value) {
      setState(() {
        _savedBookList = value;
      });
    });
    _ad = BannerAd(
      size: AdSize(
        width: MediaQuery.of(context).size.width.toInt(),
        height: 60,
      ),
      adUnitId: BannerAd.testAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (ad, error) {
          ad.dispose();

          throw 'Ad load failed (code=${error.code} message=${error.message})';
        },
      ),
      request: const AdRequest(),
    );

    _ad.load();

    await LocationService(context).getCurrentLocation().then((location) {
      setState(() {
        _currentLocation = location;
      });
    });
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
            body: FutureBuilder<List<Object>?>(
          initialData: const [],
          future: _feed,
          builder:
              (BuildContext context, AsyncSnapshot<List<Object>?> homeFeed) {
            if (homeFeed.connectionState == ConnectionState.done) {
              if (homeFeed.hasError) {
                return const Error(
                  message: 'An Error Occurred!',
                );
              }
              if (homeFeed.hasData) {
                return SmartRefresher(
                  controller: _refreshController,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  enablePullDown: true,
                  header: const ClassicHeader(),
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        elevation: 0,
                        pinned: true,
                        floating: false,
                        titleSpacing: 0.0,
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        automaticallyImplyLeading: false,
                        expandedHeight: 250.0,
                        flexibleSpace: HomeBar(
                          currentLocation: _currentLocation,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (index == 0) {
                              return bookCategories();
                            }
                            if (homeFeed.data![index - 1] is BannerAd) {
                              return const NativeInlineAd();
                            } else {
                              return bookList(
                                book: homeFeed.data![index - 1] as BookModel,
                              );
                            }
                          },
                          childCount: homeFeed.data!.length + 1,
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
            return homeShimmer(
              context: context,
            );
          },
        ));
      },
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
              left: 10,
              top: 25,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(ValuesConstant.borderRadius),
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                  bottom: 5,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: index == 0
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius:
                      BorderRadius.circular(ValuesConstant.borderRadius),
                  border: Border.all(
                    color: index == 0
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Text(
                  StringConstants.listBookCategories[index],
                  style: TextStyle(
                    color: index == 0
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget bookList({required BookModel book}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 17,
        right: 17,
        top: 5,
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
          buttonText: _authService.currentUser()!.uid == book.uploader.userId
              ? 'Edit'
              : 'View',
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

  Future<List<Object>?> getFeed() async {
    final books = await _apiService.getBooks();
    setState(() {
      _homeFeed = List.from(books!);
    });
    MobileAds.instance.initialize().then((value) {
      setState(() {
        for (int i = _homeFeed.length - 2; i >= 1; i -= 10) {
          _homeFeed.insert(i, _ad);
        }
      });
    });

    return _homeFeed;
  }

  void _onRefresh() async {
    setState(() {
      _homeFeed.clear();
      _savedBookList.clear();
      _feed = getFeed();
      _refreshController.refreshCompleted();
    });
    await _firestoreService.getSavedBook().then((value) {
      setState(() {
        _savedBookList = value;
      });
    });
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }
}
