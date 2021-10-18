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

import 'dart:io';

import 'package:flutter/material.dart';

class ImagePlaceholder extends StatefulWidget {
  final VoidCallback onPressed;

  const ImagePlaceholder({Key? key, required this.onPressed}) : super(key: key);

  @override
  _ImagePlaceholderState createState() => _ImagePlaceholderState();
}

class _ImagePlaceholderState extends State<ImagePlaceholder> {
  @override
  Widget build(BuildContext context) {
    const double _borderRadius = 15;
    return Container(
      width: 120,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: Theme.of(context).buttonTheme.colorScheme!.background,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(_borderRadius),
        onTap: widget.onPressed,
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class ImageHolder extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback onCancelled;
  final String imageURL;
  final bool showCloseButton;

  const ImageHolder({
    Key? key,
    required this.onPressed,
    required this.onCancelled,
    required this.imageURL,
    this.showCloseButton = true,
  }) : super(key: key);

  @override
  _ImageHolderState createState() => _ImageHolderState();
}

class _ImageHolderState extends State<ImageHolder> {
  @override
  Widget build(BuildContext context) {
    const double _borderRadius = 15;
    return Container(
      width: 120,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            child: InkWell(
              onTap: widget.onPressed,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  child: Image.file(
                    File.fromUri(
                      Uri.parse(widget.imageURL),
                    ),
                    width: 120,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.showCloseButton,
            child: Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: widget.onCancelled,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.showCloseButton,
            child: Positioned(
              bottom: 10,
              right: 5,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.fullscreen_outlined,
                  size: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
