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

class RoundedButton extends StatefulWidget {
  final double? outlineWidth;
  final String text;
  final Color? textColor;
  final Widget? icon;
  final Alignment? align;
  final bool? inverted;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final MainAxisAlignment? alignContent;
  final double? spaceBetween;

  const RoundedButton({
    Key? key,
    this.outlineWidth = 0.0,
    required this.onPressed,
    this.backgroundColor,
    required this.text,
    this.icon,
    this.align = Alignment.center,
    this.textColor,
    this.inverted = false,
    this.alignContent = MainAxisAlignment.center,
    this.spaceBetween = 20,
  }) : super(key: key);

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  Color backgroundColor = Colors.transparent;
  Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    const double borderRadius = ValuesConstant.buttonBorderRadius;
    if (widget.backgroundColor == null) {
      backgroundColor = Colors.transparent;
    } else {
      if (widget.textColor == null) {
        textColor = Theme.of(context).colorScheme.primary;
      } else {
        backgroundColor = widget.backgroundColor!;
        textColor = widget.textColor!;
      }
    }
    return Container(
      alignment: widget.align,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: widget.onPressed,
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
            border: Border.all(
              color: widget.outlineWidth == 0.0
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.primary,
              width: widget.outlineWidth!,
            ),
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
                          top: 0,
                        ),
                        child: Text(
                          widget.text,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                Theme.of(context).textTheme.button!.fontSize,
                            fontStyle:
                                Theme.of(context).textTheme.button!.fontStyle,
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
                      child: widget.icon == null
                          ? const Visibility(
                              visible: false,
                              child: SizedBox(
                                width: 0,
                                height: 0,
                              ),
                            )
                          : widget.icon!,
                    ),
                    Visibility(
                      visible: widget.icon.hashCode != 2011 &&
                          widget.text.hashCode != 2011,
                      child: SizedBox(
                        width: widget.spaceBetween,
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
                      child: widget.icon == null
                          ? const Visibility(
                              visible: false,
                              child: SizedBox(
                                width: 0,
                                height: 0,
                              ),
                            )
                          : widget.icon!,
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
                            fontWeight: FontWeight.bold,
                            fontSize:
                                Theme.of(context).textTheme.button!.fontSize,
                            fontStyle:
                                Theme.of(context).textTheme.button!.fontStyle,
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
                  ],
                ),
        ),
      ),
    );
  }
}
