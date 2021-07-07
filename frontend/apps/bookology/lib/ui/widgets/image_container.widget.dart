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
    final double _borderRadius = 15;
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(_borderRadius),
        onTap: widget.onPressed,
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.grey,
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
    final double _borderRadius = 15;
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            child: InkWell(
              onTap: widget.onPressed,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_borderRadius),
                child: Image.file(
                  File.fromUri(
                    Uri.parse(widget.imageURL),
                  ),
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.showCloseButton,
            child: Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: widget.onCancelled,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
