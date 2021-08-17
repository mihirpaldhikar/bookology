import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget OfflineScreen() {
  return Scaffold(
    body: Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/offline.svg',
            width: 200,
            height: 200,
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            'No Network!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'The content will automatically be loaded once network '
            'connection is available.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
