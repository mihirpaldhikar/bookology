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

import 'package:flutter/material.dart';

class PageViewIndicator extends StatefulWidget {
  ///[length] is how match pages in the [PageView].
  final int length;

  ///[currentIndex] is a current index of the [PageView].
  final int currentIndex;

  ///[currentColor] is a current index color of the [PageView].
  final Color currentColor;

  ///[otherColor] is a other index color of the [PageView].
  final Color otherColor;

  ///[currentSize] define the indicators size of the [currentIndex],
  /// the default value is [15.0].
  final double currentSize;

  ///[otherSize] define the indicators size of the [otherItem],
  /// the default value is [8.0].
  final double otherSize;

  ///[margin] is a margin around each indicator,
  /// the default value is [EdgeInsets.all(5)].
  final EdgeInsets? margin;

  ///[borderRadius] Defines a border radius of each indicator,
  /// the default value is [BorderRadius.circular(9999)].
  final double? borderRadius;

  ///[alignment] is a normal alignment, define How the children should be placed
  ///along the main axis in a flex layout,
  ///the default value is [MainAxisAlignment.center].
  final MainAxisAlignment alignment;

  ///[animationDuration] Defines how long does the animation,
  /// the default value is [500 milliseconds].
  final Duration? animationDuration;

  ///[orientation] Defines the indicators orientation,
  /// the default value is [Axis.horizontal].
  final Axis orientation;

  const PageViewIndicator({
    Key? key,
    required this.length,
    required this.currentIndex,
    this.currentColor = Colors.blue,
    this.otherColor = Colors.grey,
    this.currentSize = 15.0,
    this.otherSize = 8.0,
    this.margin,
    this.borderRadius = 9999,
    this.alignment = MainAxisAlignment.center,
    this.animationDuration = const Duration(milliseconds: 500),
    this.orientation = Axis.horizontal,
  }) : super(key: key);

  @override
  _PageViewIndicatorState createState() => _PageViewIndicatorState();
}

class _PageViewIndicatorState extends State<PageViewIndicator> {
  Color getColor(int index) {
    if (index == widget.currentIndex) return widget.currentColor;
    return widget.otherColor;
  }

  double getDotSize(int index) {
    if (index == widget.currentIndex) return widget.currentSize;
    return widget.otherSize;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> indicators = <Widget>[];
    for (int index = 0; index < widget.length; index++) {
      indicators.add(
        AnimatedContainer(
          duration: widget.animationDuration!,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
            color: getColor(index),
          ),
          margin: widget.margin ?? const EdgeInsets.all(5),
          width: getDotSize(index),
          height: getDotSize(index),
        ),
      );
    }
    if (widget.orientation != Axis.horizontal) {
      return Column(
        mainAxisAlignment: widget.alignment,
        children: indicators,
      );
    }
    return Row(
      mainAxisAlignment: widget.alignment,
      children: indicators,
    );
  }
}
