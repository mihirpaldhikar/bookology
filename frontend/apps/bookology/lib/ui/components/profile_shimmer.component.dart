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

import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/models/user.model.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget profileShimmer(AsyncSnapshot<UserModel> userData) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    physics: const BouncingScrollPhysics(),
    itemCount: 6,
    itemBuilder: (context, index) {
      if (index == 0) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: CircularImage(
                    image:
                        FirebaseAuth.instance.currentUser!.photoURL.toString(),
                    radius: 90,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius:
                          BorderRadius.circular(ValuesConstant.borderRadius),
                    ),
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(ValuesConstant.borderRadius),
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '       ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '       ',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius:
                          BorderRadius.circular(ValuesConstant.borderRadius)),
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(ValuesConstant.borderRadius),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '       ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            '       ',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FirebaseAuth.instance.currentUser!.displayName.toString(),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Theme.of(context).colorScheme.onBackground),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 250,
                    child: Text(
                      '',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      } else {
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
      }
    },
  );
}
