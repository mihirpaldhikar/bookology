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

import 'dart:async';

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
import 'package:bookology/services/update.service.dart';
import 'package:bookology/ui/components/home_shimmer.component.dart';
import 'package:bookology/ui/components/search_bar.component.dart';
import 'package:bookology/ui/screens/book_view.screen.dart';
import 'package:bookology/ui/screens/offline.screen.dart';
import 'package:bookology/ui/widgets/book_card.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final apiService = ApiService();
  final locationService = LocationService();
  final AuthService authService = AuthService(FirebaseAuth.instance);
  late Future<List<Object>?> feed;
  late BannerAd _ad;
  List<Object> homeFeed = [];
  String userName = '';
  String displayName = '';
  String profileImageURL = '';
  String currentLocation = '';
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    feed = getFeed();
  }

  @override
  void dispose() {
    super.dispose();
    _ad.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
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
          // Releases an ad resource when it fails to load
          ad.dispose();

          throw 'Ad load failed (code=${error.code} message=${error.message})';
        },
      ),
      request: const AdRequest(),
    );

    _ad.load();

    getCurrentLocation().then((_) {});
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
            body: FutureBuilder<List<Object>?>(
          initialData: const [],
          future: feed,
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
                        elevation: 3,
                        pinned: true,
                        floating: false,
                        titleSpacing: 0.0,
                        backgroundColor:
                            const Color.fromARGB(245, 242, 246, 254),
                        automaticallyImplyLeading: false,
                        expandedHeight: 250.0,
                        flexibleSpace: SearchBar(
                          currentLocation: currentLocation,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (index == 0) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      left: 15,
                                      top: 20,
                                    ),
                                    child: Text(
                                      'Book Categories',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
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
                                        itemCount: StringConstants
                                            .bookCategories.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 5,
                                                bottom: 5,
                                              ),
                                              margin: const EdgeInsets.only(
                                                left: 10,
                                                top: 25,
                                              ),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: ColorsConstant
                                                      .secondaryColor,
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                  borderRadius: BorderRadius
                                                      .circular(ValuesConstant
                                                          .secondaryBorderRadius)),
                                              child: Text(
                                                StringConstants
                                                    .bookCategories[index],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ));
                                        }),
                                  ),
                                ],
                              );
                            }
                            if (homeFeed.data![index - 1] is BannerAd) {
                              return const Padding(
                                padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 20,
                                ),
                                child: NativeInlineAd(),
                              );
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
            return homeShimmer();
          },
        ));
      },
    );
  }

  Widget bookList({required BookModel book}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
      ),
      child: BookCard(
        buttonText:
            authService.currentUser()!.uid == book.uploaderId ? 'Edit' : 'View',
        id: book.bookId,
        book: book,
        onClicked: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => BookViewer(
                id: book.bookId,
                book: book,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<Object>?> getFeed() async {
    final books = await apiService.getBooks();
    setState(() {
      homeFeed = List.from(books!);
    });
    MobileAds.instance.initialize().then((value) {
      setState(() {
        for (int i = homeFeed.length - 2; i >= 1; i -= 10) {
          homeFeed.insert(i, _ad);
        }
      });
    });

    return homeFeed;
  }

  void _onRefresh() async {
    setState(() {
      homeFeed.clear();
      feed = getFeed();
      _refreshController.refreshCompleted();
    });
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  Future<void> getCurrentLocation() async {
    final currentLocation =
        await locationService.determinePosition(context: context);
    List<Placemark> placeMarks = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);

    Placemark place = placeMarks[0];
    setState(() {
      this.currentLocation =
          '${place.locality}, ${place.administrativeArea}, ${place.country}';
    });
  }
}
