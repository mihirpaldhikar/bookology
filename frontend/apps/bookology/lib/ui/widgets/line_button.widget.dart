import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LineButton extends StatelessWidget {
  final double? outlineWidth;
  final double? spaceInBetween;
  final Color outlineColor;
  final Color? textColor;
  final Color? iconColor;
  final IconData? icon;
  final String text;
  final Function onPressed;
  final EdgeInsets? margin;

  const LineButton({
    Key? key,
    this.outlineWidth = 2.0,
    this.icon,
    required this.text,
    required this.outlineColor,
    this.textColor = Colors.black,
    this.iconColor = Colors.black,
    this.spaceInBetween = 0,
    this.margin,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        margin: this.margin,
        padding: EdgeInsets.only(
          top: 10,
          bottom: 10,
          right: 8,
          left: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: this.outlineColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(
              this.icon,
              color: this.iconColor,
            ),
            SizedBox(
              width: this.spaceInBetween,
            ),
            Center(
              child: Text(
                this.text,
                style: TextStyle(
                  color: this.textColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
