
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
  final Color? backgroundColo;
  final MainAxisAlignment? alignContent;
  final double? spaceBetween;

  const OutLinedButton({
    Key? key,
    this.outlineWidth = 2.0,
    this.outlineColor = ColorsConstant.ACCENT_COLOR,
    required this.onPressed,
    this.backgroundColo = ColorsConstant.SECONDARY_COLOR,
    required this.text,
    this.icon,
    required this.showText,
    required this.showIcon,
    this.align = Alignment.center,
    this.iconColor = ColorsConstant.ACCENT_COLOR,
    this.textColor = ColorsConstant.ACCENT_COLOR,
    this.inverted = false,
    this.alignContent = MainAxisAlignment.center,
    this.spaceBetween = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double borderRadius = ValuesConstant.SECONDARY_BORDER_RADIUS;
    return Container(
      alignment: this.align,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () {
          onPressed();
        },
        child: Container(
          alignment: this.align,
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
            right: 8,
            left: 8,
          ),
          decoration: BoxDecoration(
            color: this.backgroundColo,
            border: Border.all(
              color: this.outlineColor!,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: this.inverted!
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: this.alignContent!,
                  children: [
                    Visibility(
                      visible: this.showText,
                      child: Text(
                        this.text,
                        style: TextStyle(
                          fontWeight:
                              Theme.of(context).textTheme.button!.fontWeight,
                          fontSize:
                              Theme.of(context).textTheme.button!.fontSize,
                          fontStyle:
                              Theme.of(context).textTheme.button!.fontStyle,
                          color: this.textColor,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: this.showIcon && this.showText,
                      child: SizedBox(
                        width: this.spaceBetween,
                      ),
                    ),
                    Visibility(
                      visible: this.showIcon,
                      child: Icon(
                        this.icon,
                        color: this.iconColor,
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: this.alignContent!,
                  children: [
                    Visibility(
                      visible: this.showIcon,
                      child: Icon(
                        this.icon,
                        color: this.iconColor,
                      ),
                    ),
                    Visibility(
                      visible: this.showIcon && this.showText,
                      child: SizedBox(
                        width: this.spaceBetween,
                      ),
                    ),
                    Visibility(
                      visible: this.showText,
                      child: Text(
                        this.text,
                        style: TextStyle(
                          fontWeight:
                              Theme.of(context).textTheme.button!.fontWeight,
                          fontSize:
                              Theme.of(context).textTheme.button!.fontSize,
                          fontStyle:
                              Theme.of(context).textTheme.button!.fontStyle,
                          color: this.textColor,
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
