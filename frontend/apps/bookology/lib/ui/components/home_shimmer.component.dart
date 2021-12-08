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

import 'package:badges/badges.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/ui/components/collapsable_app_bar.component.dart';
import 'package:bookology/ui/screens/create.screen.dart';
import 'package:bookology/ui/screens/notifications.screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/strings.constant.dart';

Widget homeShimmer(BuildContext context, int selectedCategory) {
  return CollapsableAppBar(
    title: 'Bookology',
    automaticallyImplyLeading: false,
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
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.add,
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
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
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            icon: Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
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
                  color: Theme.of(context).buttonTheme.colorScheme!.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
    body: ListView.builder(
      cacheExtent: 9999999999999999999999999.0,
      physics: const BouncingScrollPhysics(),
      itemCount: 3,
      padding: const EdgeInsets.only(
        left: 0,
        right: 0,
        top: 10,
      ),
      itemBuilder: (context, index) {
        if (index == 0) {
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
              itemBuilder: (context, categoryIndex) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 23,
                  ),
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(ValuesConstant.borderRadius),
                    onTap: () async {},
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 5,
                        bottom: 5,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: categoryIndex == selectedCategory
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
                        borderRadius:
                            BorderRadius.circular(ValuesConstant.borderRadius),
                        border: Border.all(
                          color: categoryIndex == selectedCategory
                              ? Colors.transparent
                              : Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        StringConstants.listBookCategories[categoryIndex],
                        style: TextStyle(
                          color: categoryIndex == selectedCategory
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
        return Card(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              top: 30,
              bottom: 20,
              left: 17,
              right: 17,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(ValuesConstant.borderRadius),
            ),
            child: Shimmer.fromColors(
              enabled: true,
              baseColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1D1C1C)
                  : const Color(0xFFE0E0E0),
              highlightColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF3B3B3B)
                  : const Color(0xFFF5F5F5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 170,
                        height: 13,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 170,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 10,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 20,
                        height: 10,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 20,
                        height: 10,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 100,
                    height: 10,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
