import 'package:flutter/material.dart';

class BottomAppBarItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final String tooltip;
  final VoidCallback onPressed;

  const BottomAppBarItem({
    Key? key,
    required this.icon,
    required this.tooltip,
    required this.isActive,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              color: isActive ? Theme.of(context).accentColor : Colors.grey,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
