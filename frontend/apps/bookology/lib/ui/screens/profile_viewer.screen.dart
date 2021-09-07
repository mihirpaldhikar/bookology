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

import 'package:bookology/models/user.model.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/screens/book_view.screen.dart';
import 'package:bookology/ui/screens/create.screen.dart';
import 'package:bookology/ui/widgets/book_card.widget.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_ns/liquid_progress_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileViewer extends StatefulWidget {
  const ProfileViewer({Key? key}) : super(key: key);

  @override
  _ProfileViewerState createState() => _ProfileViewerState();
}

class _ProfileViewerState extends State<ProfileViewer> {
  UserModel user = UserModel(
    additionalInformation: AdditionalInformation(
      suspended: false,
      emailVerified: false,
    ),
    books: [],
    joinedOn: JoinedOn(
      date: '',
      time: '',
    ),
    providers: Providers(
      auth: '',
    ),
    slugs: Slugs(
      username: '',
      firstName: '',
      lastName: '',
    ),
    userId: '',
    userInformation: UserInformation(
      username: '',
      lastName: '',
      firstName: '',
      bio: '',
      email: '',
      profilePicture: '',
      verified: false,
    ),
  );
  String userName = '';
  String profileImage = '';
  bool isCurrentUser = false;
  int booksListed = 0;
  List books = [];
  final apiService = new ApiService();
  final authService = new AuthService(FirebaseAuth.instance);
  final cacheService = new CacheService();
  bool _isLoading = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              userName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Visibility(
              visible: user.userInformation!.verified,
              child: Icon(
                Icons.verified,
                color: Colors.blue,
                size: 20,
              ),
            ),
          ],
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
                      builder: (context) => CreateScreen(),
                    ),
                  );
                },
                icon: Container(
                  width: 40,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      )),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Tooltip(
            message: 'Settings',
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          child: _isLoading
              ? Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    child: LiquidCircularProgressIndicator(
                      value: 0.35,
                      valueColor:
                          AlwaysStoppedAnimation(Theme.of(context).accentColor),
                      backgroundColor: Colors.white,
                      borderColor: Colors.deepPurple,
                      borderWidth: 5.0,
                      direction: Axis.vertical,
                      center: Text("Loading..."),
                    ),
                  ),
                )
              : Container(
                  child: SmartRefresher(
                    controller: _refreshController,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    enablePullDown: true,
                    header: ClassicHeader(),
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemCount: user.books!.length + 1,
                        itemBuilder: (context, index) {
                          return index == 0
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        CircularImage(
                                          image: user
                                              .userInformation!.profilePicture
                                              .toString(),
                                          radius: 90,
                                        ),
                                        SizedBox(
                                          width: 100,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              user.books!.length.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30),
                                            ),
                                            Text('Books'),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${user.userInformation!.firstName.toString()} ${user.userInformation!.lastName.toString()}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(user.userInformation!.bio
                                              .toString())
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Visibility(
                                      visible: isCurrentUser,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : BookCard(
                                  bookID:
                                      '${user.books![index - 1].bookId.toString()}@${index.toString()}',
                                  bookName: user
                                      .books![index - 1].bookInformation!.name
                                      .toString(),
                                  coverImageURL: user.books![index - 1]
                                      .additionalInformation!.images![0],
                                  originalPrice: user
                                      .books![index - 1].pricing!.originalPrice
                                      .toString(),
                                  sellingPrice: user
                                      .books![index - 1].pricing!.sellingPrice
                                      .toString(),
                                  bookAuthor: user
                                      .books![index - 1].bookInformation!.author
                                      .toString(),
                                  onClicked: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            BookViewer(
                                          bookID:
                                              '${user.books![index - 1].bookId.toString()}@${index.toString()}',
                                          isbn: user.books![index - 1]
                                              .bookInformation!.isbn,
                                          uploaderID: user
                                              .books[index - 1].uploaderId
                                              .toString(),
                                          bookAuthor: user.books![index - 1]
                                              .bookInformation!.author
                                              .toString(),
                                          bookDescription: user
                                              .books![index - 1]
                                              .additionalInformation!
                                              .description
                                              .toString(),
                                          bookName: user.books![index - 1]
                                              .bookInformation!.name
                                              .toString(),
                                          bookPublished: user.books![index - 1]
                                              .bookInformation!.publisher
                                              .toString(),
                                          images: user.books![index - 1]
                                              .additionalInformation!.images,
                                          originalPrice: user.books![index - 1]
                                              .pricing!.originalPrice
                                              .toString(),
                                          sellingPrice: user.books![index - 1]
                                              .pricing!.sellingPrice
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  });
                        }),
                  ),
                ),
        ),
      ),
    );
  }

  _fetchUserData() async {
    final data =
        await apiService.getUserProfile(userID: authService.currentUser()!.uid);
    setState(() {
      _isLoading = false;
    });
    if (cacheService.getCurrentUserNameCache() ==
        user.userInformation.username) {
      setState(() {
        isCurrentUser = true;
      });
    } else {
      setState(() {
        isCurrentUser = false;
      });
    }
  }

  void _onRefresh() async {
    await _fetchUserData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    print('loading');
    _refreshController.loadComplete();
  }
}
