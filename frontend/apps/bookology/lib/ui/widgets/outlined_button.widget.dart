import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OutLinedButton extends StatelessWidget {
  final double? outlineWidth;
  final Color outlineColor;
  final Widget child;
  final Function onPressed;

  const OutLinedButton({
    Key? key,
    this.outlineWidth = 2.0,
    required this.child,
    required this.outlineColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double borderRadius = 15;
    return Container(
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () {
          onPressed();
        },
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
            right: 8,
            left: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: this.outlineColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: child,
        ),
      ),
    );
  }
}