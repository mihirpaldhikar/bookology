import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final String image;
  final double radius;

  const CircularImage({
    Key? key,
    required this.image,
    required this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: this.image,
        fit: BoxFit.fill,
        height: this.radius,
        width: this.radius,
      ),
    );
  }
}
