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
    return CircleAvatar(
      radius: this.radius,
      backgroundColor: Colors.grey[200],
      backgroundImage: NetworkImage(this.image),
    );
  }
}
