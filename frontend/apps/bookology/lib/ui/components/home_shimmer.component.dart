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
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget homeShimmer() {
  return ListView.builder(
    physics: const BouncingScrollPhysics(),
    itemCount: 5,
    padding: const EdgeInsets.only(
      left: 15,
      right: 15,
      top: 10,
    ),
    itemBuilder: (context, index) {
      if (index == 0) {
        return Container(
          height: 250.0,
          width: double.infinity,
          color: Colors.transparent,
          child: Stack(
            children: [
              Shimmer.fromColors(
                enabled: true,
                baseColor: const Color(0xFFE0E0E0),
                highlightColor: const Color(0xFFF5F5F5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                              bottom: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  ValuesConstant.secondaryBorderRadius),
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
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 150,
                                  height: 15,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 15,
                            top: 6,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 25,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 5,
                            top: 6,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Icon(
                              Icons.notifications_outlined,
                              size: 25,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            height: 15,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 200,
                            height: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          height: 250,
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(
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
              baseColor: const Color(0xFFE0E0E0),
              highlightColor: const Color(0xFFF5F5F5),
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
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 150,
                          height: 15,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 120,
                          height: 15,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 140,
                          height: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 10,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 30,
                              height: 10,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 30,
                              height: 10,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 100,
                          height: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 170,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                ValuesConstant.secondaryBorderRadius),
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
  );
}
