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

class CollapsableAppBar extends StatefulWidget {
  final String title;
  final Widget body;
  final bool? automaticallyImplyLeading;

  const CollapsableAppBar({
    Key? key,
    required this.title,
    required this.body,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  _CollapsableAppBarState createState() => _CollapsableAppBarState();
}

class _CollapsableAppBarState extends State<CollapsableAppBar> {
  var top = 0.0;
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: widget.automaticallyImplyLeading!,
            //titleSpacing: 0,
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                top = constraints.biggest.height;
                if (top <= 92.36363636363637 || top <= 140.63636363636238) {
                  isCollapsed = true;
                } else {
                  isCollapsed = false;
                }
                return FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                    left: widget.automaticallyImplyLeading!
                        ? isCollapsed
                            ? 60
                            : 20
                        : 20,
                    bottom: 15,
                  ),
                  title: Text(
                    widget.title,
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                );
              },
            ),
          ),
        ];
      },
      body: Padding(
        padding: EdgeInsets.only(
          top: isCollapsed ? 65 : 0,
        ),
        child: widget.body,
      ),
    );
  }
}
