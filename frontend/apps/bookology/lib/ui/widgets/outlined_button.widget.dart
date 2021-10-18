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

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OutLinedButton extends StatefulWidget {
  final double? outlineWidth;
  final String text;
  final Color? textColor;
  final IconData? icon;
  final Color? iconColor;
  final Alignment? align;
  final bool? inverted;
  final Function onPressed;
  final Color? backgroundColor;
  final MainAxisAlignment? alignContent;
  final double? spaceBetween;

  const OutLinedButton({
    Key? key,
    this.outlineWidth = 1.0,
    required this.onPressed,
    this.backgroundColor = ColorsConstant.lightThemeButtonColor,
    required this.text,
    this.icon,
    this.align = Alignment.center,
    this.iconColor = ColorsConstant.lightAccentColor,
    this.textColor = ColorsConstant.lightThemeContentColor,
    this.inverted = false,
    this.alignContent = MainAxisAlignment.center,
    this.spaceBetween = 20,
  }) : super(key: key);

  @override
  State<OutLinedButton> createState() => _OutLinedButtonState();
}

class _OutLinedButtonState extends State<OutLinedButton> {
  Color backgroundColor = Colors.transparent;
  Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    const double borderRadius = ValuesConstant.secondaryBorderRadius;
    return ValueListenableBuilder(
        valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
        builder: (_, mode, child) {
          if (widget.backgroundColor.hashCode == 4290502395) {
            backgroundColor =
                Theme.of(context).buttonTheme.colorScheme!.background;
            textColor = Theme.of(context).buttonTheme.colorScheme!.primary;
          } else {
            backgroundColor = widget.backgroundColor!;
            textColor = widget.textColor!;
          }

          return Container(
            alignment: widget.align,
            child: InkWell(
              borderRadius: BorderRadius.circular(borderRadius),
              onTap: () {
                widget.onPressed();
              },
              child: Container(
                alignment: widget.align,
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  right: 8,
                  left: widget.icon.hashCode != 2011 ? 20 : 8,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: widget.inverted!
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: widget.alignContent!,
                        children: [
                          Visibility(
                            visible: widget.text.hashCode != 2011,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 100,
                              ),
                              child: Text(
                                widget.text,
                                style: TextStyle(
                                  fontWeight: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .fontWeight,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .fontSize,
                                  fontStyle: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .fontStyle,
                                  color: widget.textColor,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.icon.hashCode != 2011 &&
                                widget.text.hashCode != 2011,
                            child: SizedBox(
                              width: widget.spaceBetween,
                            ),
                          ),
                          Visibility(
                            visible: widget.icon.hashCode != 2011,
                            child: Icon(
                              widget.icon,
                              color: widget.iconColor,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: widget.alignContent!,
                        children: [
                          Visibility(
                            visible: widget.icon.hashCode != 2011,
                            child: Icon(
                              widget.icon,
                              color: widget.iconColor,
                            ),
                          ),
                          Visibility(
                            visible: widget.icon.hashCode != 2011 &&
                                widget.text.hashCode != 2011,
                            child: SizedBox(
                              width: widget.spaceBetween,
                            ),
                          ),
                          Visibility(
                            visible: widget.text.hashCode != 2011,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: widget.text.hashCode != 2011 ? 3 : 0,
                              ),
                              child: Text(
                                widget.text,
                                style: TextStyle(
                                  fontWeight: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .fontWeight,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .fontSize,
                                  fontStyle: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .fontStyle,
                                  color: widget.textColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
              ),
            ),
          );
        });
  }
}
