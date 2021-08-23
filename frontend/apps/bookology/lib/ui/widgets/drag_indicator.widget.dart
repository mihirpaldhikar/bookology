import 'package:flutter/material.dart';

Widget dragIndicator() {
  return Container(
    width: 40,
    height: 5,
    margin: EdgeInsets.only(
      top: 10,
      bottom: 20,
    ),
    decoration: BoxDecoration(
      color: Colors.grey.shade400,
      borderRadius: BorderRadius.circular(100),
    ),
  );
}
