import 'package:bookology/managers/native_ads.manager.dart';
import 'package:bookology/models/book.model.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/services/location.service.dart';
import 'package:bookology/ui/components/account_dialog.component.dart';
import 'package:bookology/ui/components/search_bar.component.dart';
import 'package:bookology/ui/screens/book_view.screen.dart';
import 'package:bookology/ui/screens/verify_email.screen.dart';
import 'package:bookology/ui/widgets/book_card.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final apiService = new ApiService();
  final locationService = new LocationService();
  final cacheService = CacheService();
  List<BookModel> books = [];
  bool _isLoading = true;
  late BannerAd _ad;
  List<Object> listObj = [];
  String userName = '';
  String displayName = '';
  String profileImageURL = '';
  String currentLocation = '';
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return auth.isEmailVerified() != true
        ? VerifyEmailScreen()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(120),
              child: SafeArea(
                child: SearchBar(onDrawerClicked: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          height: 500,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Container(
                                width: 50,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AccountDialog(
                                      username: cacheService
                                          .getCurrentUserNameCache(),
                                      displayName: auth
                                          .currentUser()!
                                          .displayName
                                          .toString(),
                                      isVerified: cacheService
                                          .getCurrentIsVerifiedCache(),
                                      profileImageURL: auth
                                          .currentUser()!
                                          .photoURL
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                }),
              ),
            ),
            body: _isLoading
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: 5,
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
                          ),
                          child: Chip(
                            padding: EdgeInsets.all(10),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            label: Shimmer.fromColors(
                              enabled: true,
                              baseColor: Color(0xFFE0E0E0),
                              highlightColor: Color(0xFFF5F5F5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.place_outlined,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 150,
                                    height: 15,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 250,
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(
                            bottom: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Shimmer.fromColors(
                              enabled: true,
                              baseColor: Color(0xFFE0E0E0),
                              highlightColor: Color(0xFFF5F5F5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: 150,
                                          height: 15,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width: 120,
                                          height: 15,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          width: 140,
                                          height: 10,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 10,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 30,
                                              height: 10,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 30,
                                              height: 10,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          width: 100,
                                          height: 10,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: 170,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        );
                      }
                    },
                  )
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
    print('loading');
    _refreshController.loadComplete();
  }

  Future<void> getCurrentLocation() async {
    final currentLocation =
        await locationService.determinePosition(context: context);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);

    Placemark place = placemarks[0];
    setState(() {
      this.currentLocation =
          '${place.locality}, ${place.administrativeArea}, ${place.country}';
    });
  }
}
