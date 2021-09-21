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

import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OutLinedButton extends StatelessWidget {
  final double? outlineWidth;
  final Color? outlineColor;
  final String text;
  final Color? textColor;
  final IconData? icon;
  final Color? iconColor;
  final Alignment? align;
  final bool showText;
  final bool showIcon;
  final bool? inverted;
  final Function onPressed;
  final Color? backgroundColor;
  final MainAxisAlignment? alignContent;
  final double? spaceBetween;

  const OutLinedButton({
    Key? key,
    this.outlineWidth = 1.0,
    this.outlineColor = ColorsConstant.accentColor,
    required this.onPressed,
    this.backgroundColor = ColorsConstant.lightThemeButtonColor,
    required this.text,
    this.icon,
    required this.showText,
    required this.showIcon,
    this.align = Alignment.center,
    this.iconColor = ColorsConstant.accentColor,
    this.textColor = ColorsConstant.accentColor,
    this.inverted = false,
    this.alignContent = MainAxisAlignment.center,
    this.spaceBetween = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double borderRadius = ValuesConstant.secondaryBorderRadius;
    return Container(
      alignment: align,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () {
          onPressed();
        },
        child: Container(
          alignment: align,
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
            right: 8,
            left: showIcon ? 20 : 8,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: outlineColor!,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: inverted!
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: alignContent!,
                  children: [
                    Visibility(
                      visible: showText,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 100,
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            fontWeight:
                                Theme.of(context).textTheme.button!.fontWeight,
                            fontSize:
                                Theme.of(context).textTheme.button!.fontSize,
                            fontStyle:
                                Theme.of(context).textTheme.button!.fontStyle,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: showIcon && showText,
                      child: SizedBox(
                        width: spaceBetween,
                      ),
                    ),
                    Visibility(
                      visible: showIcon,
                      child: Icon(
                        icon,
                        color: iconColor,
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: alignContent!,
                  children: [
                    Visibility(
                      visible: showIcon,
                      child: Icon(
                        icon,
                        color: iconColor,
                      ),
                    ),
                    Visibility(
                      visible: showIcon && showText,
                      child: SizedBox(
                        width: spaceBetween,
                      ),
                    ),
                    Visibility(
                      visible: showText,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: showIcon ? 3 : 0,
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            fontWeight:
                                Theme.of(context).textTheme.button!.fontWeight,
                            fontSize:
                                Theme.of(context).textTheme.button!.fontSize,
                            fontStyle:
                                Theme.of(context).textTheme.button!.fontStyle,
                            color: textColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
