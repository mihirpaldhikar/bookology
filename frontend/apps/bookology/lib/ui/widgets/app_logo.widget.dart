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

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final bool? isSloganVisible;
  final BuildContext context;

  const AppLogo({
    Key? key,
    required this.context,
    this.isSloganVisible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(
              ValuesConstant.secondaryBorderRadius,
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: ValuesConstant.outlineWidth,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(ValuesConstant.secondaryBorderRadius),
            child: Icon(
              Icons.book,
              color: Theme.of(context).colorScheme.primary,
              size: 80,
            ),
          ),
        ),
        Visibility(
          visible: isSloganVisible!,
          child: const SizedBox(
            height: 20,
          ),
        ),
        Visibility(
          visible: isSloganVisible!,
          child: AnimatedTextKit(
            totalRepeatCount: 1,
            displayFullTextOnTap: true,
            animatedTexts: [
              TyperAnimatedText(
                StringConstants.appSlogan,
                speed: const Duration(
                  milliseconds: 100,
                ),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
