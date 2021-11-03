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

import 'dart:math';

import 'package:badges/badges.dart';
import 'package:blobs/blobs.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/screens/create.screen.dart';
import 'package:bookology/ui/screens/notifications.screen.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeBar extends StatefulWidget {
  final String currentLocation;

  const HomeBar({
    Key? key,
    required this.currentLocation,
  }) : super(key: key);

  @override
  _HomeBarState createState() => _HomeBarState();
}

class _HomeBarState extends State<HomeBar> {
  final cacheService = CacheService();
  var top = 0.0;
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(
        FocusNode(),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          top = constraints.biggest.height;
          if (top == 56.0) {
            isCollapsed = true;
          } else {
            isCollapsed = false;
          }
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(
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
                        StringConstants.appName,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      ),
                    ),
                    const Spacer(),
                    Tooltip(
                      message: 'Upload New Book',
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 20,
                          top: 6,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(
                              Icons.add,
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
                    Tooltip(
                      message: 'Notifications',
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 5,
                            top: 6,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
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
                    )
                  ],
                )),
            background: Container(
              height: 250.0,
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(ValuesConstant.borderRadius),
                  bottomRight: Radius.circular(ValuesConstant.borderRadius),
                ),
              ),
              child: Stack(
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
                    bottom: -180,
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
                    bottom: -210,
                    right: -190,
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                      bottom: 5,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              StringConstants.appName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const Spacer(),
                            Tooltip(
                              message: 'Upload New Book',
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 15,
                                  top: 6,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CreateScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add,
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
                            Tooltip(
                              message: 'Notifications',
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationScreen(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 5,
                                    top: 6,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
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
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        CircularImage(
                          outLineWidth: 0.5,
                          outlineColor: Theme.of(context).colorScheme.primary,
                          image: auth.currentUser()!.photoURL.toString(),
                          radius: 75,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: 'Good ${greeting()},\n',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              children: [
                                TextSpan(
                                  text: '${auth.currentUser()!.displayName}!',
                                  style: GoogleFonts.poppins(
                                    color: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );

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
    matches.addAll(StringConstants.listCities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
