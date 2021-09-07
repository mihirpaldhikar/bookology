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

import 'dart:math';

import 'package:badges/badges.dart';
import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/services/location.service.dart';
import 'package:bookology/ui/screens/create.screen.dart';
import 'package:bookology/ui/screens/notifications.screen.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  final String currentLocation;

  const SearchBar({
    Key? key,
    required this.currentLocation,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final cacheService = CacheService();
  final locationService = new LocationService();
  var top = 0.0;
  bool isCollapsed = false;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          top = constraints.biggest.height;
          if (top == 56.0) {
            isCollapsed = true;
          } else {
            isCollapsed = false;
          }
          return FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 10,
            ),
            title: Visibility(
                visible: isCollapsed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        StringConstants.APP_NAME,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle!
                              .fontSize,
                          fontWeight: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle!
                              .fontWeight,
                          fontFamily: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle!
                              .fontFamily,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Spacer(),
                    Tooltip(
                      message: 'Upload New Book',
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: 20,
                          top: 6,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              color: ColorsConstant.SECONDARY_COLOR,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tooltip(
                      message: 'Notifications',
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 5,
                            top: 6,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              color: ColorsConstant.SECONDARY_COLOR,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Badge(
                              showBadge: true,
                              toAnimate: false,
                              badgeColor: Colors.red,
                              elevation: 0,
                              badgeContent: Text(
                                '9+',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                              child: Icon(
                                Icons.notifications_outlined,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
            background: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 5,
              ),
              height: 250.0,
              decoration: BoxDecoration(
                color: ColorsConstant.SECONDARY_COLOR,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(ValuesConstant.BORDER_RADIUS),
                  bottomRight: Radius.circular(ValuesConstant.BORDER_RADIUS),
                ),
              ),
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.1,
                    child: SvgPicture.asset(
                      'assets/svg/books.svg',
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                            ),
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 5,
                                bottom: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    ValuesConstant.SECONDARY_BORDER_RADIUS),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.place_outlined,
                                    color: Colors.grey.shade900,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    widget.currentLocation,
                                    style: TextStyle(
                                      color: Colors.grey.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Tooltip(
                            message: 'Upload New Book',
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 15,
                                top: 6,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Tooltip(
                            message: 'Notifications',
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationScreen(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: 5,
                                  top: 6,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Badge(
                                    showBadge: true,
                                    toAnimate: false,
                                    badgeColor: Colors.red,
                                    elevation: 0,
                                    badgeContent: Text(
                                      '9+',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.notifications_outlined,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CircularImage(
                        outLineWidth: 2,
                        outlineColor: Colors.black,
                        image: auth.currentUser()!.photoURL.toString(),
                        radius: 75,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'Good ${greeting()},\n',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'YoutubeSans',
                            ),
                            children: [
                              TextSpan(
                                text: '${auth.currentUser()!.displayName}!',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontFamily: 'YoutubeSans',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 16) {
      return 'Afternoon';
    }
    return 'Evening';
  }
}

class BackendService {
  static Future<List<Map<String, String>>> getSuggestions(String query) async {
    await Future.delayed(Duration(seconds: 1));

    return List.generate(3, (index) {
      return {
        'name': query + index.toString(),
        'price': Random().nextInt(100).toString()
      };
    });
  }
}

class CitiesService {
  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(StringConstants.CITIES);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
