import 'dart:async';

import 'package:bookology/enums/connectivity.enum.dart';
import 'package:bookology/managers/native_ads.manager.dart';
import 'package:bookology/models/book.model.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/connectivity.service.dart';
import 'package:bookology/services/location.service.dart';
import 'package:bookology/ui/components/home_shimmer.component.dart';
import 'package:bookology/ui/components/search_bar.component.dart';
import 'package:bookology/ui/screens/book_view.screen.dart';
import 'package:bookology/ui/screens/offline.screen.dart';
import 'package:bookology/ui/widgets/book_card.widget.dart';
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
  late StreamSubscription subscription;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final apiService = new ApiService();
  final locationService = new LocationService();

  List<BookModel> books = [];
  late BannerAd _ad;
  List<Object> listObj = [];
  String userName = '';
  String displayName = '';
  String profileImageURL = '';
  String currentLocation = '';
  bool isVerified = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _ad.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
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

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
      request: AdRequest(),
    );

    _ad.load();

    getCurrentLocation().then((_) {
      _fetchUserData().then(
        (value) {
          setState(() {
            listObj = List.from(value);
          });
          MobileAds.instance.initialize().then((value) {
            setState(() {
              for (int i = listObj.length - 2; i >= 1; i -= 10) {
                listObj.insert(i, _ad);
              }
            });
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityStatus>(
      initialData: ConnectivityStatus.Cellular,
      stream: ConnectivityService().connectionStatusController.stream,
      builder:
          (BuildContext context, AsyncSnapshot<ConnectivityStatus> snapshot) {
        if (snapshot.data == ConnectivityStatus.Offline) {
          return OfflineScreen();
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: SafeArea(
              child: SearchBar(),
            ),
          ),
          body: _isLoading
              ? homeShimmer()
              : Container(
                  color: Colors.white,
                  child: SmartRefresher(
                    controller: _refreshController,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    enablePullDown: true,
                    header: ClassicHeader(),
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: listObj.length + 1,
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 10,
                      ),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Container(
                            margin: EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              left: 10,
                              right: 10,
                            ),
                            child: Chip(
                              padding: EdgeInsets.all(10),
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                color: Theme.of(context).accentColor,
                                width: 1,
                              ),
                              label: Row(
                                children: [
                                  Icon(Icons.place_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(currentLocation),
                                ],
                              ),
                            ),
                          );
                        } else {
                          if (listObj[index - 1] is BannerAd) {
                            return NativeInlineAd();
                          } else {
                            return bookList(
                              bookModel: listObj[index - 1] as BookModel,
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget bookList({required BookModel bookModel}) {
    return BookCard(
      bookID: bookModel.bookId.toString(),
      bookName: bookModel.bookInformation.name.toString(),
      originalPrice: bookModel.pricing.originalPrice.toString(),
      sellingPrice: bookModel.pricing.sellingPrice.toString(),
      coverImageURL: bookModel.additionalInformation.images[0],
      bookAuthor: bookModel.bookInformation.author.toString(),
      onClicked: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => BookViewer(
              bookID: bookModel.bookId.toString(),
              isbn: bookModel.bookInformation.isbn.toString(),
              uploaderID: bookModel.uploaderId.toString(),
              bookAuthor: bookModel.bookInformation.author.toString(),
              bookDescription:
                  bookModel.additionalInformation.description.toString(),
              bookName: bookModel.bookInformation.name.toString(),
              bookPublished: bookModel.bookInformation.publisher.toString(),
              images: bookModel.additionalInformation.images,
              originalPrice: bookModel.pricing.originalPrice.toString(),
              sellingPrice: bookModel.pricing.sellingPrice.toString(),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _fetchUserData() async {
    final data = await apiService.getBooks();
    setState(() {
      _isLoading = false;

      for (int i = 0; i < data.length; i++) {
        books.add(BookModel.fromJson(data[i]));
      }
    });
    return books;
  }

  void _onRefresh() async {
    setState(() {
      books.clear();
    });
    _fetchUserData().then(
      (value) => {
        listObj = List.from(value),
        MobileAds.instance.initialize().then((value) {
          setState(() {
            for (int i = listObj.length - 2; i >= 1; i -= 10) {
              listObj.insert(i, _ad);
            }
          });
        }),
        _refreshController.refreshCompleted()
      },
    );
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
