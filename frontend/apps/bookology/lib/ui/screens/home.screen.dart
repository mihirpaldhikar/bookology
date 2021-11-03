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

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/enums/connectivity.enum.dart';
import 'package:bookology/managers/native_ads.manager.dart';
import 'package:bookology/models/book.model.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/connectivity.service.dart';
import 'package:bookology/services/location.service.dart';
import 'package:bookology/services/share.service.dart';
import 'package:bookology/services/update.service.dart';
import 'package:bookology/ui/components/home_bar.component.dart';
import 'package:bookology/ui/components/home_shimmer.component.dart';
import 'package:bookology/ui/screens/book_view.screen.dart';
import 'package:bookology/ui/screens/offline.screen.dart';
import 'package:bookology/ui/widgets/book_card.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  final AdaptiveThemeMode themeMode;

  const HomeScreen({
    Key? key,
    required this.themeMode,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final _apiService = ApiService();
  final AuthService _authService = AuthService(FirebaseAuth.instance);
  late Future<List<Object>?> _feed;
  late BannerAd _ad;
  List<Object> _homeFeed = [];
  String _currentLocation = '';
  bool isDarkMode = false;

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
    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    setState(() {
      isDarkMode = brightness == Brightness.dark;
    });
    UpdateService(context).checkForAppUpdate();
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
                    shrinkWrap: true,
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
        shrinkWrap: true,
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
                      ? Theme.of(context).buttonTheme.colorScheme!.background
                      : Theme.of(context).cardTheme.color,
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  borderRadius:
                      BorderRadius.circular(ValuesConstant.borderRadius),
                ),
                child: Text(
                  StringConstants.listBookCategories[index],
                  style: TextStyle(
                    color: index == 0
                        ? Theme.of(context).buttonTheme.colorScheme!.primary
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
        actions: [
          IconSlideAction(
            color: Colors.transparent,
            iconWidget: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: book.uploaderId != _authService.currentUser()!.uid
                    ? ColorsConstant.lightDangerBackgroundColor
                    : Theme.of(context).brightness == Brightness.light
                        ? Colors.grey.shade200
                        : Colors.grey.shade400,
                borderRadius:
                    BorderRadius.circular(ValuesConstant.secondaryBorderRadius),
              ),
              child: Icon(
                Icons.report_gmailerrorred,
                color: book.uploaderId != _authService.currentUser()!.uid
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).brightness == Brightness.light
                        ? Colors.grey
                        : Colors.grey.shade900,
              ),
            ),
            onTap: () {
              if (book.uploaderId != _authService.currentUser()!.uid) {
                ShareService().shareBook(
                  book: book,
                );
              }
            },
          ),
        ],
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
                book: book,
              );
            },
          ),
          IconSlideAction(
            color: Colors.transparent,
            iconWidget: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: book.uploaderId != _authService.currentUser()!.uid
                    ? Theme.of(context).buttonTheme.colorScheme!.background
                    : Theme.of(context).brightness == Brightness.light
                        ? Colors.grey.shade200
                        : Colors.grey.shade400,
                borderRadius:
                    BorderRadius.circular(ValuesConstant.secondaryBorderRadius),
              ),
              child: Icon(
                Icons.bookmark_border,
                color: book.uploaderId != _authService.currentUser()!.uid
                    ? Theme.of(context).buttonTheme.colorScheme!.primary
                    : Theme.of(context).brightness == Brightness.light
                        ? Colors.grey
                        : Colors.grey.shade900,
              ),
            ),
            onTap: () {
              if (book.uploaderId != _authService.currentUser()!.uid) {
                ShareService().shareBook(
                  book: book,
                );
              }
            },
          ),
        ],
        actionPane: const SlidableBehindActionPane(),
        child: BookCard(
          showMenu: false,
          buttonText: _authService.currentUser()!.uid == book.uploaderId
              ? 'Edit'
              : 'View',
          id: book.bookId,
          book: book,
          onClicked: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => BookViewer(
                  themeMode: widget.themeMode,
                  id: book.bookId,
                  book: book,
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
      _feed = getFeed();
      _refreshController.refreshCompleted();
    });
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }
}
